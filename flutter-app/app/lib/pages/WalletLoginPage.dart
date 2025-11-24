import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart'; // ✅ for SHA-256 hashing
import '../services/key_service.dart';
import 'WalletRegisterPage.dart';
import 'secure_card_page.dart';

class WalletLoginPage extends StatefulWidget {
  const WalletLoginPage({super.key});

  @override
  State<WalletLoginPage> createState() => _WalletLoginPageState();
}

class _WalletLoginPageState extends State<WalletLoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool loading = false;

  Future<void> login(SignatureAlgorithm algorithm) async {
    final email = emailController.text.trim();
    final rawPassword = passwordController.text.trim();

    // ✅ Hash the password
    final hashedPassword = sha256.convert(utf8.encode(rawPassword)).toString();

    final timestamp = DateTime.now().toIso8601String();
    final dataToSign = "$email:$timestamp";

    setState(() => loading = true);

    try {
      final keyService = KeyService(algorithm: algorithm);
      final hasKey = await keyService.loadSavedKeyPair();

      if (!hasKey) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "❌ No ${algorithm.name} key found. Please register first.",
            ),
          ),
        );
        setState(() => loading = false);
        return;
      }

      final signature = await keyService.signData(utf8.encode(dataToSign));
      final publicKey = await keyService.getPublicKeyBase64();

      final response = await http.post(
        Uri.parse('http://192.168.1.161:8080/api/wallet/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': hashedPassword, // ✅ Send hashed password
          'timestamp': timestamp,
          'data': dataToSign,
          'signature': signature,
          'publicKey': publicKey,
          'algorithm': algorithm.name,
        }),
      );

      setState(() => loading = false);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Login successful!")),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SecureCardPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ Login failed: ${response.body}")),
        );
      }
    } catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Exception: $e")),
      );
    }
  }

  void goToRegisterPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Walletregisterpage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F8F4),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 180,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF2D6A4F), Color(0xFF40916C)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: const Center(
                child: Text(
                  'Wallet Login',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 10),
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: "Email",
                          prefixIcon: const Icon(Icons.email_outlined),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Password",
                          prefixIcon: const Icon(Icons.lock_outline),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      const SizedBox(height: 30),
                      if (loading)
                        const Center(child: CircularProgressIndicator())
                      else ...[
                        ElevatedButton.icon(
                          onPressed: () => login(SignatureAlgorithm.ed25519),
                          icon: const Icon(Icons.vpn_key),
                          label: const Text("Login with Ed25519"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF40916C),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: () => login(SignatureAlgorithm.dilithium),
                          icon: const Icon(Icons.lock),
                          label: const Text("Login with Dilithium"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2D6A4F),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ],
                      const SizedBox(height: 24),
                      Center(
                        child: TextButton(
                          onPressed: goToRegisterPage,
                          child: const Text(
                            "Don't have an account? Register here",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
