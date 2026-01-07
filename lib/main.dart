import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'views/login_page.dart';
import 'controllers/login_controller.dart';
import 'controllers/profile_controller.dart';
import 'controllers/edit_form_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login Demo',
      initialBinding: AppBinding(),
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(133, 110, 232, 158)),
      ),
      home: const SplashPage(),
    );
  }
}

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(() => LoginController());
    Get.lazyPut<ProfileController>(() => ProfileController());
    Get.lazyPut<EditFormController>(() => EditFormController());
  }
}

/// SplashPage checks if token exists
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    // Simple delay then go to LoginPage
    Future.delayed(const Duration(seconds: 1), () {
      Get.off(() => const LoginPage());
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}