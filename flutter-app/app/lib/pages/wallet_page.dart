import 'package:app/pages/AddMoneyPage.dart';
import 'package:app/pages/MyCardsPage.dart';
import 'package:app/pages/WalletLoginPage.dart';
import 'package:flutter/material.dart';

const Color primaryGreen = Color(0xFF2D6A4F);
const Color darkGreen = Color(0xFF1B4332);
const Color lightGreen = Color(0xFFF1F8F4);
const Color buttonGreen = Color(0xFF40916C);

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  bool isLoggedIn = false;
  int? userId;
  String? userEmail;
  double walletBalance = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGreen,
      appBar: AppBar(
        title: const Text('My Wallet'),
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWalletCard(),
            const SizedBox(height: 30),
            if (isLoggedIn) _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildWalletCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [primaryGreen, darkGreen],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isLoggedIn ? "Hello, ${userEmail ?? ''}" : "Digital Wallet",
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 8),
          const Text("Wallet Balance", style: TextStyle(color: Colors.white70, fontSize: 16)),
          const SizedBox(height: 12),
          Text(
            isLoggedIn ? "\$${walletBalance.toStringAsFixed(2)}" : "Login to view",
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 20),
          if (!isLoggedIn)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const WalletLoginPage()),
                  );
                  if (result != null && result['userId'] != null) {
                    setState(() {
                      isLoggedIn = true;
                      userId = result['userId'];
                      walletBalance = result['balance'];
                      userEmail = result['email'];
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonGreen,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                icon: const Icon(Icons.login, color: Colors.white),
                label: const Text("Login to Wallet", style: TextStyle(color: Colors.white)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final actions = [
      {
        "icon": Icons.add,
        "label": "Add",
        "action": () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddMoneyPage(
                userId: userId!,
                onSuccess: (addedAmount) {
                  setState(() {
                    walletBalance += addedAmount;
                  });
                },
              ),
            ),
          );
        }
      },
      {
        "icon": Icons.send,
        "label": "Send",
        "action": () {
          // TODO: Implement Send Money Page
        }
      },
      {
        "icon": Icons.history,
        "label": "History",
        "action": () {
          // TODO: Implement History Page
        }
      },
      {
        "icon": Icons.credit_card,
        "label": "My Cards",
        "action": () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => MyCardsPage(userId: userId!)),
          );
        }
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Wallet Actions",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: darkGreen),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: actions.map((item) {
            return _actionCard(
              item['icon'] as IconData,
              item['label'] as String,
              item['action'] as VoidCallback,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _actionCard(IconData icon, String label, VoidCallback onTap) {
    return SizedBox(
      width: 150,
      height: 130,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 32, color: primaryGreen),
                const SizedBox(height: 10),
                Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
