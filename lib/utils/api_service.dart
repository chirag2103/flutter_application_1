import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  static const String baseUrl =
      'http://192.168.56.1:5000/api'; // Update with your backend URL
  static final FlutterSecureStorage storage = FlutterSecureStorage();

  // Login user
  static Future<bool> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/users/login');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await storage.write(key: 'jwt_token', value: data['token']);
      return true;
    } else {
      return false;
    }
  }

  // Signup user
  static Future<bool> signup(String name, String email, String password) async {
    final url = Uri.parse('$baseUrl/users/register');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );
    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  // Get JWT token
  static Future<String?> getToken() async {
    return await storage.read(key: 'jwt_token');
  }

  // Decode JWT token to get user info
  static Future<Map<String, dynamic>?> getUserInfo() async {
    final token = await getToken();
    if (token == null) return null;

    final parts = token.split('.');
    if (parts.length != 3) return null;

    final payload = parts[1];
    final normalized = base64Url.normalize(payload);
    final decoded = utf8.decode(base64Url.decode(normalized));
    return jsonDecode(decoded);
  }

  // Logout user
  static Future<void> logout() async {
    await storage.delete(key: 'jwt_token');
  }

  // Fetch services
  static Future<List<dynamic>?> fetchServices() async {
    final token = await getToken();
    final url = Uri.parse('$baseUrl/services');
    print(url);
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }

  // Add other API methods as needed...
}
