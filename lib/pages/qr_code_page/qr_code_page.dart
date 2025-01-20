import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRCodeScreen extends StatelessWidget {
  final String downloadLink = "https://your-hosted-apk-link.com";

  const QRCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Download App"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Scan the QR code to download the app",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Image.asset(
              'assets/images/qr_code.jpg',
              width: 200,
              height: 200,
            ),
          ],
        ),
      ),
    );
  }
}
