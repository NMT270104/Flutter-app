import 'package:TEST/main.dart';
import 'package:TEST/screens/bascotControlScreen.dart';
import 'package:TEST/screens/dogControlScreen.dart';
import 'package:TEST/screens/humanControlScreen.dart';
import 'package:TEST/screens/joypadControll.dart';
import 'package:TEST/screens/settingScreen.dart';
import 'package:TEST/utils/ButtonHomeScreen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:wakelock/wakelock.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Wakelock.enable();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {}

  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
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
            viewportFraction: 1,
          ),
          items: [
            ButtonHomeScreen(
              imgPath: 'lib/assets/images/car.jpg',
              textButton: 'Car Control',
              navigator: JoystickControl(),
            ),
            ButtonHomeScreen(
              imgPath: 'lib/assets/images/car.jpg',
              textButton: 'Bascot Control',
              navigator: Bascotcontrolscreen(),
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
