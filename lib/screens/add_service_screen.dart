import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../utils/api_service.dart';

class AddServiceScreen extends StatefulWidget {
  const AddServiceScreen({Key? key}) : super(key: key);

  @override
  State<AddServiceScreen> createState() => _AddServiceScreenState();
}

class _AddServiceScreenState extends State<AddServiceScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  bool _isSubmitting = false;
  String? _errorMessage;

  final List<String> _categories = ['planning', 'labour', 'material'];
  String? _selectedCategory;

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    final serviceData = {
      'category': _selectedCategory,
      'name': _nameController.text,
      'description': _descriptionController.text,
      'price': double.tryParse(_priceController.text) ?? 0,
    };

    try {
      final token = await ApiService.getToken();
      final url = Uri.parse('${ApiService.baseUrl}/services');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(serviceData),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Service added successfully')),
        );
        _formKey.currentState!.reset();
        setState(() {
          _selectedCategory = null;
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to add service';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
      });
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Service'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Category'),
                value: _selectedCategory,
                items:
                    _categories
                        .map(
                          (cat) => DropdownMenuItem(
                            value: cat,
                            child: Text(
                              cat[0].toUpperCase() + cat.substring(1),
                            ),
                          ),
                        )
                        .toList(),
                onChanged: (val) {
                  setState(() {
                    _selectedCategory = val;
                  });
                },
                validator:
                    (val) => val == null ? 'Please select a category' : null,
              ),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Service Name'),
                validator:
                    (val) =>
                        val == null || val.isEmpty
                            ? 'Please enter a name'
                            : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Please enter a price';
                  }
                  final price = double.tryParse(val);
                  if (price == null || price <= 0) {
                    return 'Please enter a valid price';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              if (_errorMessage != null)
                Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
              ElevatedButton(
                onPressed: _isSubmitting ? null : _submit,
                child:
                    _isSubmitting
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Add Service'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
