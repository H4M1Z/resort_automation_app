import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:resort_automation_app/pages/qr_scanning_page/controller/qr_scanning_controller.dart';

class QrScanningTab extends ConsumerStatefulWidget {
  const QrScanningTab({super.key});

  @override
  ConsumerState<QrScanningTab> createState() => _QrScanningPageState();
}

class _QrScanningPageState extends ConsumerState<QrScanningTab> {
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 4,
            child: _buildQrView(context),
          ),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Builder(
                  builder: (context) {
                    final state = ref.watch(qrScanningProvider);
                    switch (state) {
                      case QRScanningInitialState():
                        return const Text(
                          'Scan the QR Code to get connected',
                        );
                      case QRScanningLoadingState():
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      case QRScannedState():
                        return Center(
                          child: Text(
                            'You can now control the lights of Room No. ${state.roomNumber}',
                          ),
                        );
                      case QRScanningErrorState():
                        return Text(
                          state.error,
                        );
                    }
                  },
                )
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //   children: <Widget>[
                //     Container(
                //       margin: const EdgeInsets.all(8),
                //       child: ElevatedButton(
                //           onPressed: () async {
                //             await controller?.toggleFlash();
                //             setState(() {});
                //           },
                //           child: FutureBuilder(
                //             future: controller?.getFlashStatus(),
                //             builder: (context, snapshot) {
                //               return Text('Flash: ${snapshot.data}');
                //             },
                //           )),
                //     ),
                //     Container(
                //       margin: const EdgeInsets.all(8),
                //       child: ElevatedButton(
                //           onPressed: () async {
                //             await controller?.flipCamera();
                //             setState(() {});
                //           },
                //           child: FutureBuilder(
                //             future: controller?.getCameraInfo(),
                //             builder: (context, snapshot) {
                //               if (snapshot.data != null) {
                //                 return const Text('Camera facing');
                //               } else {
                //                 return const Text('loading');
                //               }
                //             },
                //           )),
                //     )
                //   ],
                // ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //   children: <Widget>[
                //     Container(
                //       margin: const EdgeInsets.all(8),
                //       child: ElevatedButton(
                //         onPressed: () async {
                //           await controller?.pauseCamera();
                //         },
                //         child: const Text('pause',
                //             style: TextStyle(fontSize: 20)),
                //       ),
                //     ),
                //     Container(
                //       margin: const EdgeInsets.all(8),
                //       child: ElevatedButton(
                //         onPressed: () async {
                //           await controller?.resumeCamera();
                //         },
                //         child: const Text('resume',
                //             style: TextStyle(fontSize: 20)),
                //       ),
                //     )
                //   ],
                // ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) async {
      if (scanData.code == null) {
        log('scanned data is null');
        return;
      }
      ref
          .read(qrScanningProvider.notifier)
          .onQRCodeScanned(scanData.code ?? '1');
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }
}
