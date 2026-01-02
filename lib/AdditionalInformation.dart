import 'package:flutter/material.dart';

class AdditionalInformation extends StatelessWidget {
  final IconData icon;
  final String label;
  final String reading;
  const AdditionalInformation({
    super.key,
    required this.icon,
    required this.label,
    required this.reading,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
            children: [
              Icon(icon, size: 30),
              const SizedBox(
                height: 10,
              ),
              Text(
                label,
                style:const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                reading,
                style:const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              )
            ],
          );
          
  }
}
