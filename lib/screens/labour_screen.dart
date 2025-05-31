import 'package:flutter/material.dart';
import '../utils/api_service.dart';

class LabourScreen extends StatefulWidget {
  const LabourScreen({Key? key}) : super(key: key);

  @override
  State<LabourScreen> createState() => _LabourScreenState();
}

class _LabourScreenState extends State<LabourScreen> {
  List<dynamic> _labourServices = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchLabourServices();
  }

  Future<void> _fetchLabourServices() async {
    setState(() {
      _isLoading = true;
    });
    final services = await ApiService.fetchServices();
    if (services != null) {
      setState(() {
        _labourServices =
            services
                .where((service) => service['category'] == 'labour')
                .toList();
        _isLoading = false;
      });
    } else {
      setState(() {
        _labourServices = [];
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Labour Services"), centerTitle: true),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _labourServices.isEmpty
              ? const Center(child: Text("No labour services available"))
              : ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: _labourServices.length,
                itemBuilder: (context, index) {
                  final service = _labourServices[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: ListTile(
                      title: Text(service['name'] ?? ''),
                      subtitle: Text('₹${service['price']}'),
                      trailing: const Icon(Icons.work),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '${service['name']} service selected',
                            ),
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
