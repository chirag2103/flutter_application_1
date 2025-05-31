import 'package:flutter/material.dart';
import '../utils/api_service.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? _name;
  String? _email;
  String? _role;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final userInfo = await ApiService.getUserInfo();
    print(userInfo);
    setState(() {
      _name = userInfo?['name'] ?? 'Unknown';
      _email = userInfo?['email'] ?? 'Unknown';
      _role = userInfo?['type'] ?? 'Unknown';
    });
  }

  Future<void> _logout(BuildContext context) async {
    await ApiService.logout();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey,
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 16),
            Text(
              "Name: ${_name ?? 'Loading...'}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text("Email: ${_email ?? 'Loading...'}"),
            const SizedBox(height: 8),
            Text("Role: ${_role ?? 'Loading...'}"),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _logout(context),
              child: const Text("Logout"),
            ),
          ],
        ),
      ),
    );
  }
}
