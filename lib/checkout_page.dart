import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'home_page.dart';
import 'checkout_api.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final nameController = TextEditingController();
    final mobileController = TextEditingController();
    final addressController = TextEditingController();
    final pincodeController = TextEditingController();
    final CartController cartController = Get.find<CartController>();
  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;
    String selectedPayment = 'Cash on Delivery'; 
    

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter Your Details:',
                style: TextStyle(
                    fontSize: height * 0.021, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: height * 0.02),

              // Name Field
              Text(
                'Full Name:',
                style: TextStyle(
                    fontSize: height * 0.018, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: height * 0.02),
              TextField(
                controller: nameController,
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(
                  hintText: 'Enter your full name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: height * 0.02),

              // Mobile Number Field
              const Text(
                'Mobile Number:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: height * 0.02),
              TextField(
                controller: mobileController,
                keyboardType: TextInputType.phone,
                maxLength: 10,
                decoration: const InputDecoration(
                  hintText: 'Enter your mobile number',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: height * 0.01),

              // Address Field
              Text(
                'Delivery Address:',
                style: TextStyle(
                    fontSize: height * 0.017, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: addressController,
                keyboardType: TextInputType.streetAddress,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Enter your delivery address',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Pincode Field
              const Text(
                'Pincode:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: pincodeController,
                keyboardType: TextInputType.numberWithOptions(),
                decoration: const InputDecoration(
                  hintText: 'Enter your pincode',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    // Validate all fields
                    if (nameController.text.trim().isEmpty) {
                      Get.snackbar(
                        'Error',
                        'Please enter your name',
                        snackPosition: SnackPosition.TOP,
                        duration: const Duration(seconds: 2),
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                    } else if (mobileController.text.trim().isEmpty) {
                      Get.snackbar(
                        'Error',
                        'Please enter your mobile number',
                        snackPosition: SnackPosition.TOP,
                        duration: const Duration(seconds: 2),
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                    } else if (addressController.text.trim().isEmpty) {
                      Get.snackbar(
                        'Error',
                        'Please enter your address',
                        snackPosition: SnackPosition.TOP,
                        duration: const Duration(seconds: 2),
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                    } else if (pincodeController.text.trim().isEmpty) {
                      Get.snackbar(
                        'Error',
                        'Please enter your pincode',
                        snackPosition: SnackPosition.TOP,
                        duration: const Duration(seconds: 2),
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                    } else if (pincodeController.text.length != 6) {
                      Get.snackbar('Error', 'Please Enter correct Pincode',
                          snackPosition: SnackPosition.TOP,
                          duration: const Duration(seconds: 2),
                          backgroundColor: Colors.red,
                          colorText: Colors.white);
                    } else {
                      // All fields are filled, show payment options
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return Padding(
                            padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom,
                            ),
                            child: SizedBox(
                              height: height * 0.7,
                              width: width,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Payment Option : ',
                                    style: TextStyle(
                                        fontSize: height * 0.02,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        selectedPayment = 'Cash on Delivery';
                                        Get.to(HomePage());
                                        
                                        // Prepare API data
                                        Map<String, String> orderData = {
                                          'full_name': nameController.text.trim(),
                                          'mobile_number': mobileController.text.trim(),
                                          'total_amount': cartController.totalAmount.toStringAsFixed(2),
                                          'payment_method': selectedPayment,
                                          'address' : addressController.text.trim(),
                                        };
                                        
                                        // Send to API
                                        await CheckoutAPI.sendOrderToAPI(orderData);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(255, 91, 134, 198),
                                        minimumSize:
                                            Size(width, height * 0.05),
                                      ),
                                      child: Text('Cash on Delivery' , style:  TextStyle( fontSize: height * 0.02, color: Colors.white),),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        selectedPayment = 'Pay Now';
                                        Get.to(HomePage());
                                        
                                        // Prepare API data
                                        Map<String, String> orderData = {
                                          'fullName': nameController.text.trim(),
                                          'mobileNumber': mobileController.text.trim(),
                                          'totalAmount': cartController.totalAmount.toStringAsFixed(2),
                                          'paymentMethod': selectedPayment,
                                        };
                                        
                                        // Send to API
                                        await CheckoutAPI.sendOrderToAPI(orderData);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(255, 91, 134, 198),
                                        minimumSize:
                                            Size(width, height * 0.05),
                                      ),
                                      child: Text('Pay Now' , style:  TextStyle( fontSize: height * 0.02, color: Colors.white),),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child:
                      const Text('Place Order', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
