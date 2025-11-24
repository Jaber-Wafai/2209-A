import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddMoneyPage extends StatefulWidget {
  final int userId;
  final Function(double) onSuccess;

  const AddMoneyPage(
      {super.key, required this.userId, required this.onSuccess});

  @override
  State<AddMoneyPage> createState() => _AddMoneyPageState();
}

class _AddMoneyPageState extends State<AddMoneyPage> {
  final _formKey = GlobalKey<FormState>();
  double? amount;
  bool loading = false;

  Future<void> addMoney() async {
    if (_formKey.currentState!.validate()) {
      setState(() => loading = true);

      final response = await http.post(
        Uri.parse("http://192.168.1.161:8080/api/wallet/add-money"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "userId": widget.userId,
          "amount": amount,
        }),
      );
      setState(() => loading = false);

      if (response.statusCode == 200) {
        widget.onSuccess(amount!);
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Add money failed: ${response.body}")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Money")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Amount"),
                onChanged: (value) => amount = double.tryParse(value),
                validator: (value) => (double.tryParse(value ?? "") == null ||
                        double.parse(value!) <= 0)
                    ? "Enter a valid amount"
                    : null,
              ),
              const SizedBox(height: 20),
              loading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: addMoney,
                      child: const Text("Add to Wallet"),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
