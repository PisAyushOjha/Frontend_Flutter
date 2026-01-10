import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';

class CheckoutAPI {
  // API function to send order data
  static Future<void> sendOrderToAPI(Map<String, String> orderData) async {
    try {
      const String apiUrl = 'https://696242e5d9d64c7619075f0c.mockapi.io/Checkout'; // Replace with your actual API endpoint
      
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(orderData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Success
        Get.snackbar(
          'Order Placed',
          'Order placed successfully!',
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 2),
          backgroundColor: const Color.fromARGB(255, 112, 214, 116),
          colorText: Colors.white,
        );
        print('Order sent successfully: ${response.body}');
      } else {
        // Error
        Get.snackbar(
          'Error',
          'Failed to place order. Please try again.',
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        print('API Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      // Network or other error
      Get.snackbar(
        'Error',
        'Network error. Please check your connection.',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print('Network Error: $e');
    }
  }
}