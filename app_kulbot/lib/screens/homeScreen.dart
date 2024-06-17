import 'package:TEST/screens/dogControlScreen.dart';
import 'package:TEST/screens/humanControlScreen.dart';
import 'package:TEST/screens/joypadControll.dart';
import 'package:TEST/screens/settingScreen.dart';
import 'package:TEST/utils/ButtonHomeScreen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  void initState() {
    // TODO: implement initState
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {

  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Home"),
      ),
      body: Container(
        
        margin: EdgeInsets.only(top: 50),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: CarouselSlider(
          options: CarouselOptions(
            aspectRatio: 16 / 9,
            enlargeCenterPage: true,
            viewportFraction: 0.5,
          ),
          items: [
            ButtonHomeScreen(
              imgPath: 'lib/assets/images/car.jpg',
              textButton: 'Car Control',
              navigator: JoystickControl(),
            ),
            ButtonHomeScreen(
              imgPath: 'lib/assets/images/kulbot.png',
              textButton: 'Human Control',
              navigator: humanControl(),
            ),
            ButtonHomeScreen(
              imgPath: 'lib/assets/images/robothead.png',
              textButton: 'Dog Control',
              navigator: dogControl(),
            ),
            ButtonHomeScreen(
              imgPath: 'lib/assets/images/setting.png',
              textButton: 'Setting',
              navigator: settingScreen(),
            ),
          ],
        ),
      ),
    );
  }
}
