import 'package:flutter/material.dart';

const Color primaryGreen = Color(0xFF2D6A4F);
const Color darkGreenText = Color(0xFF1B4332);

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hakkımızda'),
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Baklawati Hakkında',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: primaryGreen),
            ),
            SizedBox(height: 16),
            Text(
              'Baklawati, geleneksel tatları modern sunumlarla buluşturan bir markadır. '
              'Türkiye’nin dört bir yanından seçilmiş en kaliteli malzemelerle hazırlanan baklavalarımız, '
              'ev yapımı lezzetini koruyarak sizlerle buluşuyor.\n\n'
              'Amacımız sadece tatlı satmak değil, aynı zamanda kültürel bir deneyim sunmak. '
              'Her dilimde Anadolu’nun mirası var.',
              style: TextStyle(fontSize: 16, color: darkGreenText),
            ),
          ],
        ),
      ),
    );
  }
}
