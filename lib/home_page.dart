import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'cart_page.dart';
import 'product_bottom_sheet.dart';

// Simple controller to manage cart items
class CartController extends GetxController {
  var cartItems = <String, int>{}.obs;

  void addToCart(String name, double price) {
    print('Adding to cart: $name with price: $price');
    if (cartItems.containsKey(name)) {
      cartItems[name] = cartItems[name]! + 1;
    } else {
      cartItems[name] = 1;
    }
    print('Cart items: $cartItems');
  }

  void increaseQuantity(String name) {
    if (cartItems.containsKey(name)) {
      cartItems[name] = cartItems[name]! + 1;
    }
  }

  void decreaseQuantity(String name) {
    if (cartItems.containsKey(name)) {
      if (cartItems[name]! > 1) {
        cartItems[name] = cartItems[name]! - 1;
      } else {
        cartItems.remove(name);
      }
    }
  }

  int getQuantity(String name) {
    int quantity = cartItems[name] ?? 0;
    return quantity;
  }

  int get totalItems {
    int total = 0;
    for (var quantity in cartItems.values) {
      total += quantity;
    }
    return total;
  }

  double getTotalAmount(List<Map<String, dynamic>> products) {
    double total = 0.0;
    print('Calculating total for cart: $cartItems');
    try {
      for (var entry in cartItems.entries) {
        String productName = entry.key;
        int quantity = entry.value;
        print('Processing: $productName, quantity: $quantity');
        
        // Find the product price safely
        for (var product in products) {
          if (product['name'] == productName) {
            double price = (product['price'] as num).toDouble();
            print('Found product: $productName, price: $price');
            total += price * quantity;
            print('Running total: $total');
            break;
          }
        }
      }
    } catch (e) {
      print('Error calculating total: $e');
      return 0.0;
    }
    print('Final total: $total');
    return total;
  }

  // Add a reactive getter for total amount
  double get totalAmount {
    double total = 0.0;
    final products = [
      {'name': 'Nike Road Running Shoes', 'price': 9999.0},
      {'name': 'Nike Courts', 'price': 8299.0},
      {'name': 'Nike AIR Max', 'price': 10200.0},
      {'name': 'Nike Downshifter', 'price': 4999.0},
      {'name': 'Nike Max Impact', 'price': 11999.0},
    ];
    
    for (var entry in cartItems.entries) {
      String productName = entry.key;
      int quantity = entry.value;
      
      for (var product in products) {
        if (product['name'] == productName) {
          double price = (product['price'] as num).toDouble();
          total += price * quantity;
          break;
        }
      }
    }
    return total;
  }
}

class HomePage extends StatelessWidget {
  var size;
  var height;
  var width;
  var orientation;
  final CartController cartController = Get.put(CartController());

  TextEditingController quantityController = TextEditingController();

  // List of products
  final List<Map<String, dynamic>> products = [
    {'name': 'Nike Road Running Shoes', 'price': 9999.0, 'image': 'assets/images/s1.jpg'},
    {'name': 'Nike Courts', 'price': 8299.0, 'image': 'assets/images/s2.jpg'},
    {'name': 'Nike AIR Max', 'price': 10200.0, 'image': 'assets/images/s3.jpg'},
    {'name': 'Nike Downshifter', 'price': 4999.0, 'image': 'assets/images/s4.jpg'},
    {'name': 'Nike Max Impact', 'price': 11999.0, 'image': 'assets/images/s5.jpg'},
  ];

  @override
  Widget build(BuildContext context) {
    orientation = MediaQuery.of(context).orientation;
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            padding: EdgeInsets.only(right: height * 0.015),
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => Get.to(() => CartPage()),
          ),
        ],
      ),
      body: Stack(
        children: [
          ListView.builder(
            padding: EdgeInsets.only(
              left: height * 0.02,
              right: height * 0.02,
              top: height * 0.02,
              bottom: 80,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  ProductBottomSheet.show(context, products[index], cartController);
                },
                child: Card(
                  margin: EdgeInsets.only(bottom: height * 0.02),
                  child: Padding(
                    padding: EdgeInsets.all(height * 0.015),
                    child: Row(
                      children: [
                        Image.asset(
                          products[index]['image'],
                          width: width * 0.28,
                          height: height * 0.08,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                products[index]['name'],
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '₹${products[index]['price'].toStringAsFixed(2)}',
                                style: const TextStyle(fontSize: 16, color: Colors.green),
                              ),
                            ],
                          ),
                        ),
                        Obx(() {
                          int quantity = cartController.getQuantity(products[index]['name']);

                          if (quantity == 0) {
                            return ElevatedButton(
                              onPressed: () {
                                cartController.addToCart(products[index]['name'], products[index]['price']);
                                Get.snackbar(
                                    'Added to cart ', 'product added successfully',
                                    snackPosition: SnackPosition.TOP,
                                    duration: const Duration(seconds: 1),
                                    backgroundColor: Color.fromARGB(255, 112, 214, 116));
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Add to Cart'),
                            );
                          } else {
                            return Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.blue),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      cartController.decreaseQuantity(products[index]['name']);
                                    },
                                    icon: const Icon(Icons.remove, color: Colors.blue),
                                    constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                    child: Text(
                                      '$quantity',
                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      cartController.increaseQuantity(products[index]['name']);
                                      
                                    },
                                    icon: const Icon(Icons.add, color: Colors.blue),
                                    constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                                  ),
                                ],
                              ),
                            );
                          }
                        }),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Obx(() {
              if (cartController.cartItems.isNotEmpty) {
                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Get.to(() => CartPage()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      elevation: 5,
                    ),
                    child: Text('${cartController.totalItems} items in cart', style: TextStyle(fontSize: 16)),
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            }),
          ),
        ],
      ),
    );
  }
}