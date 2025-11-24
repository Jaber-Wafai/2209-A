import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyCardsPage extends StatefulWidget {
  final int userId;

  const MyCardsPage({super.key, required this.userId});

  @override
  State<MyCardsPage> createState() => _MyCardsPageState();
}

class _MyCardsPageState extends State<MyCardsPage> {
  List cards = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();
    fetchCards();
  }

  Future<void> fetchCards() async {
    setState(() => loading = true);
    final url = Uri.parse(
        'http://192.168.1.161:8080/api/wallet/cards/${widget.userId}');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        cards = jsonDecode(response.body);
        loading = false;
      });
    } else {
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to load cards")),
      );
    }
  }

  Future<void> addCardDialog() async {
    final _formKey = GlobalKey<FormState>();
    final expiryController = TextEditingController();
    String cardHolder = '';
    String cardNumber = '';
    String expiry = '';
    String cvv = '';

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Add New Card"),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: "Card Holder Name"),
                  onChanged: (val) => cardHolder = val,
                  validator: (val) =>
                      val == null || val.trim().isEmpty ? "Required" : null,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: "Card Number"),
                  keyboardType: TextInputType.number,
                  maxLength: 16,
                  onChanged: (val) => cardNumber = val,
                  validator: (val) {
                    if (val == null) return "Required";
                    final digitsOnly = val.replaceAll(RegExp(r'[^0-9]'), '');
                    if (digitsOnly.length != 16)
                      return "Must be exactly 16 digits";
                    return null;
                  },
                ),
                TextFormField(
                  controller: expiryController,
                  decoration:
                      const InputDecoration(labelText: "Expiry Date (MM/YY)"),
                  keyboardType: TextInputType.number,
                  maxLength: 5,
                  onChanged: (val) {
                    if (val.length == 2 && !val.contains('/')) {
                      expiryController.text = '$val/';
                      expiryController.selection = TextSelection.fromPosition(
                        TextPosition(offset: expiryController.text.length),
                      );
                    }
                    expiry = expiryController.text;
                  },
                  validator: (val) {
                    if (val == null || val.isEmpty) return "Required";
                    final cleanVal = val.trim();
                    final regex = RegExp(r'^(0[1-9]|1[0-2])/\d{2}\$');
                    if (!regex.hasMatch(cleanVal))
                      return "Format must be MM/YY";
                    return null;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: "CVV"),
                  obscureText: true,
                  keyboardType: TextInputType.number,
                  maxLength: 3,
                  onChanged: (val) => cvv = val,
                  validator: (val) {
                    if (val == null) return "Required";
                    final digitsOnly = val.replaceAll(RegExp(r'[^0-9]'), '');
                    if (digitsOnly.length != 3)
                      return "Must be exactly 3 digits";
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () async {
              if (!_formKey.currentState!.validate()) return;

              final url =
                  Uri.parse('http://192.168.1.161:8080/api/wallet/cards/add');
              final response = await http.post(
                url,
                headers: {'Content-Type': 'application/json'},
                body: jsonEncode({
                  'userId': widget.userId,
                  'cardHolderName': cardHolder,
                  'cardNumber': cardNumber.replaceAll(RegExp(r'[^0-9]'), ''),
                  'expiryDate': expiry,
                  'cvv': cvv.replaceAll(RegExp(r'[^0-9]'), '')
                }),
              );
              Navigator.pop(context);
              if (response.statusCode == 200) {
                fetchCards();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Failed to add card")),
                );
              }
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Cards")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : cards.isEmpty
              ? const Center(child: Text("No cards yet."))
              : ListView.builder(
                  itemCount: cards.length,
                  itemBuilder: (context, index) {
                    final card = cards[index];
                    return Card(
                      child: ListTile(
                        leading:
                            const Icon(Icons.credit_card, color: Colors.green),
                        title: Text(
                            "**** **** **** ${card['cardNumber'].substring(card['cardNumber'].length - 4)}"),
                        subtitle: Text("Expires: ${card['expiryDate']}"),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: addCardDialog,
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
    );
  }
}
