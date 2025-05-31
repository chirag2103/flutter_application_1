import 'package:flutter/material.dart';

class PaymentScreen extends StatelessWidget {
  final double totalAmount;

  const PaymentScreen({Key? key, required this.totalAmount}) : super(key: key);

  void _handlePayment(String method, BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Payment via $method selected")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Payment"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Select Payment Method",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text("Cash on Delivery"),
              trailing: const Icon(Icons.attach_money),
              onTap: () => _handlePayment("Cash on Delivery", context),
            ),
            ListTile(
              title: const Text("Online Payment"),
              trailing: const Icon(Icons.payment),
              onTap: () => _handlePayment("Online Payment", context),
            ),
            const SizedBox(height: 32),
            Center(
              child: Text(
                "Total Amount: ₹$totalAmount",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
