import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _api = ApiService();
  bool _isLoading = false;
  String? _error;
  bool _isLoggedIn = false;

  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _isLoggedIn;

  Future<void> checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getString('token') != null;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _api.login(email, password);
      if (result['access_token'] != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', result['access_token']);
        _isLoggedIn = true;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = result['message'] ?? 'Login gagal';
      }
    } catch (e) {
      _error = 'Koneksi gagal. Pastikan backend & ngrok menyala.';
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<bool> register(String name, String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _api.register(name, email, password);
      if (result['access_token'] != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', result['access_token']);
        _isLoggedIn = true;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = result['message'] ?? 'Register gagal';
      }
    } catch (e) {
      _error = 'Koneksi gagal. Pastikan backend & ngrok menyala.';
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<void> logout() async {
    await _api.logout();
    _isLoggedIn = false;
    notifyListeners();
  }
}