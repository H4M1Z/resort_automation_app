import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

Future<String> writeAssetToFile(String assetPath, String fileName) async {
  try {
    final byteData = await rootBundle.load(assetPath);
    final file = File('${(await getTemporaryDirectory()).path}/$fileName');
    await file.writeAsBytes(byteData.buffer.asUint8List());
    log('File written to: ${file.path}');
    return file.path;
  } catch (e) {
    log('error writing assets to file');
    return '';
  }
}
