import 'package:flutter/material.dart';

class Theme {
  Color primary;
  Color secondary;
  Color text;
  String riskLevel;
  String description;
  
  final int uvIndex;
  
  Theme(this.uvIndex) {
    if (uvIndex <= 2) {
      primary = Colors.green.shade800;
      secondary = Colors.green.shade700;
      text = Colors.green.shade200;
      riskLevel = 'LOW';
      description = 'Wear sunglasses on bright days. If you burn easily, cover up and use broad spectrum SPF 30+ sunscreen. Bright surfaces, such as sand, water, and snow, will increase UV exposure.';
    } else if (uvIndex <= 5) {
      primary = Colors.yellow.shade800;
      secondary = Colors.yellow.shade700;
      text = Colors.yellow.shade200;
      riskLevel = 'MODERATE';
      description = 'Stay in shade near midday when the Sun is strongest. If outdoors, wear Sun protective clothing, a wide-brimmed hat, and UV-blocking sunglasses. Generously apply broad spectrum SPF 30+ sunscreen every 2 hours, even on cloudy days, and after swimming or sweating. Bright surfaces, such as sand, water, and snow, will increase UV exposure.';
    } else if (uvIndex <= 7) {
      primary = Colors.orange.shade800;
      secondary = Colors.orange.shade700;
      text = Colors.orange.shade200;
      riskLevel = 'HIGH';
      description = 'Reduce time in the Sun between 10 a.m. and 4 p.m. If outdoors, seek shade and wear Sun protective clothing, a wide-brimmed hat, and UV-blocking sunglasses. Generously apply broad spectrum SPF 30+ sunscreen every 2 hours, even on cloudy days, and after swimming or sweating. Bright surfaces, such as sand, water, and snow, will increase UV exposure.';
    } else if (uvIndex <= 10) {
      primary = Colors.red.shade800;
      secondary = Colors.red.shade700;
      text = Colors.red.shade200;
      riskLevel = 'VERY HIGH';
      description = 'Minimize Sun exposure between 10 a.m. and 4 p.m. If outdoors, seek shade and wear Sun protective clothing, a wide-brimmed hat, and UV-blocking sunglasses. Generously apply broad spectrum SPF 30+ sunscreen every 2 hours, even on cloudy days, and after swimming or sweating. Bright surfaces, such as sand, water, and snow, will increase UV exposure.';
    } else {
      primary = Colors.purple.shade800;
      secondary = Colors.purple.shade700;
      text = Colors.purple.shade200;
      riskLevel = 'EXTREME';
      description = 'Try to avoid Sun exposure between 10 a.m. and 4 p.m. If outdoors, seek shade and wear Sun protective clothing, a wide-brimmed hat, and UV-blocking sunglasses. Generously apply broad spectrum SPF 30+ sunscreen every 2 hours, even on cloudy days, and after swimming or sweating. Bright surfaces, such as sand, water, and snow, will increase UV exposure.';
    }
  }
}
