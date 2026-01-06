import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewModels/login_view_model.dart';
import 'profile_details.dart';
import 'login_page.dart';

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

  // Logout 
  Future<void> logout(BuildContext context) async {
    final authViewModel = Provider.of<LoginViewModel>(context, listen: false);
    await authViewModel.logout();

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const LoginPage()));
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
            onPressed: () => logout(context),
            tooltip: "Logout",
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DispDetails()),
              );
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