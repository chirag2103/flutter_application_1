import 'package:flutter/material.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({Key? key}) : super(key: key);

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final TextEditingController _addressController = TextEditingController();
  bool _useLocation = false;

  void _toggleLocationAccess(bool value) {
    setState(() {
      _useLocation = value;
    });
  }

  void _proceedToPayment() {
    if (_useLocation) {
      // Use GPS location
      print("Using GPS location for delivery.");
    } else if (_addressController.text.isNotEmpty) {
      print("Using entered address for delivery.");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter an address or enable location access."),
        ),
      );
      return;
    }

    Navigator.pushNamed(context, '/payment');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Address"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              title: const Text("Use Current Location"),
              value: _useLocation,
              onChanged: _toggleLocationAccess,
            ),
            if (!_useLocation) ...[
              const SizedBox(height: 16),
              TextField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: "Enter Address",
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
            ],
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _proceedToPayment,
              child: const Text("Proceed to Payment"),
            ),
          ],
        ),
      ),
    );
  }
}
