import 'dart:convert';
import 'package:http/http.dart' as http;
import 'user_model.dart';

class ApiService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com/users';
  static final List<UserModel> _localUsers = []; // Store created users locally

  // POST - Create a new user (simulated with local storage)
  static Future<UserModel?> createUser(UserModel user) async {
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));
      
      // Create user with generated ID
      final newUser = UserModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: user.name,
        phone: user.phone,
        city: user.city,
        age: user.age,
      );
      
      // Store locally
      _localUsers.insert(0, newUser);
      
      return newUser;
    } catch (e) {
      return null;
    }
  }

  // GET - Retrieve all users 
  static Future<List<UserModel>> getUsers() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      // GET already save mein se start 3 users
      List<UserModel> apiUsers = [];
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        // Convert first 3 JSONPlaceholder users to our format
        apiUsers = jsonData.take(10).map((json) => UserModel(
          id: json['id'].toString(),
          name: json['name'] ?? '',
          phone: json['phone'] ?? '',
          city: json['address']?['city'] ?? '',
          age: '${20 + (json['id'] % 30)}', // Generate age based on ID
        )).toList();
      }
      
      // Combine local users including top 3 from the json this link => https://jsonplaceholder.typicode.com/users
      final allUsers = [..._localUsers, ...apiUsers]; //
      return allUsers;
    } catch (e) {
      // Return only local users like the users I i.e entered from yhe mobile
      return _localUsers;
    }
  }
}