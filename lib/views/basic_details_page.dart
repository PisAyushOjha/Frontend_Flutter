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

  // Logout method
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
            icon: const Icon(Icons.logout, ),
            
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    title: const Column(
                      mainAxisAlignment : MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(Icons.logout, size: 50, color: Colors.orange),
                        SizedBox(height: 20),
                        Text(' LOGOUT !', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                        SizedBox(height: 20),
                        Text("Do you want to logout !!", style: TextStyle(fontSize: 15,), textAlign: TextAlign.center),
                      ],
                    ),
                    content: const SizedBox(height: 5),
                    actions: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            style: TextButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), minimumSize: const Size(100, 40), elevation: 5),
                            child: const Text("No"),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              logout(context);
                            },
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), minimumSize: const Size(100, 40), elevation: 5),
                            child: const Text("Yes"),
                          ),
                        ],
                        
                      ),
                    ],
                    
                  );
                },
              );
            },
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