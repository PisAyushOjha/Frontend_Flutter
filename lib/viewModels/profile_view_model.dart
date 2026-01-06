import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// This has token wala API

class ProfileViewModel with ChangeNotifier {
  Map<String, dynamic> _profileData = {};
  bool _isLoading = true;
  String _errorMessage = '';

  // Getters - same as before
  Map<String, dynamic> get profileData => _profileData;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // API
  Future<void> loadProfile() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');

      if (token == null || token.isEmpty) {
        _errorMessage = 'Token not found';
        _isLoading = false;
        notifyListeners();
        return;
      }

      final response = await http.get(
        Uri.parse(
            'https://guidebooky-hezekiah-nonoperative.ngrok-free.dev/dating_backend_springboot/admin/Profile/profile'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _profileData = Map<String, dynamic>.from(data['payload']['data'][0] ?? {}); //
        _isLoading = false;
        notifyListeners();
      } else {
        _errorMessage =
            'Failed to load profile: ${response.statusCode} - ${response.reasonPhrase}';
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Error: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  // create a method where I will pass the list of keys 
  String getFieldValue(List<String> possibleKeys) {
    for (final key in possibleKeys) {
      for (final dataKey in _profileData.keys) {
        if (dataKey.toLowerCase().contains(key.toLowerCase())) {
          final value = _profileData[dataKey];
          return value?.toString() ?? '';
        }
      }
    }
    return '';
  }
}
