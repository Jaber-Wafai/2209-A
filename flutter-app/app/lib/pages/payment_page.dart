import 'package:flutter/material.dart';

const Color primaryGreen = Color(0xFF2D6A4F);
const Color darkGreenText = Color(0xFF1B4332);

class PaymentPage extends StatelessWidget {
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ödeme'),
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isWide = constraints.maxWidth > 700;

          return isWide
              ? Row(
                  children: [
                    Expanded(flex: 2, child: _PaymentForm()),
                    Expanded(flex: 1, child: _CartSummary()),
                  ],
                )
              : SingleChildScrollView(
                  child: Column(
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: _PaymentForm(),
                      ),
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: _CartSummary(),
                      ),
                    ],
                  ),
                );
        },
      ),
    );
  }
}

// ---------------- Payment Form ----------------

class _PaymentForm extends StatelessWidget {
  const _PaymentForm();

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final surnameController = TextEditingController();
    final emailController = TextEditingController();
    final addressController = TextEditingController();
    final cityController = TextEditingController();
    final zipController = TextEditingController();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('İletişim', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          TextField(controller: emailController, decoration: const InputDecoration(labelText: 'E-posta veya telefon')),
          const SizedBox(height: 20),

          const Text('Teslimat', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Row(
            children: [
              Expanded(child: TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Ad'))),
              const SizedBox(width: 10),
              Expanded(child: TextField(controller: surnameController, decoration: const InputDecoration(labelText: 'Soyad'))),
            ],
          ),
          const SizedBox(height: 10),
          TextField(controller: addressController, decoration: const InputDecoration(labelText: 'Adres')),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: TextField(controller: zipController, decoration: const InputDecoration(labelText: 'Posta Kodu'))),
              const SizedBox(width: 10),
              Expanded(child: TextField(controller: cityController, decoration: const InputDecoration(labelText: 'Şehir'))),
            ],
          ),
          const SizedBox(height: 30),

          const Text('Kargo Yöntemi', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: const [Text('Standard'), Text('₺89,00')]),
          ),

          const Text('Ödeme', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
              Text('İyzico - Kredi ve Banka Kartları'),
              SizedBox(height: 12),
              Placeholder(fallbackHeight: 40),
              SizedBox(height: 10),
              Text(
                '"Şimdi öde" butonuna bastıktan sonra İyzico ödeme sayfasına yönlendirileceksiniz.',
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ]),
          ),

          const Text('Fatura Adresi', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ListTile(title: const Text("Kargo adresiyle aynı"), leading: Radio(value: true, groupValue: true, onChanged: (val) {})),
          ListTile(title: const Text("Farklı fatura adresi kullan"), leading: Radio(value: false, groupValue: true, onChanged: (val) {})),

          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryGreen,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text('Şimdi öde'),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ---------------- Cart Summary ----------------

class _CartSummary extends StatelessWidget {
  const _CartSummary();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade100,
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Sepet', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        Row(children: const [
          CircleAvatar(radius: 20, backgroundColor: Colors.green),
          SizedBox(width: 10),
          Expanded(child: Text('Antep Fıstıklı Badem Ezmesi (400G)')),
          Text('₺720,00'),
        ]),
        const Divider(height: 32),
        _row('Alt Toplam', '₺720,00'),
        _row('Kargo', '₺89,00'),
        const Divider(),
        _row('Toplam', '₺819,00', bold: true),
        const Text('₺60,00 vergi dahil', style: TextStyle(fontSize: 12)),
      ]),
    );
  }

  Widget _row(String title, String price, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(title, style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
        Text(price, style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
      ]),
    );
  }
}
