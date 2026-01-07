import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';
import 'basic_details_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscurePassword = true;
  late final LoginController authController;

  @override
  void initState() {
    super.initState();
    // Ensure LoginController is available
    authController = Get.put(LoginController());
  }

  void showMessage(String title, String message) {
    Get.dialog(
      AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  Future<void> loginUser() async {
    final result = await authController.loginUser(
      emailController.text.trim().toLowerCase(),
      passwordController.text.trim(),
    );

    if (result['success'] == true) {
      final user = result['user'];
      Get.off(() => HomePage(
        userId: user.userId,
        email: user.email,
        contact: user.contact,
        status: user.status,
        packageStatus: user.packageStatus,
        role: user.role,
      ));
    } else {
      showMessage("Error", result['message']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Login",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Obx(() {
        return Stack(
          children: [
            // Lottie rocket background
            Positioned.fill(
              child: Lottie.asset(
                'assets/rocket.json',
                fit: BoxFit.fill,
              ),
            ),
            // Dark Overlay
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.45),
              ),
            ),
            // email pass
            Center(
              child: SingleChildScrollView(
                child: SizedBox(
                  width: 300,
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      const Text(
                        "Enter Email",
                        style: TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: emailController,
                        enabled: !authController.isLoading.value,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Email",
                          hintStyle: const TextStyle(color: Colors.white70),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.15),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          prefixIcon:
                              const Icon(Icons.email, color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Enter Password",
                        style: TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: passwordController,
                        enabled: !authController.isLoading.value,
                        obscureText: _obscurePassword,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Password",
                          hintStyle: const TextStyle(color: Colors.white70),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.15),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          prefixIcon:
                              const Icon(Icons.lock, color: Colors.white),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.white,
                            ),
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
                        onPressed: authController.isLoading.value ? null : loginUser,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          backgroundColor: Colors.orangeAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: authController.isLoading.value
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                "Login",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
