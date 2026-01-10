import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'home_page.dart';

class ProductBottomSheet {
  static void show(BuildContext context, Map<String, dynamic> product, CartController cartController) {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;
    
    TextEditingController quantityController = TextEditingController();
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            height: height * 0.7,
            width: width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: height * 0.03),
                Image.asset(
                  product['image'],
                  width: width * 0.6,
                  height: height * 0.2,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 20),
                Text(
                  product['name'],
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '₹${product['price'].toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: height * 0.03),
                TextField(
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Enter Quantity',
                    border: OutlineInputBorder(),
                    hintText: '1/10/100',
                    hintStyle: TextStyle(fontWeight: FontWeight.w200),
                  ),
                  onSubmitted: (value) {
                    if (value.trim().isEmpty) {
                      Get.snackbar(
                        'Error',
                        'Please enter a quantity',
                        snackPosition: SnackPosition.TOP,
                        duration: const Duration(seconds: 1),
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                      return;
                    }
                    int quantity = int.tryParse(value) ?? 0;
                    if (quantity > 0) {
                      cartController.cartItems[product['name']] = quantity;
                      quantityController.clear();
                      Get.back();
                      Get.snackbar(
                        'Updated ',
                        '${product['name']} quantity set to $quantity',
                        snackPosition: SnackPosition.TOP,
                        duration: const Duration(seconds: 2),
                        backgroundColor: Color.fromARGB(255, 112, 214, 116),
                      );
                    } else {
                      Get.snackbar(
                        'Error',
                        'Please enter a valid quantity',
                        snackPosition: SnackPosition.TOP,
                        duration: const Duration(seconds: 2),
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                    }
                  },
                ),
                SizedBox(height: height * 0.03),
                SizedBox(
                  width: width * 0.5,
                  child: ElevatedButton(
                    onPressed: () {
                      if (quantityController.text.trim().isEmpty) {
                        Get.snackbar(
                          'Error',
                          'Please enter a quantity',
                          snackPosition: SnackPosition.TOP,
                          duration: const Duration(seconds: 2),
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                        return;
                      }
                      int quantity = int.tryParse(quantityController.text) ?? 0;
                      if (quantity > 0) {
                        cartController.cartItems[product['name']] = quantity;
                        quantityController.clear();
                        Get.back();
                        Get.snackbar(
                          'Updated Cart',
                          '${product['name']} quantity set to $quantity',
                          snackPosition: SnackPosition.TOP,
                          duration: const Duration(seconds: 2),
                          backgroundColor: Color.fromARGB(255, 112, 214, 116),
                        );
                      } else {
                        Get.snackbar(
                          'Error',
                          'Please enter a valid quantity',
                          snackPosition: SnackPosition.TOP,
                          duration: const Duration(seconds: 2),
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Update Quantity'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}