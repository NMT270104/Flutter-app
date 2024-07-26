import 'dart:io';

import 'package:TEST/main.dart';
import 'package:TEST/screens/TFliteCameraScreen.dart';
import 'package:TEST/screens/bascotControlScreen.dart';
import 'package:TEST/screens/dogControlScreen.dart';
import 'package:TEST/screens/humanControlScreen.dart';
import 'package:TEST/screens/iotScreen.dart';
import 'package:TEST/screens/joypadControll.dart';
import 'package:TEST/screens/programingScreen.dart';
import 'package:TEST/screens/settingScreen.dart';
import 'package:TEST/utils/ButtonHomeScreen.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock/wakelock.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:TEST/provider/provider.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _moveForwardCommand = 'FF';
  String _moveBackwardCommand = 'BB';

  AudioPlayer? _audioPlayer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Wakelock.enable();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    _audioPlayer = AudioPlayer();
    _playMusic();

    _audioPlayer?.onPlayerComplete.listen((event) {
      _playMusic();
    });
  }

  @override
  void dispose() {
    _audioPlayer?.dispose();
    super.dispose();
  }

  void _playMusic() async {
    // Load file nhạc từ assets
    final ByteData data =
        await rootBundle.load('lib/assets/music/background-music.mp3');
    final Uint8List bytes = data.buffer.asUint8List();

    // Lưu file nhạc vào thư mục tạm thời
    final Directory tempDir = await getTemporaryDirectory();
    final String tempPath = tempDir.path;
    final File tempFile = File('$tempPath/background-music.mp3');
    await tempFile.writeAsBytes(bytes);

    // Phát file nhạc từ thư mục tạm thời
    await _audioPlayer?.play(DeviceFileSource(tempFile.path));
  }

  Future<void> _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _moveForwardCommand = prefs.getString('moveForward') ?? 'FF';
      _moveBackwardCommand = prefs.getString('moveBackward') ?? 'BB';
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(AppLocalizations.of(context)!.home),
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
              textButton: AppLocalizations.of(context)!.carControl,
              navigator: JoystickControl(),
            ),
            ButtonHomeScreen(
              imgPath: 'lib/assets/images/Bascot_16.png',
              textButton: AppLocalizations.of(context)!.bascotControl,
              navigator: Bascotcontrolscreen(),
            ),
            ButtonHomeScreen(
              imgPath: 'lib/assets/images/iot.png',
              textButton: "IoT",
              navigator: Iotscreen(),
            ),
            ButtonHomeScreen(
              imgPath: 'lib/assets/images/black_edit_icon.png',
              textButton: 'Programing',
              navigator: Programingscreen(),
            ),
            ButtonHomeScreen(
              imgPath: 'lib/assets/images/kulbot.png',
              textButton: AppLocalizations.of(context)!.humanControl,
              navigator: humanControl(),
            ),
            ButtonHomeScreen(
              imgPath: 'lib/assets/images/TFlogo.png',
              textButton: 'TFlite Camera',
              navigator: TFliteCamera(),
            ),
            ButtonHomeScreen(
              imgPath: 'lib/assets/images/robothead.png',
              textButton: AppLocalizations.of(context)!.dogControl,
              navigator: dogControl(),
            ),
            ButtonHomeScreen(
              imgPath: 'lib/assets/images/setting.png',
              textButton: AppLocalizations.of(context)!.setting,
              navigator: settingScreen(
                onSendMessage: (String message) {
                  _loadSettings();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
