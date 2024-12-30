import 'package:flutter/material.dart';

IconData getDeviceIcon(String deviceType) {
  switch (deviceType) {
    case 'Bulb':
      return Icons.lightbulb;
    case 'Fan':
      return Icons.ac_unit;
    case 'AC':
      return Icons.ac_unit_outlined;
    case 'TV':
      return Icons.tv;
    case 'Oven':
      return Icons.kitchen;
    case 'Washing Machine':
      return Icons.local_laundry_service;
    default:
      return Icons.device_unknown;
  }
}
