import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/profile_controller.dart';

class DispDetails extends StatefulWidget {
  const DispDetails({super.key});

  @override
  State<DispDetails> createState() => _DispDisplayState();
}

class _DispDisplayState extends State<DispDetails> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<ProfileController>().loadProfile();
    });
  }

  // card building
  Widget buildProfileCard(ProfileController profilecontroller) {
    final name = profilecontroller.getFieldValue(['name', 'fullname', 'full_name', 'username']);

    final mobile = profilecontroller.getFieldValue(['mobile', 'phone', 'contact', 'phone_number']);

    final city =profilecontroller.getFieldValue(['city', 'location', 'address']);

    final email = profilecontroller.getFieldValue(['email', 'email_address']);

    final role =profilecontroller.getFieldValue(['role', 'position', 'designation']);

    final latitude = profilecontroller.getFieldValue(['latitude', 'lat']);
    
    final longitude =profilecontroller.getFieldValue(['longitude', 'lng', 'lon']);

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
              buildLocationCardRow(profilecontroller),
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
          Icon(icon, size: 24, color: const Color.fromARGB(255, 38, 154, 81)),
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

  // Google Maps
  Widget buildLocationCardRow(ProfileController profilecontroller) {
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
                    final latitude =
                        profilecontroller.getFieldValue(['latitude', 'lat']);
                    final longitude = profilecontroller
                        .getFieldValue(['longitude', 'lng', 'lon']);
                    if (latitude.isNotEmpty && longitude.isNotEmpty) {
                      final url =
                          'https://www.google.com/maps?q=$latitude,$longitude';
                      if (await canLaunchUrl(Uri.parse(url))) {
                        await launchUrl(Uri.parse(url),
                            mode: LaunchMode.externalApplication);
                      }
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

  @override
  Widget build(BuildContext context) {
    final profileController = Get.find<ProfileController>();
    
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: Obx(() {
          if (profileController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (profileController.errorMessage.isNotEmpty) {
            return Center(child: Text(profileController.errorMessage.value));
          }

          return SingleChildScrollView(
            child: buildProfileCard(profileController),
          );
        },
      ),
    );
  }
}
