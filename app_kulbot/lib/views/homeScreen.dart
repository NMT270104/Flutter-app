
import 'package:TEST/views/dogControl.dart';
import 'package:TEST/views/humanControl.dart';
import 'package:TEST/views/joypadControll.dart';
import 'package:TEST/views/settingScreen.dart';
import 'package:TEST/views/utils/button.dart';
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
  // void _showBluetoothDeviceDialog(BuildContext context) async {
  //   final selectedDevice = await Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => BluetoothScreen()),
  //   );

  //   if (selectedDevice != null) {
  //     // Nếu người dùng đã chọn thiết bị, chuyển qua trang JoystickControl
  //     _showBluetoothDeviceDialog(context);
  //   } else {
  //     print("null_showBluetoothDeviceDialog");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Home"),
      ),
      body: Center(
        child: Wrap(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [

              Button(imgPath: 'lib/assets/images/robothead.png',textButton: 'Car Control', navigator: JoystickControl(),),
              Button(imgPath: 'lib/assets/images/robothead.png',textButton: 'Human Control', navigator: humanControl(),),
              Button(imgPath: 'lib/assets/images/robothead.png',textButton: 'Dog Control', navigator: dogControl(),),
              Button(imgPath: 'lib/assets/images/setting.png',textButton: 'Setting', navigator: settingScreen(),),
              ]
            )
          ],
        ),

      ),

    );
  }
}
