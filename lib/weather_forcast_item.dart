import 'package:flutter/material.dart';

class WeatherForecastCard extends StatelessWidget {
  final IconData icon;
  final String time, value, status;
  const WeatherForecastCard(
      {super.key,
      required this.icon,
      required this.time,
      required this.value,
      required this.status});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(
              time,
              style: const TextStyle(fontSize: 15),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Icon(
              icon,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              value,
            ),
            Text(status)
          ],
        ),
      ),
    );
  }
}
