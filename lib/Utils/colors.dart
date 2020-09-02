import 'package:flutter/material.dart';

class ColorUtils {
  List<Color> getWeatherColor(int code) {
    if (code >= 200 && code < 300) {
      // Group 2xx: Thunderstorm
      return [
        getColor("#7b4bff"),
        getColor("#af86ff"),
      ];
    } else if (code >= 300 && code < 400) {
      // Group 3xx: Drizzle
      return [
        getColor("#ff3487"),
        getColor("#ff67bb"),
      ];
    } else if (code >= 500 && code < 600) {
      // Group 5xx: Rain
      return [
        getColor("#0058ff"),
        getColor("#588cc7"),
      ];
    } else if (code >= 600 && code < 700) {
      // Group 6xx: Snow
      return [
        getColor("#ffd250"),
        getColor("#ffa329"),
      ];
    } else if (code >= 700 && code < 800) {
      // Group 7xx: Atmosphere
      return [
        getColor("#f28b13"),
        getColor("#ffd940"),
      ];
    } else if (code == 800) {
      // Group 800: Clear
      return [
        getColor("#ff4f00"),
        getColor("#ffb8b9"),
      ];
    } else if (code > 800) {
      // Group 80x: Clouds
      return [
        getColor("#5cd73a"),
        getColor("#bdff60"),
      ];
    }
    return [];
  }

  Color getColor(String hexadecimal) {
    final hexCode = hexadecimal.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }
}
