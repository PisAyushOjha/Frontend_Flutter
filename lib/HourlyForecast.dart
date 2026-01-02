import 'package:flutter/material.dart';


class HourlyForecast extends StatelessWidget {
  final IconData iconn;
  final String time;
  final String temp;
  const HourlyForecast({
    super.key,
    required this.iconn,
    required this.time,
    required this.temp,

  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: 120,
      child: Card(
        color: const Color.fromARGB(107, 106, 102, 102),
        shadowColor: Colors.black,
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child:  Padding(
          padding:const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                time,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(
                height: 15,
              ),
              Icon(
                iconn,
                size: 40,
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                temp,
                style:const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}