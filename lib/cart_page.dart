import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'home_page.dart';

class CartPage extends StatelessWidget {
  var size;
  var height;
  var width;
  var orientation;

  final CartController cartController = Get.find<CartController>();
  @override
  Widget build(BuildContext context) {

    orientation = MediaQuery.of(context).orientation;  // portrait or orientation 

    size = MediaQuery.of(context).size; 
    height = size.height;
    width = size.width;


    
    return Scaffold(
      appBar: AppBar(
        title:const Text('Cart'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        // If cart is empty, show empty message
        if (cartController.cartItems.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shopping_cart_outlined, size: width * 0.25 , color: Colors.grey),
                SizedBox(height: height * 0.03),
                Text(
                  'Your cart is empty',
                  style: TextStyle(fontSize: height * 0.02, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        // Show cart items using ListView.builder
        return ListView.builder(
          padding: EdgeInsets.all(height * 0.03),
          itemCount: cartController.cartItems.length,
          itemBuilder: (context, index) {
            String productName = cartController.cartItems.keys.elementAt(index);
            int quantity = cartController.cartItems[productName]!;
            
            return Padding(
              padding: EdgeInsets.only(bottom: height * 0.02),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    productName,
                    style: TextStyle(fontSize: height * 0.02),
                  ),
                  Text(
                    'Quantity: $quantity',
                    style: TextStyle(fontSize: height * 0.02, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}