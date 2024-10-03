import 'dart:ffi';

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

enum _DeviceAvailability {
  no,
  maybe,
  yes,
}

class _DeviceWithAvailability {
  BluetoothDevice device;
  _DeviceAvailability availability;
  int? rssi;

  _DeviceWithAvailability(this.device, this.availability, [this.rssi]);
}

class BluetoothService with ChangeNotifier {

  double? receivedValue1;
  double? receivedValue2;
  double? receivedValue3;
  double? receivedValue4;

  BluetoothState _bluetoothState = BluetoothState.STATE_ON;
  String _address = "...";
  String _name = "...";
  // String connectedDeviceName = "...";
  Function(String)? onDeviceConnected;
  bool isDisconnecting = false;
  FlutterBluetoothSerial flutterBluetoothSerial =
  FlutterBluetoothSerial.instance;
  BluetoothConnection? connection;
  List<_DeviceWithAvailability> devices = [];
  // Getter
  BluetoothState get bluetoothState => _bluetoothState;
  String get address => _address;
  String get name => _name;

  // Hàm callback để báo về khi có dữ liệu mới
  Function(double)? onValueReceiveChanged; 

  // Setter
  set bluetoothState(BluetoothState state) {
    _bluetoothState = state;
  }

  set address(String addr) {
    _address = addr;
  }

  set name(String name) {
    _name = name;
  }

  String? dataString;

  final StreamController<Map<String, double?>> _streamController = StreamController.broadcast();

  Stream<Map<String, double?>> get stream => _streamController.stream;



                                                                                                            
  Future<void> requestLocationPermission() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      // Quyền truy cập vị trí được cấp
    } else if (status.isDenied) {
      // Quyền truy cập vị trí bị từ chối 
    } else if (status.isPermanentlyDenied) {
      // Quyền truy cập vị trí bị từ chối vĩnh viễn, mở cài đặt ứng dụng
      openAppSettings();
    }
  }

  void startDiscoveryWithTimeout() {
    Timer(Duration(seconds: 10), () {
      // Dừng quá trình tìm kiếm sau 10 giây
      FlutterBluetoothSerial.instance.cancelDiscovery();
    });
    FlutterBluetoothSerial.instance.startDiscovery().listen((r) {
      // Check if the device already exists in the list
      bool isNewDevice = true;
      for (var device in devices) {
        if (device.device == r.device) {
          isNewDevice = false;
          device.availability = _DeviceAvailability.yes;
          device.rssi = r.rssi;
          break;
        }
      }
      // If the device is new, add it to the list
      if (isNewDevice) {
        devices.add(_DeviceWithAvailability(
          r.device,
          _DeviceAvailability.yes,
          r.rssi,
        ));
      }
    });
  }

  void getBondedDevices() {
    FlutterBluetoothSerial.instance
        .getBondedDevices()
        .then((List<BluetoothDevice> bondedDevices) {
      devices = bondedDevices
          .map((device) => _DeviceWithAvailability(
                device,
                _DeviceAvailability.maybe,
              ))
          .toList();
    });
  }


Future<void> connectToDevice(BluetoothDevice device) async {
  try {
    connection = await BluetoothConnection.toAddress(device.address);
    if (connection != null && connection!.isConnected) {
      onDeviceConnected?.call(device.name ?? "Unknown");
      connection!.input?.listen(_onDataReceived).onDone(() {
        if (isDisconnecting) {
          print('Disconnecting locally!');
        } else {
          print('Disconnected remotely!');
        }
      });
    } else {
      print('Connection failed or connection is null.');
      onDeviceConnected?.call(device.name ?? "");

    }
  } catch (e) {
    print('Error connecting to device: $e');
  }
}


  void _onDataReceived(Uint8List data) {
    String dataString = utf8.decode(data);
    print("Full response: $dataString");
    // Parse dữ liệu và thêm vào luồng
   // List<int> parsedValues = _parseData(dataString);
    //print('_parseData : $parsedValues');
    //_streamController.add(parsedValues);
    _parseAndStoreData(dataString);

    // Phát dữ liệu qua stream
    _streamController.add({
      "receivedValue1": receivedValue1,
      "receivedValue2": receivedValue2,
      "receivedValue3": receivedValue3,
      "receivedValue4": receivedValue4,
    });
  }

  // Hàm phân tích dữ liệu (chỉnh sửa theo định dạng "id 1: 50 ; id 2: 30 ;")
