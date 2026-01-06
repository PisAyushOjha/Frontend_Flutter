import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'basic_details_page.dart';
//import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscurePassword = true; // password toggle

  /// Alert Dialog
  void showMessage(String title, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text("OK"))
        ],
      ),
    );
  }

  /// Login function
  Future<void> loginUser() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      showMessage("Error", "Email and Password are required");
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(
            'https://guidebooky-hezekiah-nonoperative.ngrok-free.dev/dating_backend_springboot/admin/Authentication/login'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success'] == true) {
          final token = data['payload']['token'] ?? '';

          if (token.isEmpty) {
            showMessage("Error", "Token not received from server");
            return;
          }

          // Save only token
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('jwt_token', token);

          // final  FlutterSecureStorage prefs = FlutterSecureStorage();
          // await prefs.write(key: 'token', value: token);

          // Navigate to HomePage
          Navigator.pushReplacement<dynamic, dynamic>(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(
                userId: data['payload']["userId"],
                email: data['payload']["email"],
                contact: data['payload']["contact"],
                status: data['payload']["status"],
                packageStatus: data['payload']["package_status"],
                role: data['payload']["role"],
              ),
            ),
          );
        } else {
          showMessage("Error", "Invalid Credentials");
        }
      } else {
        showMessage("Error", "Login failed. Please try again");
      }
    } catch (e) {
      showMessage("Error", "Something went wrong: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: SizedBox(
            width: 300,
            child: Column(
              children: [
                const SizedBox(height: 16),
                const Text("Enter Email"),
                const SizedBox(height: 8),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: "Email",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                    prefixIcon: const Icon(Icons.email),
                  ),
                ),
                const SizedBox(height: 16),
                const Text("Enter Password"),
                const SizedBox(height: 8),
                TextField(
                  controller: passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    hintText: "Password",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: loginUser,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  child: const Text("Login"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


