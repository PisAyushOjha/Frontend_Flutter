import 'package:flutter/material.dart';
//import 'package:loginlogoutapp/getinfopage.dart';
//import 'package:shared_preferences/shared_preferences.dart';
//import 'package:flutter_secure_storage/flutter_secure_storage.dart';
//import 'login_page.dart';

//import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  final Map<String, dynamic> profileData;

  const ProfilePage({super.key, required this.profileData});

  @override
  Widget build(BuildContext context) {
    final entries = profileData.entries.toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: entries.length,
        itemBuilder: (context, index) {
          final entry = entries[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    entry.key,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(entry.value.toString()),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
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

