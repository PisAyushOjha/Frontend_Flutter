import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';
import '../controllers/edit_form_controller.dart';

class EditProfileBottomSheet extends StatefulWidget {
  const EditProfileBottomSheet({super.key});

  @override
  State<EditProfileBottomSheet> createState() => _EditProfileBottomSheetState();
}

class _EditProfileBottomSheetState extends State<EditProfileBottomSheet> {
  late TextEditingController nameController;
  late TextEditingController mobileController;
  late TextEditingController cityController;
  late TextEditingController emailController;
  late TextEditingController roleController;
  late TextEditingController latitudeController;
  late TextEditingController longitudeController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers - will be populated when profile data loads
    nameController = TextEditingController();
    mobileController = TextEditingController();
    cityController = TextEditingController();
    emailController = TextEditingController();
    roleController = TextEditingController();
    latitudeController = TextEditingController();
    longitudeController = TextEditingController();
  }

  void _populateFields(ProfileController profileController) {
    nameController.text = profileController.getFieldValue(['name', 'fullname', 'full_name', 'username']);
    mobileController.text = profileController.getFieldValue(['mobile', 'phone', 'contact', 'phone_number']);
    cityController.text = profileController.getFieldValue(['city', 'location', 'address']);
    emailController.text = profileController.getFieldValue(['email', 'email_address']);
    roleController.text = profileController.getFieldValue(['role', 'position', 'designation']);
    latitudeController.text = profileController.getFieldValue(['latitude', 'lat']);
    longitudeController.text = profileController.getFieldValue(['longitude', 'lng', 'lon']);
  }

  @override
  void dispose() {
    nameController.dispose();
    mobileController.dispose();
    cityController.dispose();
    emailController.dispose();
    roleController.dispose();
    latitudeController.dispose();
    longitudeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileController = Get.find<ProfileController>();
    final editFormController = Get.put(EditFormController());

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
        ),
        child: Obx(() {
          if (!profileController.isLoading.value && profileController.errorMessage.isEmpty) {
            _populateFields(profileController);
          }

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Edit Profile",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Name",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: mobileController,
              decoration: const InputDecoration(
                labelText: "Mobile",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: cityController,
              decoration: const InputDecoration(
                labelText: "City",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_city),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: roleController,
              enabled: false,
              decoration: const InputDecoration(
                labelText: "Role",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.work),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: latitudeController,
              decoration: const InputDecoration(
                labelText: "Latitude",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_on),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: longitudeController,
              decoration: const InputDecoration(
                labelText: "Longitude",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_on),
              ),
            ),
            const SizedBox(height: 20),
            Obx(() => ElevatedButton(
              onPressed: editFormController.isLoading.value ? null : () async {
                final success = await editFormController.updateProfile(
                  name: nameController.text.trim(),
                  mobile: mobileController.text.trim(),
                  city: cityController.text.trim(),
                  email: emailController.text.trim(),
                  latitude: latitudeController.text.trim(),
                  longitude: longitudeController.text.trim(),
                );

                if (success) {
                  profileController.loadProfile();
                  Get.back();
                  
                  // Show success message
                  Get.snackbar(
                    'Success',
                    'Profile updated successfully!',
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                  );
                } else if (editFormController.errorMessage.isNotEmpty) {
                  // Show error message
                  Get.snackbar(
                    'Error',
                    editFormController.errorMessage.value,
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: editFormController.isLoading.value
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Done"),
            )),
            const SizedBox(height: 20),
          ],
        );
      }),
      ),
    );
  }
}