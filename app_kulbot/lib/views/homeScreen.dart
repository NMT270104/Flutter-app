import 'package:app_kulbot/views/bluetoothscreen.dart';
import 'package:app_kulbot/views/joypadControll.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isPress = false;
  bool isPressed_Setting = false;


// Tạo hàm để hiển thị cửa sổ thoát hiện và chọn thiết bị Bluetooth
  void _showBluetoothDeviceDialog(BuildContext context) async {
    final selectedDevice = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BluetoothScreen()),
    );

    if (selectedDevice != null) {
      // Nếu người dùng đã chọn thiết bị, chuyển qua trang JoystickControl
      _showBluetoothDeviceDialog(context);
    } else {
      print("null_showBluetoothDeviceDialog");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Home"),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              child: Column(
                children: [
                  GestureDetector(
                    
                    onTapDown: (_) {
                      setState(() {
                        isPress = true;
                      });
                    },
                    onTapUp: (_) {
                      setState(() {
                        isPress = false;
                      });
                    },
                    onTap: () {

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BluetoothScreen()),
                        );
                     
                    },
                    child: Container( 
                      alignment: Alignment.center,
                      height: 150,
                      width: 150,
                      color: isPress ? Colors.blueGrey : Colors.blue,
                      child: Text(
                        'Control',
                        style: TextStyle(color: Colors.black, fontSize: 20),
                        
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: Column(
                children: [
                  GestureDetector(
                    onTapDown: (_) {
                      setState(() {
                        isPressed_Setting = true;
                      });
                    },
                    onTapUp: (_) {
                      setState(() {
                        isPressed_Setting = false;
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 150,
                      width: 150,
                      color: isPressed_Setting ? Colors.blueGrey : Colors.blue,
                      child: Text(
                        'Settings',
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
