import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../viewModels/profile_view_model.dart';

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
      Provider.of<ProfileViewModel>(context, listen: false).loadProfile();
    });
  }

  // card building
  Widget buildProfileCard(ProfileViewModel profileViewModel) {
    final name = profileViewModel
        .getFieldValue(['name', 'fullname', 'full_name', 'username']);
    final mobile = profileViewModel
        .getFieldValue(['mobile', 'phone', 'contact', 'phone_number']);
    final city =
        profileViewModel.getFieldValue(['city', 'location', 'address']);
    final email = profileViewModel.getFieldValue(['email', 'email_address']);
    final role =
        profileViewModel.getFieldValue(['role', 'position', 'designation']);
    final latitude = profileViewModel.getFieldValue(['latitude', 'lat']);
    final longitude =
        profileViewModel.getFieldValue(['longitude', 'lng', 'lon']);

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
              buildLocationCardRow(profileViewModel),
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
  Widget buildLocationCardRow(ProfileViewModel profileViewModel) {
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
                        profileViewModel.getFieldValue(['latitude', 'lat']);
                    final longitude = profileViewModel
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
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: Consumer<ProfileViewModel>(
        builder: (context, profileViewModel, child) {
          return Stack(
            children: [
              // backgroung
              Positioned.fill(
                child: Lottie.asset(
                  'assets/fire.json', 
                  fit: BoxFit.fill,
                ),
              ),

              //  Overlay
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.4),
                ),
              ),

              
              if (profileViewModel.isLoading)
                const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                )
              else if (profileViewModel.errorMessage.isNotEmpty)
                Center(
                  child: Text(
                    profileViewModel.errorMessage,
                    style: const TextStyle(color: Colors.white),
                  ),
                )
              else
                SingleChildScrollView(
                  child: buildProfileCard(profileViewModel),
                ),
            ],
          );
        },
      ),
    );
  }
}
