import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TemperatureController extends GetxController {
  // Observable variable for temperature unit (true = Celsius, false = Kelvin)
  var isCelsius = true.obs;

  // Temperature conversion functions
  double kelvinToCelsius(double kelvin) {
    return kelvin - 273.15;
  }

  double celsiusToKelvin(double celsius) {
    return celsius + 273.15;
  }

  // Format temperature based on current unit
  String formatTemperature(double kelvinTemp) {
    if (isCelsius.value) {
      return '${kelvinToCelsius(kelvinTemp).toStringAsFixed(2)}°C';
    } else {
      return '${kelvinTemp.toStringAsFixed(2)}K';
    }
  }

  // Format temperature for hourly forecast (with 1 decimal place)
  String formatHourlyTemperature(double kelvinTemp) {
    if (isCelsius.value) {
      return '${kelvinToCelsius(kelvinTemp).toStringAsFixed(1)}°C';
    } else {
      return '${kelvinTemp.toStringAsFixed(1)}K';
    }
  }

  // Toggle temperature unit
  void toggleTemperatureUnit() {
    isCelsius.value = !isCelsius.value;
  }

  String get tooltipText => isCelsius.value ? 'Switch to Kelvin' : 'Switch to Celsius';

  // icon for toggle button
  get toggleIcon => isCelsius.value ? Icons.thermostat : Icons.ac_unit;
}