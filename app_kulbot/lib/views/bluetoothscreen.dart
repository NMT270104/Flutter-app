import 'dart:async';

import 'package:app_kulbot/BluetoothDeviceListEntry.dart';
import 'package:app_kulbot/views/chatScreen.dart';
import 'package:app_kulbot/views/joypadControll.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart';

class BluetoothScreen extends StatefulWidget {
  final bool checkAvailability;

  const BluetoothScreen({this.checkAvailability = true});

  @override
  _BluetoothScreenState createState() => _BluetoothScreenState();
}

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

class _BluetoothScreenState extends State<BluetoothScreen> {
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  String _address = "...";
  String _name = "...";
  Timer? _discoverableTimeoutTimer;
  int _discoverableTimeoutSecondsLeft = 0;

  FlutterBluetoothSerial bluetooth = FlutterBluetoothSerial.instance;

  @override
  
//   Hàm này được gọi khi widget được tạo ra để khởi tạo trạng thái ban đầu của widget.
// Trong hàm này thực hiện các tác vụ như lấy trạng thái Bluetooth, địa chỉ và tên của thiết bị Bluetooth, trạng thái Bluetooth, tìm kiếm thiết bị.
  void initState() {
    super.initState();

    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        _bluetoothState = state;
      });
    });

    FlutterBluetoothSerial.instance.address.then((address) {
      setState(() {
        _address = address!;
      });
    });

    FlutterBluetoothSerial.instance.name.then((name) {
      setState(() {
        _name = name!;
      });
    });

    FlutterBluetoothSerial.instance.onStateChanged().listen((BluetoothState state) {
      setState(() {
        _bluetoothState = state;
      });
    });

    if (widget.checkAvailability) {
      _startDiscovery();
    }

    _getBondedDevices();
  }


// Hàm này bắt đầu quá trình tìm kiếm thiết bị Bluetooth mới.
// Khi một thiết bị mới được phát hiện, nó được thêm vào danh sách devices nếu chưa tồn tại trong danh sách.
  void _startDiscovery() {
    FlutterBluetoothSerial.instance.startDiscovery().listen((r) {
      setState(() {
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
    });
  }

//Hàm này được sử dụng để lấy danh sách các thiết bị Bluetooth đã được ghép nối và thêm chúng vào danh sách devices.
  void _getBondedDevices() {
    FlutterBluetoothSerial.instance.getBondedDevices().then((List<BluetoothDevice> bondedDevices) {
      setState(() {
        devices = bondedDevices.map((device) => _DeviceWithAvailability(
          device,
          widget.checkAvailability ? _DeviceAvailability.maybe : _DeviceAvailability.yes,
        )).toList();
      });
    });
  }

  @override
//   Hàm này được gọi khi widget được hủy để dọn dẹp tài nguyên và ngắt việc tìm kiếm thiết bị Bluetooth (nếu đang chạy).
// Trong trường hợp này, chúng ta ngắt quá trình tìm kiếm Bluetooth để ngăn ngừa lãng phí tài nguyên.
  void dispose() {
    super.dispose();
    FlutterBluetoothSerial.instance.cancelDiscovery();
  }

  List<_DeviceWithAvailability> devices = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bluetooth'),
        backgroundColor: _bluetoothState.isEnabled ? Colors.green : Colors.red,
      ),
      body: Container(
        child: _bluetoothState.isEnabled ? _buildDevicesListView() : Center(child: Text('Please turn on Bluetooth')),
      ),
    );
  }


//   Hàm này xây dựng giao diện danh sách các thiết bị Bluetooth được hiển thị.
// Nó tạo ra các mục danh sách từ danh sách devices
  Widget _buildDevicesListView() {
    List<BluetoothDeviceListEntry> list = devices.map((_device) =>
      BluetoothDeviceListEntry(
        device: _device.device,
        rssi: _device.rssi,
        enabled: _device.availability == _DeviceAvailability.yes,
        onTap: () {
          try {
            //quay về page cũ sau khi kết nối
          } catch (e) {
            print('Error navigating to control: $e');
          }
        },
      )
    ).toList();

    return Column(
      children: [
        Expanded(
          child: ListView(
            children: list
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            minimumSize: Size(200, 50),
          ),
          onPressed: () {
            _startDiscovery();
          },
          child: const Text(
            'Scan Device',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
        Padding(padding: EdgeInsets.only(bottom: 20)),
      ],
    );
  }
}
