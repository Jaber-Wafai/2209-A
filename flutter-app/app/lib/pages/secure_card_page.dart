import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/services.dart';
import '../services/key_service.dart';

class SecureCardPage extends StatefulWidget {
  const SecureCardPage({super.key});

  @override
  State<SecureCardPage> createState() => _SecureCardPageState();
}

class _SecureCardPageState extends State<SecureCardPage> {
  final _formKey = GlobalKey<FormState>();
  final cardController = TextEditingController();
  final expiryController = TextEditingController();
  final cvvController = TextEditingController();

  final keyService = KeyService(algorithm: SignatureAlgorithm.dilithium);
  final iv = encrypt.IV.fromLength(16);
  bool isInitialized = false;
  bool showAddCard = false;

  @override
  void initState() {
    super.initState();
    initializeKeyExchange();
  }

  Future<void> initializeKeyExchange() async {
    await keyService.loadSavedKeyPair();
    await keyService.performKeyExchangeWithServer();
    setState(() => isInitialized = true);
  }

  Future<void> encryptAndSendCard() async {
    if (!_formKey.currentState!.validate()) return;

    final cardData = jsonEncode({
      "card": cardController.text.replaceAll(' ', ''),
      "expiry": expiryController.text.trim(),
      "cvv": cvvController.text.trim(),
    });

    final aesRaw = await keyService.sharedAesKey.extractBytes();
    final aesKey = encrypt.Key(Uint8List.fromList(aesRaw.sublist(0, 32)));

    final encrypter =
        encrypt.Encrypter(encrypt.AES(aesKey, mode: encrypt.AESMode.cbc));
    final encrypted = encrypter.encrypt(cardData, iv: iv);
    final signature =
        await keyService.signData(Uint8List.fromList(encrypted.bytes));

    final publicKey = await keyService.getPublicKeyBase64();
    final clientX25519 = await keyService.getClientX25519PublicKeyBase64();

    final response = await http.post(
      Uri.parse("http://192.168.1.161:8080/api/cards/submit-card-dilithium"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "encryptedCard": base64Encode(encrypted.bytes),
        "iv": iv.base64,
        "signature": signature,
        "publicKey": publicKey,
        "clientPublicKey": clientX25519,
      }),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("✅ ${response.body}")),
    );

    setState(() {
      showAddCard = false;
      cardController.clear();
      expiryController.clear();
      cvvController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F8F4),
      appBar: AppBar(
        title: const Text("My Wallet"),
        backgroundColor: const Color(0xFF1B4332),
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: isInitialized
          ? SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildGlassCard(),
                  const SizedBox(height: 24),
                  _buildActionButtons(),
                  if (showAddCard) const SizedBox(height: 24),
                  if (showAddCard) _buildAddCardForm(),
                ],
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildGlassCard() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF2D6A4F), Color(0xFF1B4332)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4))
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text("Digital Wallet",
              style: TextStyle(color: Colors.white70, fontSize: 16)),
          SizedBox(height: 20),
          Text("Balance",
              style: TextStyle(color: Colors.white54, fontSize: 14)),
          SizedBox(height: 8),
          Text("\$0.00",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _walletButton(Icons.add_card, "Add", () {
              setState(() => showAddCard = !showAddCard);
            }),
            _walletButton(Icons.send_rounded, "Send", () {}),
            _walletButton(Icons.download_rounded, "Request", () {}),
            _walletButton(Icons.history, "History", () {}),
          ],
        )
      ],
    );
  }

  Widget _walletButton(IconData icon, String label, VoidCallback onTap) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(50),
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.2),
                  blurRadius: 6,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, size: 30, color: const Color(0xFF2D6A4F)),
          ),
        ),
        const SizedBox(height: 8),
        Text(label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
            )),
      ],
    );
  }

  Widget _buildAddCardForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const Text("Add New Card",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          TextFormField(
            controller: cardController,
            keyboardType: TextInputType.number,
            maxLength: 19,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              CardNumberInputFormatter()
            ],
            decoration: const InputDecoration(
              labelText: "Card Number",
              border: OutlineInputBorder(),
              counterText: "",
            ),
            validator: (value) {
              if (value == null || value.isEmpty) return "Enter card number";
              final cleaned = value.replaceAll(' ', '');
              if (!RegExp(r"^\d{16}$").hasMatch(cleaned)) {
                return "Card must be 16 digits";
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: expiryController,
            keyboardType: TextInputType.number,
            maxLength: 5,
            inputFormatters: [ExpiryDateInputFormatter()],
            decoration: const InputDecoration(
              labelText: "Expiry Date (MM/YY)",
              border: OutlineInputBorder(),
              counterText: "",
            ),
            validator: (value) {
              if (value == null || value.isEmpty) return "Enter expiry date";
              if (!RegExp(r"^(0[1-9]|1[0-2])\/\d{2}$").hasMatch(value)) {
                return "Format must be MM/YY";
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: cvvController,
            keyboardType: TextInputType.number,
            maxLength: 4,
            decoration: const InputDecoration(
              labelText: "CVV",
              border: OutlineInputBorder(),
              counterText: "",
            ),
            validator: (value) {
              if (value == null || value.isEmpty) return "Enter CVV";
              if (!RegExp(r"^\d{3,4}$").hasMatch(value)) {
                return "CVV must be 3 or 4 digits";
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: encryptAndSendCard,
              icon: const Icon(Icons.lock),
              label: const Text("Submit Securely"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2D6A4F),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ✅ Formats card number like 1234 5678 9012 3456
class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digitsOnly = newValue.text.replaceAll(RegExp(r'\D'), '');
    final buffer = StringBuffer();

    for (int i = 0; i < digitsOnly.length; i++) {
      buffer.write(digitsOnly[i]);
      if ((i + 1) % 4 == 0 && i != digitsOnly.length - 1) {
        buffer.write(' ');
      }
    }

    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

// ✅ Auto-adds '/' to expiry after MM
class ExpiryDateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String digitsOnly = newValue.text.replaceAll(RegExp(r'\D'), '');
    String formatted = '';

    if (digitsOnly.length >= 2) {
      formatted = digitsOnly.substring(0, 2);
      if (digitsOnly.length > 2) {
        formatted += '/' +
            digitsOnly.substring(
                2, digitsOnly.length > 4 ? 4 : digitsOnly.length);
      } else {
        formatted += '/';
      }
    } else {
      formatted = digitsOnly;
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
