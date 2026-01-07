import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/profile_controller.dart';
import 'profile_details.dart';
import 'login_page.dart';
import 'edit_form_page.dart';

class HomePage extends StatelessWidget {
  final String userId;
  final String email;
  final String contact;
  final String status;
  final String packageStatus;
  final String role;

  const HomePage({
    super.key,
    required this.userId,
    required this.email,
    required this.contact,
    required this.status,
    required this.packageStatus,
    required this.role,
  });

  Future<void> logout() async {
    try {
      // Clear SharedPreferences directly - this is the most reliable way
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      
      print('Logout successful - navigating to login');
      
      // Navigate to login page and clear all previous routes
      Get.offAll(() => const LoginPage());
    } catch (e) {
      print('Logout error: $e');
      // Even if there's an error clearing prefs, navigate to login
      Get.offAll(() => const LoginPage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Get.dialog(
                AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  title: const Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(Icons.logout, size: 50, color: Colors.orange),
                      SizedBox(height: 20),
                      Text(
                        ' LOGOUT !',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      Text("Do you want to logout !!",
                          style: TextStyle(fontSize: 15),
                          textAlign: TextAlign.center),
                    ],
                  ),
                  content: const SizedBox(height: 5),
                  actions: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () => Get.back(),
                          style: TextButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              minimumSize: const Size(100, 40),
                              elevation: 5),
                          child: const Text("No"),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                           
                            Get.back(); // Close dialog first
                            await logout(); // Then logout
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              minimumSize: const Size(100, 40),
                              elevation: 5),
                          child: const Text("Yes"),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
            tooltip: "Logout",
          ),
          ElevatedButton(
            onPressed: () {
              Get.to(() => const DispDetails());
            },
            child: const Text("Profile"),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("User Details",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              buildDetailRow("User ID", userId),
              buildDetailRow("Email", email),
              buildDetailRow("Contact", contact),
              buildDetailRow("Status", status),
              buildDetailRow("Package Status", packageStatus),
              buildDetailRow("Role", role),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final profileController = Get.find<ProfileController>();
                  profileController.loadProfile().then((_) {
                    Get.bottomSheet(
                      const EditProfileBottomSheet(),
                      isScrollControlled: true,
                      backgroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                    );
                  });
                },
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    foregroundColor: Colors.green[300],
                    backgroundColor: Colors.green[400],
                    minimumSize: const Size(150, 50)),
                child: const Text(
                  "Edit",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 16),
      child: Row(
        children: [
          Text("$title: ",
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Flexible(child: Text(value, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }
}
