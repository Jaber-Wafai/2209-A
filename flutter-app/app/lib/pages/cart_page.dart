import 'package:flutter/material.dart';

const Color primaryGreen = Color(0xFF2D6A4F);
const Color lightGreen = Color(0xFFE6F4EA);
const Color darkGreenText = Color(0xFF1B4332);

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 🧾 Example cart items (replace later with dynamic logic)
    final List<Map<String, dynamic>> cartItems = [
      {'name': 'Baklava Classic', 'price': 15.0, 'qty': 1},
      {'name': 'Pistachio Rolls', 'price': 22.0, 'qty': 2},
    ];

    double total = cartItems.fold(0.0, (sum, item) => sum + (item['price'] * item['qty']));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryGreen,
        title: const Text('Your Cart'),
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: cartItems.isEmpty
          ? const Center(
              child: Text(
                'Your cart is empty 🛒',
                style: TextStyle(fontSize: 18, color: darkGreenText),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        final item = cartItems[index];
                        return Card(
                          elevation: 2,
                          child: ListTile(
                            title: Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text('Qty: ${item['qty']}'),
                            trailing: Text('\$${(item['price'] * item['qty']).toStringAsFixed(2)}'),
                            leading: IconButton(
                              icon: const Icon(Icons.delete, color: primaryGreen),
                              onPressed: () {
                                // TODO: Remove item
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total:',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: darkGreenText),
                      ),
                      Text(
                        '\$${total.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryGreen),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.payment),
                      label: const Text('Checkout'),
                      onPressed: () {
                        Navigator.pushNamed(context, '/payment');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryGreen,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
