import 'package:flutter/material.dart';
import '../utils/api_service.dart';

class MaterialScreen extends StatefulWidget {
  const MaterialScreen({Key? key}) : super(key: key);

  @override
  State<MaterialScreen> createState() => _MaterialScreenState();
}

class _MaterialScreenState extends State<MaterialScreen> {
  List<dynamic> _materialServices = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMaterialServices();
  }

  Future<void> _fetchMaterialServices() async {
    setState(() {
      _isLoading = true;
    });
    final services = await ApiService.fetchServices();
    if (services != null) {
      setState(() {
        _materialServices =
            services
                .where((service) => service['category'] == 'material')
                .toList();
        _isLoading = false;
      });
    } else {
      setState(() {
        _materialServices = [];
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Material Services"), centerTitle: true),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _materialServices.isEmpty
              ? const Center(child: Text("No material services available"))
              : ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: _materialServices.length,
                itemBuilder: (context, index) {
                  final service = _materialServices[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: ListTile(
                      title: Text(service['name'] ?? ''),
                      subtitle: Text('₹${service['price']}'),
                      trailing: const Icon(Icons.shopping_cart),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${service['name']} added to cart'),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
    );
  }
}
