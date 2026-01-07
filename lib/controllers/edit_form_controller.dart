import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:loginlogoutapp/controllers/profile_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';


class EditFormController extends GetxController {
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var successMessage = ''.obs;

  // API endpoint for updating profile
  static const String _baseUrl = 'https://guidebooky-hezekiah-nonoperative.ngrok-free.dev/dating_backend_springboot/admin/Profile';

  // Update profile method
  Future<bool> updateProfile({
    required String name,
    required String mobile,
    required String city,
    required String email,
    required String latitude,
    required String longitude,
  }) async {
    isLoading.value = true;
    _clearMessages();

    try {
      final token = await _getToken();
      
      if (token == null || token.isEmpty) {
        errorMessage.value = 'Authentication token not found';
        isLoading.value = false;
        return false;
      }

      // Get current profile data to preserve existing values for required fields
      final profileController = Get.put(ProfileController());
      final currentData = profileController.profileData;

      // Prepare update data - include ALL required fields as per API error
      final updateData = {
        'name': name.isNotEmpty ? name : '',
        'mobile': mobile.isNotEmpty ? mobile : '',
        'city': city.isNotEmpty ? city : '',
        'email': email.isNotEmpty ? email : '',
        'latitute': latitude.isNotEmpty ? latitude : '', // Note: API expects "latitute" (typo in API)
        'longitude': longitude.isNotEmpty ? longitude : '',
        'address': city.isNotEmpty ? city : (currentData['address']?.toString() ?? ''), // Use city or existing address
        'gender': currentData['gender']?.toString() ?? '', // Preserve existing gender
        'password': currentData['password']?.toString() ?? '', // Preserve existing password
        'country_id': currentData['country_id']?.toString() ?? '', // Preserve existing country_id
        'state': currentData['state']?.toString() ?? '', // Preserve existing state
      };

      print('Update request URL: $_baseUrl/updateprofile');
      print('Update request data: ${jsonEncode(updateData)}');
      print('Token: ${token.substring(0, 20)}...');

      final response = await http.post(
        Uri.parse('$_baseUrl/updateprofile'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(updateData),
      );

      print('Update request status: ${response.statusCode}');
      print('Update response: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        if (data['success'] == true) {
          successMessage.value = 'Profile updated successfully';
          isLoading.value = false;
          return true;
        } else {
          errorMessage.value = data['message'] ?? 'Failed to update profile';
          isLoading.value = false;
          return false;
        }
      } else if (response.statusCode == 400) {
        // Handle 400 Bad Request specifically
        try {
          final errorData = jsonDecode(response.body);
          errorMessage.value = 'Bad Request: ${errorData['message'] ?? errorData['error'] ?? 'Invalid data format'}';
        } catch (e) {
          errorMessage.value = 'Bad Request: Invalid data format or missing required fields';
        }
        isLoading.value = false;
        return false;
      } else {
        errorMessage.value = 'Failed to update profile: ${response.statusCode} - ${response.reasonPhrase}';
        isLoading.value = false;
        return false;
      }
    } catch (e) {
      errorMessage.value = 'Error updating profile: $e';
      isLoading.value = false;
      return false;
    }
  }

  void _clearMessages() {
    errorMessage.value = '';
    successMessage.value = '';
  }

  Future<String?> _getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('jwt_token');
    } catch (e) {
      return null;
    }
  }

  void clearMessages() {
    _clearMessages();
  }
}