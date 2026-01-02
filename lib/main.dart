import 'package:flutter/material.dart';
import 'package:weather_forecast_app/Weather_Screen.dart';
import 'package:get/get.dart';

void main() {
  runApp(const WeatherApp());
}
class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(  // Changed from MaterialApp to GetMaterialApp
     debugShowCheckedModeBanner: false,
     theme: ThemeData.dark(useMaterial3: true),
      home: const WeatherScreen(),
    );
  }
}
