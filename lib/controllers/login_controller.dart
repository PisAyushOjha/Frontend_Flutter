import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/basic_details_model.dart';

class LoginController extends GetxController {
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  Rx<User?> currentUser = Rx<User?>(null);

  // Login method
  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      return {
        'success': false,
        'message': 'Email and Password are required'
      };
    }

    isLoading.value = true;

    try {
      final response = await http.post(
        Uri.parse('https://guidebooky-hezekiah-nonoperative.ngrok-free.dev/dating_backend_springboot/admin/Authentication/login'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      isLoading.value = false;

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

          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('jwt_token', token);

          // Create User model from response
          currentUser.value = User.fromApiResponse(data['payload']);

          return {
            'success': true,
            'user': currentUser.value
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
      isLoading.value = false;
      return {
        'success': false,
        'message': 'Something went wrong: $e'
      };
    }
  }

  // Logout method
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    currentUser.value = null;
  }
}