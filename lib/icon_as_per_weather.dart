import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

IconData getIcon(iconsstatus) {
  switch (iconsstatus) {
    case "Thunderstorm":
      return Icons.bolt;
    case "Clear":
      return Icons.sunny;
    case "Rain":
      return CupertinoIcons.cloud_rain_fill;
    case "Snow":
      return Icons.snowing;
    default:
      return Icons.cloud;
  }
}