// List<int> _parseData(String dataString) {
//   List<int> values = [];
//   // Loại bỏ ký tự không mong muốn như '$' hoặc các ký tự đặc biệt khác
//   dataString = dataString.replaceAll(RegExp(r'[\$]'), ''); // Xóa tất cả ký tự $
//   // Tách chuỗi theo dấu chấm phẩy
//   List<String> parts = dataString.split(';');

//   for (var part in parts) {
//     part = part.trim();

//     if (part.contains(':')) {
//       List<String> subParts = part.split(':');
//       if (subParts.length == 2) {
//         double? value = double.tryParse(subParts[1].trim());
//         if (value != null) {
//           values.add(value.toInt());
//         } else {
//           print("Invalid value format: ${subParts[1]}");
//         }
//       } else {
//         print("Invalid format in part: $part");
//       }
//     }
//   }

//   if (values.isEmpty) {
//     print('No valid values found in dataString: $dataString');
//   }

//   return values;
// }






// Stream<List<int>> receiveDataStream() {
//   if (connection != null && connection!.isConnected) {
//     if (connection!.input != null) {
//       return connection!.input!.asBroadcastStream();
//     } else {
//       throw Exception("Không có dữ liệu đầu vào từ thiết bị Bluetooth");
//     }
//   } else {
//     throw Exception("Chưa kết nối với thiết bị Bluetooth");
//   }
// }

void _parseAndStoreData(String dataString) {
    // Logic phân tích dữ liệu và lưu vào biến tạm temp1, temp2, temp3, temp4
    // Sau khi lưu dữ liệu vào các biến tạm, gọi notifyListeners() để widget biết có sự thay đổi.
    dataString = dataString.replaceAll(RegExp(r'[\$]'), '');
    List<String> parts = dataString.split(';');

    for (var part in parts) {
      part = part.trim();
      if (part.contains(':')) {
        List<String> subParts = part.split(':');
        if (subParts.length == 2) {
          int? id = int.tryParse(subParts[0].trim().replaceAll(RegExp(r'[a-zA-Z ]'), ''));
          double? value = double.tryParse(subParts[1].trim());

          if (id != null && value != null) {
            switch (id) {
              case 1:
                receivedValue1 = value;
                break;
              case 2:
                receivedValue2 = value;
                break;
              case 3:
                receivedValue3 = value;
                break;
              case 4:
                receivedValue4 = value;
                break;
              default:
                print("Unknown ID: $id");
            }
            notifyListeners(); // Thông báo cập nhật
          }
        }
      }
    }
  }

 Stream<List<int>> receiveDataStream() {
  if (connection != null && connection!.isConnected) {
    if (connection!.input != null) {
      return connection!.input!.asBroadcastStream();
    } else {
      throw Exception("Không có dữ liệu đầu vào từ thiết bị Bluetooth");
    }
  } else {
    throw Exception("Chưa kết nối với thiết bị Bluetooth");
  }
}


  void sendMessage(String text) async {
    text = text.trim();

    if (text.isNotEmpty  && connection != null) {
      try {
        connection!.output.add(Uint8List.fromList(utf8.encode(text)));
        await connection!.output.allSent;
      } catch (e) {
        print("Error sending message: $e");
      }
    }
  }

  Future<void> connectBluetoothDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
          alignment: Alignment.center,
          title: const Text(
            'Bluetooth ',
            style: TextStyle(fontSize: 20, color: Colors.black),
          ),
          content: _bluetoothState.isEnabled && devices.isNotEmpty
              ? buildDevicesListView(context)
              : Text("Không tìm thấy thiết bị hoặc chưa bật bluetooth")),
    );
  }

  Widget buildDevicesListView(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    
    List<Widget> list = devices
        .map((_device) => ListTile(
              title: Text(_device.device.name ?? "Unknown"),
              subtitle: Text(_device.device.address),
              trailing: _device.availability == _DeviceAvailability.yes
                  ? Icon(Icons.check_circle, color: Colors.green)
                  : null,
              onTap: () {
                connectToDevice(_device.device);
                Navigator.of(context).pop();
              },
            ))
        .toList();

    return Container(
      color: Colors.grey[50],
      width: screenWidth * 1,
      height: screenHeight * 0.50,
      child: ListView(children:list  ),
    );
  }

  void dispose() {
    FlutterBluetoothSerial.instance.cancelDiscovery();
    if (connection != null && connection!.isConnected) {
      isDisconnecting = true;
      connection?.dispose();
      _streamController.close();
      connection = null;
    }
  }
}
