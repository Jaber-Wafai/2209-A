import 'package:flutter/material.dart';

const Color primaryGreen = Color(0xFF2D6A4F);
const Color darkGreenText = Color(0xFF1B4332);

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final messageController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('İletişim'),
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Bize Ulaşın', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: primaryGreen)),
            const SizedBox(height: 20),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Ad Soyad', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'E-posta', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: messageController,
              maxLines: 5,
              decoration: const InputDecoration(labelText: 'Mesajınız', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: send message
                },
                style: ElevatedButton.styleFrom(backgroundColor: primaryGreen),
                child: const Text('Gönder'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
