import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class ScanqrcodeScreen extends StatefulWidget {
  final Function(String) onScanComplete;

  ScanqrcodeScreen({required this.onScanComplete});

  @override
  _ScanqrcodeScreenState createState() => _ScanqrcodeScreenState();
}

class _ScanqrcodeScreenState extends State<ScanqrcodeScreen> {
  String? _scanQRres;
  List<String> _qrCodes = [];

  //hàm quét QR 1 lần và lưu data vào _qrCodes
  Future<void> scanQRcodeOnce() async {
    String scanData = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', 'Cancel', true, ScanMode.QR);

    if (scanData != '-1') {
      // '-1' indicates that the user cancelled the scan
      setState(() {
        _qrCodes.add(scanData);
        
      });
    }
  }

  // hàm quét  QR dạng stream và gửi data 
  Future<void> scanQRcodeStream() async {
  bool isScanning = false; // Biến theo dõi trạng thái quét

  FlutterBarcodeScanner.getBarcodeStreamReceiver(
          '#ff6666', 'Cancel', true, ScanMode.QR)!
      .listen((scanData) async {
    if (!isScanning) {
      isScanning = true; // Đặt trạng thái quét là đang quét

      setState(() {
        _scanQRres = scanData;
        widget.onScanComplete(scanData);
      });

      // Delay for 1 second để đảm bảo quét xong
      await Future.delayed(Duration(seconds: 1));

      setState(() {
        _scanQRres = null; // Xóa dữ liệu sau khi delay
      });

      isScanning = false; // Đặt lại trạng thái quét
    }
  });
}


  // Hàm chơi tất cả các QR đã quét được lưu trong _qrCodes
  Future<void> playQRcodes() async {
    for (String code in _qrCodes) {
      widget.onScanComplete(code);
      await Future.delayed(Duration(milliseconds: 1000));
    }
    setState(() {
      _qrCodes.clear(); // Clear the list after sending all messages
    });
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
              onPressed: scanQRcodeStream,
              child: Text('Scan QR Code stream'),
            ),
            ElevatedButton(
              onPressed: scanQRcodeOnce,
              child: Text('Add QR Code '),
            ),
            ElevatedButton(
              onPressed: playQRcodes,
              child: Text('Play QR Codes 📤'),
            ),
            SizedBox(height: 20),
            Text('Scanned QR Codes: ${_qrCodes.join(', ')}')
          ],
        ),
      ),
    );
  }
}
