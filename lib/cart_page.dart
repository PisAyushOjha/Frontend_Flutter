import 'package:cart_app/checkout_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'home_page.dart';
import 'checkout_page.dart';

class CartPage extends StatelessWidget {
  var size;
  var height;
  var width;
  var orientation;

  final CartController cartController = Get.find<CartController>();
  
  // Products list for price calculation
  final List<Map<String, dynamic>> products = [
    {'name': 'Nike Road Running Shoes', 'price': 9999.0, 'image': 'assets/images/s1.jpg'},
    {'name': 'Nike Courts', 'price': 8299.0, 'image': 'assets/images/s2.jpg'},
    {'name': 'Nike AIR Max', 'price': 10200, 'image': 'assets/images/s3.jpg'},
    {'name': 'Nike Downshifter', 'price': 4999, 'image': 'assets/images/s4.jpg'},
    {'name': 'Nike Max Impact', 'price': 11999, 'image': 'assets/images/s5.jpg'},
  ];
  
  @override
  Widget build(BuildContext context) {
    orientation = MediaQuery.of(context).orientation;
    size = MediaQuery.of(context).size; 
    height = size.height;
    width = size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          // Lottie background
          Positioned.fill(
            child: Lottie.asset(
              'assets/lottie/stars.json',
              fit: BoxFit.cover,
            ),
          ),
          // Original content
          Obx(() {
            // If cart is empty, show empty message
            if (cartController.cartItems.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shopping_cart_outlined, size: width * 0.25, color: Colors.grey),
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
            return Obx(() => ListView.builder(
              padding: EdgeInsets.only(
                left: height * 0.03,
                right: height * 0.03,
                top: height * 0.03,
                bottom: 100, // Space for checkout button
              ),
              itemCount: cartController.cartItems.length,
              itemBuilder: (context, index) {
                String productName = cartController.cartItems.keys.elementAt(index);
                int quantity = cartController.cartItems[productName]!;
                
                // Find the product details manually
                Map<String, dynamic>? product;
                for (var p in products) {
                  if (p['name'] == productName) {
                    product = p;
                    break;
                  }
                }
                
                // If product not found, use default values
                if (product == null) {
                  product = {
                    'name': productName,
                    'price': 0.0,
                    'image': 'assets/images/s1.jpg', // default image
                  };
                }
                
                return Card(
                  margin: EdgeInsets.only(bottom: height * 0.02),
                  child: Padding(
                    padding: EdgeInsets.all(height * 0.015),
                    child: Row(
                      children: [
                        Image.asset(
                          product['image'],
                          width: width * 0.2,
                          height: height * 0.08,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(width: width * 0.04),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                productName,
                                style: TextStyle(fontSize: height * 0.02, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: height * 0.005),
                              Text(
                                '₹${product['price'].toStringAsFixed(2)}',
                                style: TextStyle(fontSize: height * 0.018, color: Colors.green),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: width * 0.03, vertical: height * 0.01),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Qty: $quantity',
                            style: TextStyle(
                              fontSize: height * 0.016,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ));
          }),
          // Checkout section
           Positioned(
            bottom: 0,
            left: 0,
            right: 0,
             child: Obx(() {
                if (cartController.cartItems.isNotEmpty) {
                  return Container(
                    padding: EdgeInsets.all(height * 0.02),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 5,
                          
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Total Amount',
                              style: TextStyle(fontSize: height * 0.02, color: Colors.grey),
                            ),
                            Obx(() => Text(
                              '₹${cartController.totalAmount.toStringAsFixed(2)}',
                              style: TextStyle(fontSize: height * 0.022, fontWeight: FontWeight.bold, color: Colors.green),
                            )),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Get.to(() => CheckoutPage());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            
                          ),
                          child: Text('Checkout', style: TextStyle(fontSize: height * 0.0188)),
                        ),
                      ],
                    ),
                  );
                } else {
                  return SizedBox.shrink();
                }
              }),
           ),
          
        ],
      ),
    );
  }
}