import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanqrcodeScreen extends StatefulWidget {
  const ScanqrcodeScreen({super.key});

  @override
  State<ScanqrcodeScreen> createState() => _ScanqrcodeScreenState();
}

class _ScanqrcodeScreenState extends State<ScanqrcodeScreen> {
  final GlobalKey QrKey = GlobalKey(debugLabel: "QR");
  Barcode? result;
  QRViewController? viewController;

  @override
  void initState() {
    super.initState();
    // Cài đặt cố định màn hình ở chế độ ngang
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  void dispose() {
    viewController?.dispose();
    super.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          Expanded(
              flex: 5,
              child: QRView(key: QrKey, onQRViewCreated: onQRViewCreated)),
          Expanded(
            flex: 1,
            child: (result != null)
                ? Text("data: ${result!.code}")
                : Text("Scanning..."),
          )
        ],
      ),
    );
  }

  void onQRViewCreated(QRViewController viewController) {
    this.viewController = viewController;
    viewController.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        
        print(" data: ${result!.code}");
      });
    });
  }
}
