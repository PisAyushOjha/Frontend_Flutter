import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'cart_page.dart';

// Simple controller to manage cart items
class CartController extends GetxController {
  var cartItems = <String, int>{}.obs;

  void addToCart(String name, int price) {
    if (cartItems.containsKey(name)) {
      cartItems[name] = cartItems[name]! + 1;
    } else {
      cartItems[name] = 1;
    }
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
    {
      'name': 'Nike Road Running Shoes',
      'price': 9999,
      'image': 'assets/images/s1.jpg'
    },
    { 'name': 'Nike Courts',
      'price': 8299,
      'image': 'assets/images/s2.jpg'
    },
    { 'name': 'Nike AIR Max',
      'price': 10200,
      'image': 'assets/images/s3.jpg'
     },
    {
      'name': 'Nike Downshifter',
      'price': 4999,
      'image': 'assets/images/s4.jpg'
    },
    {
      'name': 'Nike Max Impact',
      'price': 11999,
      'image': 'assets/images/s5.jpg'
    },
  ];

  @override
  Widget build(BuildContext context) {
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
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(height * 0.02),
              itemCount: products.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (BuildContext context) {
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom,
                          ),
                          child: SizedBox(
                           // padding:  EdgeInsets.all(20),
                            height: height * 0.7,
                            width: width,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: height * 0.03,),
                              Image.asset(
                                products[index]['image'],
                                width: width * 0.6,
                                height: height * 0.2,
                                
                                fit: BoxFit.cover,
                              ),
                               SizedBox(height: height * 0.03,),
                              Text(
                                products[index]['name'],
                                style:  TextStyle(
                                  fontSize: height * 0.02,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                               SizedBox(height: height * 0.03),
                              Text(
                                '₹${products[index]['price'].toStringAsFixed(2)}',
                                style:  TextStyle(
                                  fontSize: height * 0.02,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: height * 0.03,),
                              TextField(
                                controller: quantityController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'Enter Quantity',
                                  border: OutlineInputBorder(),
                                  hintText: '1/10/100',
                                  hintStyle: TextStyle(fontWeight: FontWeight.w200)
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
                                    cartController.cartItems[products[index]['name']] = quantity;
                                    quantityController.clear();
                                    Get.back();
                                    Get.snackbar(
                                      'Updated ',
                                      '${products[index]['name']} quantity set to $quantity',
                                      snackPosition: SnackPosition.TOP,
                                      duration: const Duration(seconds: 2),
                                      backgroundColor: Color.fromARGB(255, 112, 214, 116),
                                    );
                                  } else {
                                    Get.snackbar(
                                      'Error',
                                      'Please enter a valid quantity',
                                      snackPosition: SnackPosition.BOTTOM,
                                      duration: const Duration(seconds: 2),
                                      backgroundColor: Colors.red,
                                      colorText: Colors.white,
                                    );
                                  }
                                },
                              ),
                              SizedBox(height: height * 0.03,),
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
                                      cartController.cartItems[products[index]['name']] = quantity;
                                      quantityController.clear();
                                      Get.back();
                                      Get.snackbar(
                                        'Updated Cart',
                                        '${products[index]['name']} quantity set to $quantity',
                                        snackPosition: SnackPosition.TOP,
                                        duration: const Duration(seconds: 2),
                                        backgroundColor: const Color.fromARGB(255, 112, 214, 116),
                                      );
                                    } else {
                                      Get.snackbar(
                                        'Error',
                                        'Please enter a valid quantity',
                                        snackPosition: SnackPosition.BOTTOM,
                                        duration: const Duration(seconds: 1),
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
                  },
                  child: Card(
                    margin: EdgeInsets.only(bottom: height * 0.02),
                    child: Padding(
                      padding: EdgeInsets.all(height * 0.015),
                      child: Row(
                        children: [
                          Image.asset(
                            products[index]['image'],     //ask to sir 
                            width: width * 0.28,
                            height: height * 0.08,
                            fit: BoxFit.cover,
                          ),
                           SizedBox(width: width * 0.025),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  products[index]['name'],
                                  style:  TextStyle(
                                      fontSize: width * 0.04, fontWeight: FontWeight.bold),
                                ),
                                 SizedBox(height: height * 0.002),
                                Text(
                                  '₹${products[index]['price'].toStringAsFixed(2)}',
                                  style: TextStyle(
                                      fontSize: height * 0.017, color: Colors.green),
                                ),
                              ],
                            ),
                          ),
                          Obx(() {
                            int quantity = cartController
                                .getQuantity(products[index]['name']);
                  
                            if (quantity == 0) {
                              // Show Add to Cart button
                              return ElevatedButton(
                                onPressed: () {
                                  cartController.addToCart(
                                      products[index]['name'],
                                      products[index]['price']);
                                  Get.snackbar('Added to cart ',
                                      'product added successfully',
                                      backgroundColor: Color.fromARGB(255, 112, 214, 116),
                                      snackPosition: SnackPosition.TOP,
                                      duration: const Duration(seconds: 2));
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text('Add to Cart'),
                              );
                            } else {
                              // Show quantity controls
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
                                        cartController.decreaseQuantity(
                                            products[index]['name']);
                                      },
                                      icon: const Icon(Icons.remove,
                                          color: Colors.blue),
                                      constraints:  BoxConstraints(
                                          minWidth: width * 0.02, minHeight: height * 0.02),
                                    ),
                                    Container(
                                      padding:  EdgeInsets.symmetric(
                                          horizontal: width * 0.01, vertical: height * 0.01),
                                      child: Text(
                                        '$quantity',
                                        style: TextStyle(
                                            fontSize: height * 0.018,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        cartController.increaseQuantity(
                                            products[index]['name']);
                                      },
                                      icon:const Icon(Icons.add,
                                          color: Colors.blue),
                                      constraints: BoxConstraints(
                                          minWidth: width * 0.02, minHeight: height * 0.02),
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
          ),
          Obx(() {
            if (cartController.cartItems.isNotEmpty) {
              return Container(
                color: Colors.transparent,
                margin: EdgeInsets.only(bottom: height * 0.07),
                child: SizedBox(
                  width: width * 0.5,
                  
                  child: ElevatedButton(
                    onPressed: () => Get.to(() => CartPage()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: height * 0.017),
                      elevation: 5,
                    ),
                    child: Text(
                        '${cartController.totalItems} (item)s in cart',
                        style: TextStyle(fontSize: height * 0.016)),
                  ),
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          }),
        ],
      ),
    );
  }
}


