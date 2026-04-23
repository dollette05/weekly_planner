import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'https://backshift-unstopped-parting.ngrok-free.dev/api';

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<Map<String, String>> getHeaders() async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'ngrok-skip-browser-warning': 'true',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'ngrok-skip-browser-warning': 'true',
      },
      body: jsonEncode({'email': email, 'password': password}),
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> register(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'ngrok-skip-browser-warning': 'true',
      },
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );
    return jsonDecode(response.body);
  }

  Future<List<dynamic>> getTasks() async {
    final headers = await getHeaders();
    final response = await http.get(Uri.parse('$baseUrl/tasks'), headers: headers);
    final data = jsonDecode(response.body);
    if (data is List) return data;
    return data['data'] ?? [];
  }

  Future<Map<String, dynamic>> createTask(Map<String, dynamic> body) async {
    final headers = await getHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/tasks'),
      headers: headers,
      body: jsonEncode(body),
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> updateTask(int id, Map<String, dynamic> body) async {
    final headers = await getHeaders();
    final response = await http.put(
      Uri.parse('$baseUrl/tasks/$id'),
      headers: headers,
      body: jsonEncode(body),
    );
    return jsonDecode(response.body);
  }

  Future<bool> deleteTask(int id) async {
    final headers = await getHeaders();
    final response = await http.delete(
      Uri.parse('$baseUrl/tasks/$id'),
      headers: headers,
    );
    return response.statusCode == 200;
  }

  Future<void> logout() async {
    final headers = await getHeaders();
    await http.post(Uri.parse('$baseUrl/logout'), headers: headers);
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }
}