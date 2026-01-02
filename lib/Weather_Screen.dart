import 'dart:convert';
import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:weather_forecast_app/APIkey.dart';
import 'package:weather_forecast_app/HourlyForecast.dart';
import 'package:weather_forecast_app/AdditionalInformation.dart';
import 'package:weather_forecast_app/temperature_controller.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  // Initialize GetX controller
  final TemperatureController tempController = Get.put(TemperatureController());

  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      String city = 'Mumbai';
      final res = await http.get(
        Uri.parse(
            'https://api.openweathermap.org/data/2.5/forecast?q=$city&APPID=$openWeatherAPIkey'),
      );
      final data = jsonDecode(res.body);

      if (data['cod'] != '200') {
        throw 'An unexpected error occured';
      }

      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(87, 228, 221, 221),
      appBar: AppBar(
        title: const Text(
          'Weather Forecast(India)',
          style: TextStyle(
              color: Color.fromARGB(255, 255, 255, 255), fontSize: 25),
        ),
        centerTitle: true,
        actions: [
          Obx(() => IconButton(
            onPressed: tempController.toggleTemperatureUnit,
            icon: Icon(tempController.toggleIcon),
            tooltip: tempController.tooltipText,
          )),
          IconButton(
            onPressed: () {
              setState((){});  
            },
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: getCurrentWeather(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          final data = snapshot.data!;
          final currentTemp = data['list'][0]['main']['temp'];
          final currentSky = data['list'][0]['weather'][0]['main'];
          final humidity = data['list'][0]['main']['humidity'];
          final windspeed = data['list'][0]['wind']['speed'];
          final pressure = data['list'][0]['main']['pressure'];

          return Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // main screen card
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    color: const Color.fromARGB(255, 80, 80, 80),
                    shadowColor: Colors.black,
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              Obx(() => Text(
                                tempController.formatTemperature(currentTemp),
                                style: const TextStyle( 
                                    fontWeight: FontWeight.bold, fontSize: 50 ),
                              )),
                              const SizedBox(height: 10),
                              const Icon(
                                Icons.cloud,
                                size: 100,
                              ),
                              Text(
                                currentSky,
                                style: const TextStyle(fontSize: 30),
                              )
                              
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                const Text(
                  'Every 3 hours Forecast :',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                ),
                const SizedBox(height: 10),
               
                SizedBox(
                  height: 150,
                  child: ListView.builder(
                    itemCount: 10,  // number of widgets I want
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context,index){
                      final hourlyforecast = data['list'][index+1]; // just like i in for loop
                      final hourlyicons = hourlyforecast['weather'][0]['main'];
                      final time = DateTime.parse(hourlyforecast['dt_txt']); // use intl dependency to convert the date and time into what I need
                     return Obx(() => HourlyForecast(
                             time:DateFormat.Hm().format(time), //Hm is hour minute
                             iconn: hourlyicons == 'Clouds' || hourlyicons == 'Rain' ? Icons.cloud : Icons.wb_sunny_sharp, 
                             temp: tempController.formatHourlyTemperature(hourlyforecast['main']['temp']))); 
                    }
                  ),
                ),

                const SizedBox(height: 10),
                const Text(
                  'Additional Information :',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                ),
                Padding(
                  padding:const EdgeInsets.only(top: 0),
                  child: SizedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        AdditionalInformation(
                            icon: Icons.water_drop,
                            label: 'Humidity',
                            reading: '$humidity%'),
                        AdditionalInformation(
                            icon: Icons.air,
                            label: 'Wind Speed',
                            reading: '$windspeed km/hr'),
                        AdditionalInformation(
                            icon: Icons.cloud_outlined,
                            label: 'Pressure',
                            reading: '$pressure mBar '),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
