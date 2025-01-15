import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:io';

class ConnectivityHelper {
  static final Connectivity _connectivity = Connectivity();

  /// Checks internet connectivity.
  /// Returns `true` if internet is available, otherwise `false`.
  static Future<bool> hasInternetConnection(BuildContext context) async {
    final connectivityResult = await _connectivity.checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      _showNoInternetMessage(context);
      return false;
    }

    // Check for actual internet access.
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      } else {
        _showNoInternetMessage(context);
        return false;
      }
    } catch (e) {
      _showNoInternetMessage(context);
      return false;
    }
  }

  /// Displays a no internet connection message.
  static void _showNoInternetMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'No internet connection available. Please check your network.',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
  }
}
