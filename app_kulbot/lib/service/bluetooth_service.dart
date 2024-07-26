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

class BluetoothService {
  BluetoothState _bluetoothState = BluetoothState.STATE_ON;
  String _address = "...";
  String _name = "...";
  String connectedDeviceName = "...";
  bool isDisconnecting = false;
  FlutterBluetoothSerial flutterBluetoothSerial = FlutterBluetoothSerial.instance;
  BluetoothConnection? connection;
  List<_DeviceWithAvailability> devices = [];

  // Getter
  BluetoothState get bluetoothState => _bluetoothState;
  String get address => _address;
  String get name => _name;

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
      connectedDeviceName = device.name ?? "Unknown";
      connection!.input?.listen(_onDataReceived).onDone(() {
        if (isDisconnecting) {
          print('Disconnecting locally!');
        } else {
          print('Disconnected remotely!');
        }
      });
    } catch (e) {
      print('Error connecting to device: $e');
    }
  }

  void _onDataReceived(Uint8List data) {
    int backspacesCounter = 0;
    data.forEach((byte) {
      if (byte == 8 || byte == 127) {
        backspacesCounter++;
      }
    });
    Uint8List buffer = Uint8List(data.length - backspacesCounter);
    int bufferIndex = buffer.length;

    backspacesCounter = 0;
    for (int i = data.length - 1; i >= 0; i--) {
      if (data[i] == 8 || data[i] == 127) {
        backspacesCounter++;
      } else {
        if (backspacesCounter > 0) {
          backspacesCounter--;
        } else {
          buffer[--bufferIndex] = data[i];
        }
      }
    }
  }

  void sendMessage(String text) async {
    text = text.trim();

    if (text.isNotEmpty) {
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
          content: _bluetoothState.isEnabled
              ? buildDevicesListView(context)
              : Text("Bluetooth chưa được bật")),
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
      child: ListView(children: list),
    );
  }

  void dispose() {
    FlutterBluetoothSerial.instance.cancelDiscovery();
    if (connection != null && connection!.isConnected) {
      isDisconnecting = true;
      connection?.dispose();
      connection = null;
    }
  }
}
