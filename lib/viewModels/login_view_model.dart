import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/basic_details_model.dart';

// This has login wala API
//Authenticate the user on basis of email and password

class LoginViewModel extends ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      return {
        'success': false,
        'message': 'Email and Password are required'
      };
    }

    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse(
            'https://guidebooky-hezekiah-nonoperative.ngrok-free.dev/dating_backend_springboot/admin/Authentication/login'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      _isLoading = false;
      notifyListeners();

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success'] == true) {
          final token = data['payload']['token'] ?? '';

          if (token.isEmpty) {
            return {
              'success': false,
              'message': 'Token not received from server'
            };
          }

          // Save token 
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('jwt_token', token);

          // Create User model from response
          _currentUser = User.fromApiResponse(data['payload']);

          return {
            'success': true,
            'user': _currentUser
          };
        } else {
          return {
            'success': false,
            'message': 'Invalid Credentials'
          };
        }
      } else {
        return {
          'success': false,
          'message': 'Login failed. Please try again'
        };
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return {
        'success': false,
        'message': 'Something went wrong: $e'
      };
    }
  }

  // logout
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _currentUser = null;
    notifyListeners();
  }
}