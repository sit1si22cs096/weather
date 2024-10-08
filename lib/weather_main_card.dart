import 'dart:ui';
import 'package:flutter/material.dart';

class MainCard extends StatelessWidget {
  final dynamic currentTemp;
  final IconData icon;
  final dynamic currentWeatherStatus;
  const MainCard({
    super.key,
    required this.currentTemp,
    required this.icon,
    required this.currentWeatherStatus,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    " $currentTemp °c",
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Icon(
                    icon,
                    size: 40,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "$currentWeatherStatus",
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
