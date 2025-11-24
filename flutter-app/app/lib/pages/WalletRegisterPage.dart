import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart'; // for SHA-256
import '../services/key_service.dart';

class Walletregisterpage extends StatefulWidget {
  const Walletregisterpage({super.key});

  @override
  State<Walletregisterpage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<Walletregisterpage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool loading = false;

  Future<void> register(SignatureAlgorithm algorithm) async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (!isValidEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Please enter a valid email address.")),
      );
      return;
    }

    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("❌ Password must be at least 6 characters.")),
      );
      return;
    }

    // 🔐 Hash password before sending
    final hashedPassword = sha256.convert(utf8.encode(password)).toString();

    setState(() => loading = true);

    try {
      final keyService = KeyService(algorithm: algorithm);
      await keyService.generateAndSaveKeyPair();
      final publicKey = await keyService.getPublicKeyBase64();

      final response = await http.post(
        Uri.parse('http://192.168.1.161:8080/api/wallet/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': hashedPassword,
          'publicKey': publicKey,
          'algorithm': algorithm.name,
        }),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.statusCode == 200
              ? "✅ ${algorithm.name.toUpperCase()} wallet created!"
              : "❌ Error: ${response.body}"),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Something went wrong.")),
      );
    } finally {
      setState(() => loading = false);
    }
  }

  // ✅ Email format checker
  bool isValidEmail(String email) {
    final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
    return emailRegex.hasMatch(email);
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
                  'Register Secure Wallet',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1,
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
                      const SizedBox(height: 24),
                      if (loading)
                        const Center(child: CircularProgressIndicator())
                      else ...[
                        ElevatedButton.icon(
                          onPressed: () => register(SignatureAlgorithm.ed25519),
                          icon: const Icon(Icons.vpn_key),
                          label: const Text("Register with Ed25519"),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: const Color(0xFF40916C),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: () =>
                              register(SignatureAlgorithm.dilithium),
                          icon: const Icon(Icons.lock),
                          label: const Text("Register with Dilithium"),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: const Color(0xFF2D6A4F),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ],
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
