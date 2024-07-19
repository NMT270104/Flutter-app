import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class ScanqrcodeScreen extends StatefulWidget {
  @override
  _ScanqrcodeScreenState createState() => _ScanqrcodeScreenState();
}

class _ScanqrcodeScreenState extends State<ScanqrcodeScreen> {
  List<String> _qrCodes = [];

  Future<void> scanQRcodeOnce() async {
    String scanData = await FlutterBarcodeScanner.scanBarcode(
      '#ff6666', 'Cancel', true, ScanMode.QR);

    if (scanData != '-1') { // '-1' indicates that the user cancelled the scan
      setState(() {
        _qrCodes.add(scanData);
      });
    }
  }

  Future<void> playQRcodes() async {
    for (String code in _qrCodes) {
      _sendMessage(code);
      await Future.delayed(Duration(milliseconds: 500));
    }
    setState(() {
      _qrCodes.clear(); // Clear the list after sending all messages
    });
  }

  void _sendMessage(String message) {
    // Your implementation for sending the message
    print(message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code Scanner'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: scanQRcodeOnce,
              child: Text('Add QR Code'),
            ),
            ElevatedButton(
              onPressed: playQRcodes,
              child: Text('Play QR Codes'),
            ),
            SizedBox(height: 20),
            Text('Scanned QR Codes: ${_qrCodes.join(', ')}')
          ],
        ),
      ),
    );
  }
}
