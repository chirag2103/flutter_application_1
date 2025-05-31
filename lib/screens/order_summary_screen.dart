import 'package:flutter/material.dart';

class OrderSummaryScreen extends StatelessWidget {
  final List<Map<String, dynamic>> cartItems;

  const OrderSummaryScreen({Key? key, required this.cartItems})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    double totalAmount = cartItems.fold(0, (sum, item) {
      return sum + (item["quantity"] * item["price"]);
    });

    return Scaffold(
      appBar: AppBar(title: const Text("Order Summary"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Order Details",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartItems[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      title: Text(item["name"]),
                      subtitle: Text("Quantity: ${item["quantity"]}"),
                      trailing: Text("₹${item["quantity"] * item["price"]}"),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total Amount:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  "₹$totalAmount",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/address');
              },
              child: const Text("Proceed to Address"),
            ),
          ],
        ),
      ),
    );
  }
}
