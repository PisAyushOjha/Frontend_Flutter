import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileController extends GetxController {
  var profileData = <String, dynamic>{}.obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;

  // Load profile method
  Future<void> loadProfile() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');
      
      
      if (token == null || token.isEmpty) {
        errorMessage.value = 'Token not found';
        isLoading.value = false;
        return;
      }

      final response = await http.get(
        Uri.parse('https://guidebooky-hezekiah-nonoperative.ngrok-free.dev/dating_backend_springboot/admin/Profile/profile'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );


      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        profileData.value = Map<String, dynamic>.from(data['payload']['data'][0] ?? {});
        isLoading.value = false;
      } else {
        errorMessage.value = 'Failed to load profile: ${response.statusCode} - ${response.reasonPhrase}';
        isLoading.value = false;
      }
    } catch (e) {
      errorMessage.value = 'Error: $e';
      isLoading.value = false;
    }
  }

  // Field extraction logic
  String getFieldValue(List<String> possibleKeys) {
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

  // Google Maps logic
  // Future<void> openGoogleMaps() async {
  //   final latitude = getFieldValue(['latitude', 'lat']);
  //   final longitude = getFieldValue(['longitude', 'lng', 'lon']);
    
  //   if (latitude.isNotEmpty && longitude.isNotEmpty) {
  //     final url = 'https://www.google.com/maps?q=$latitude,$longitude';
  //     if (await canLaunchUrl(Uri.parse(url))) {
  //       await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  //     }
  //   }
  // }

}