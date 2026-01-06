import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class DispDetails extends StatefulWidget {
  const DispDetails({super.key});

  @override
  State<DispDetails> createState() => _DispDisplayState();
}

class _DispDisplayState extends State<DispDetails> {
  Map<String, dynamic> profileData = {};
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');

      if (token == null || token.isEmpty) {
        setState(() {
          errorMessage = 'Token not found';
          isLoading = false;
        });
        return;
      }

      final response = await http.get(
        Uri.parse(
            'https://guidebooky-hezekiah-nonoperative.ngrok-free.dev/dating_backend_springboot/admin/Profile/profile'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Extract the payload from response
        setState(() {
          profileData =
              Map<String, dynamic>.from(data['payload']['data'][0] ?? {});
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load profile: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
        isLoading = false;
      });
    }
  }

  Widget buildProfileCard() {
    // Extract specific fields from profileData
    final name = _getFieldValue(['name', 'fullname', 'full_name', 'username']);
    final mobile =
        _getFieldValue(['mobile', 'phone', 'contact', 'phone_number']);
    final city = _getFieldValue(['city', 'location', 'address']);
    final email = _getFieldValue(['email', 'email_address']);
    final role = _getFieldValue(['role', 'position', 'designation']);
    final latitude = _getFieldValue(['latitude', 'lat']);
    final longitude = _getFieldValue(['longitude', 'lng', 'lon']);

    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                "Profile Details",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            if (name.isNotEmpty) buildCardRow(Icons.person, "Name", name),
            if (mobile.isNotEmpty) buildCardRow(Icons.phone, "Mobile", mobile),
            if (city.isNotEmpty)
              buildCardRow(Icons.location_city, "City", city),
            if (email.isNotEmpty) buildCardRow(Icons.email, "Email", email),
            if (role.isNotEmpty) buildCardRow(Icons.work, "Role", role),
            if (latitude.isNotEmpty && longitude.isNotEmpty)
              buildLocationCardRow(latitude, longitude),
          ],
        ),
      ),
    );
  }

  Widget buildCardRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 24, color: Colors.blue[600]),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildLocationCardRow(String latitude, String longitude) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(Icons.location_on, size: 24, color: Colors.red[600]),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Location",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 2),
                
                GestureDetector(
                  onTap: () async {
                    final Uri uri = Uri.parse(
                      'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude',
                    );
                    if (!await launchUrl(
                      uri,
                      mode: LaunchMode.externalApplication,
                    )) {
                      debugPrint('Could not open map');
                    }
                  },
                  child: const Text(
                    "View on Google Maps",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getFieldValue(List<String> possibleKeys) {
    for (final key in possibleKeys) {
      for (final dataKey in profileData.keys) {
        if (dataKey.toLowerCase().contains(key.toLowerCase())) {
          final value = profileData[dataKey];
          return value?.toString() ?? '';
        }
      }
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (errorMessage.isNotEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text("Profile")),
        body: Center(child: Text(errorMessage)),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: SingleChildScrollView(
        child: buildProfileCard(),
      ),
    );
  }
}
