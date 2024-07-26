import 'package:TEST/screens/scanQRcodeScreen.dart';
import 'package:TEST/screens/settingScreen.dart';
import 'package:flutter/material.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:showcaseview/showcaseview.dart';
import '../service/bluetooth_service.dart';

GlobalKey _one = GlobalKey();
GlobalKey _two = GlobalKey();
GlobalKey _three = GlobalKey();
GlobalKey _four = GlobalKey();
GlobalKey _five = GlobalKey();
GlobalKey _six = GlobalKey();
GlobalKey _seven = GlobalKey();
GlobalKey _eight = GlobalKey();

class JoystickControl extends StatefulWidget {
  final bool checkAvailability;

  const JoystickControl({this.checkAvailability = true});

  @override
  State<JoystickControl> createState() => _JoystickControlState();
}

class _Message {
  int whom;
  String text;

  _Message(this.whom, this.text);
}

class _JoystickControlState extends State<JoystickControl> {
  String _moveForwardCommand = 'FF';
  String _moveBackwardCommand = 'BB';
    String _moveTurnLeftCommand = 'LL';
  String _moveTurnRightCommand = 'RR';

  final BluetoothService _bluetoothService = BluetoothService();

  final Map<String, HighlightedWord> _highlights = {
    'flutter': HighlightedWord(
      onTap: () => print('flutter'),
      textStyle: const TextStyle(
        color: Colors.blue,
        fontWeight: FontWeight.bold,
      ),
    ),
    'right': HighlightedWord(
      onTap: () => print('right'),
      textStyle: const TextStyle(
        color: Colors.green,
        fontWeight: FontWeight.bold,
      ),
    ),
    'left': HighlightedWord(
      onTap: () => print('left'),
      textStyle: const TextStyle(
        color: Colors.red,
        fontWeight: FontWeight.bold,
      ),
    ),
  };

  late stt.SpeechToText _speech;
  bool _isListening = false;
  String voicetotext = "";

  bool isPressedSound = false;
  bool isPressedLight = false;

  double _currentSlidevalueTien = 0;
  double _currentSlidevalueLui = 0;

  JoystickMode _joystickModeLeft = JoystickMode.horizontal;
  JoystickMode _joystickModeRight = JoystickMode.vertical;
  double _x = 100;
  double _y = 100;

  static final clientID = 0;
  List<_Message> messages = [];
  String _messageBuffer = '';

  final TextEditingController textEditingController = TextEditingController();
  final ScrollController listScrollController = ScrollController();

  bool get isConnected => (_bluetoothService.connection?.isConnected ?? false);

  String? _scanQRres;

  @override
  void initState() {
    super.initState();

    _loadSettings();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        _bluetoothService.bluetoothState = state;
      });
    });

    FlutterBluetoothSerial.instance.address.then((address) {
      setState(() {
        _bluetoothService.address = address!;
      });
    });

    FlutterBluetoothSerial.instance.name.then((name) {
      setState(() {
        _bluetoothService.name = name!;
      });
    });

    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() {
        _bluetoothService.bluetoothState = state;
      });
    });

    _bluetoothService.requestLocationPermission().then((_) {
      if (widget.checkAvailability) {
        _bluetoothService.startDiscoveryWithTimeout();
      }
    });

    _bluetoothService.getBondedDevices();
    _checkBluetoothStatus();

    _speech = stt.SpeechToText();
  }

  void _checkBluetoothStatus() {
    _bluetoothService.flutterBluetoothSerial.state.then((state) {
      setState(() {
        _bluetoothService.bluetoothState = state;
      });
    });
  }

  // Future<void> scanQRcodeNormal() async {
  //   String? ScanResult;
  //   try {
  //     ScanResult = await FlutterBarcodeScanner.scanBarcode(
  //         '#ff6666', 'Cancel', true, ScanMode.QR);
  //     print(ScanResult.toString());
  //     _bluetoothService.sendMessage(ScanResult.toString());
  //   } on PlatformException catch (e) {
  //     print('Error scanning qr: $e');
  //   }
  //   if (!mounted) return;
  //   setState(() {
  //     _scanQRres = ScanResult;
  //   });
  // }

  Future<void> scanQRcodeNormal() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ScanqrcodeScreen(
          onScanComplete: (String result) {
            _bluetoothService.sendMessage(result);
          },
        ),
      ),
    );
  }

  Future<void> _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _moveForwardCommand = prefs.getString('moveForward') ?? 'FF';
      _moveBackwardCommand = prefs.getString('moveBackward') ?? 'BB';
      _moveTurnLeftCommand = prefs.getString('moveTurnLeft') ?? 'LL';
      _moveTurnRightCommand = prefs.getString('moveTurnRight') ?? 'RR';
    });
  }

  // Future<void> openSettings() async {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => settingScreen(
  //         onSendMessage: (String message) {
  //           _bluetoothService.sendMessage(message);
  //           _loadSettings();
  //         },
  //       ),
  //     ),
  //   );
  // }

  @override
  void dispose() {
    _bluetoothService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: Text(isConnected
              ? 'Đã kết nối với robot ${_bluetoothService.connectedDeviceName}'
              : 'Chưa kết nối với robot'),
          actions: [
            // Container(
            //     decoration: BoxDecoration(
            //       color: Colors.blue,
            //       borderRadius: BorderRadius.circular(50.0),
            //     ),
            //     child: IconButton(
            //         icon: Icon(Icons.settings),
            //         onPressed: () {
            //           openSettings();
            //         })),
            //         SizedBox(width: 10,),
            Showcase(
              key: _one,
              description: 'Đây là nút hướng dẫn sử dụng điều khiển robot',
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(50.0),
                ),
                child: IconButton(
                    icon: Icon(Icons.question_mark_rounded),
                    onPressed: () {
                      ShowCaseWidget.of(context).startShowCase([
                        _one,
                        _two,
                        _three,
                        _four,
                        _five,
                        _six,
                        _seven,
                        _eight
                      ]);
                    }),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Showcase(
              key: _two,
              description: 'Đây là nút quét mã QR để điều khiển robot',
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(50.0),
                ),
                child: IconButton(
                    icon: Icon(Icons.qr_code_scanner_outlined),
                    onPressed: scanQRcodeNormal),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Showcase(
              key: _three,
              description: 'Bấm vào nút này để bật / tắt bluetooth \n'
                  'Trong danh sách bluetooth, chọn tên robot cần kết nối \n',
              child: Container(
                decoration: BoxDecoration(
                  color: _bluetoothService.bluetoothState.isEnabled
                      ? Colors.blueAccent
                      : Colors.amber,
                  borderRadius: BorderRadius.circular(50.0),
                ),
                child: IconButton(
                  icon: _bluetoothService.bluetoothState.isEnabled
                      ? Icon(
                          isConnected
                              ? Icons.bluetooth_connected
                              : Icons.bluetooth,
                          color: isConnected ? Colors.green : Colors.red,
                        )
                      : Icon(Icons.bluetooth, color: Colors.red),
                  onPressed: () {
                    _bluetoothService.startDiscoveryWithTimeout();
                    isConnected
                        ? _bluetoothService.connection?.dispose()
                        : _bluetoothService.connectBluetoothDialog(context);
                  },
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(right: 20)),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Showcase(
          key: _four,
          description: 'Bấm vào nút này để điều khiển robot bằng giọng nói',
          child: AvatarGlow(
            animate: _isListening,
            glowColor: Colors.green,
            duration: const Duration(milliseconds: 2000),
            repeat: true,
            child: FloatingActionButton(
              backgroundColor: Colors.green,
              onPressed: _listenVoiceToText,
              child: Icon(_isListening ? Icons.mic : Icons.mic_none),
            ),
          ),
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Showcase(
                      key: _five,
                      description: 'Bấm vào nút này để bật đèn robot',
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isPressedLight = !isPressedLight;
                            isPressedLight == true ? _light() : _endlight();
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: isPressedLight ? Colors.grey : Colors.green,
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          padding: EdgeInsets.all(12.0),
                          child: Icon(Icons.tips_and_updates_outlined),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTapDown: (_) {
                        setState(() {
                          isPressedSound = true;
                          _sound();
                        });
                      },
                      onTapUp: (_) {
                        setState(() {
                          isPressedSound = false;
                          _endsound();
                        });
                      },
                      child: Showcase(
                        key: _six,
                        description: 'Bấm vào nút này để bật kèn robot',
                        child: Container(
                          decoration: BoxDecoration(
                              color:
                                  isPressedSound ? Colors.grey : Colors.green,
                              borderRadius: BorderRadius.circular(50.0)),
                          padding: EdgeInsets.all(12.0),
                          child: Icon(Icons.volume_up),
                        ),
                      ),
                    ),
                  ]),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Showcase(
                    key: _seven,
                    description: 'Đây là nút di chuyển robot',
                    child: Container(
                      width: 170,
                      height: 170,
                      margin: EdgeInsets.only(bottom: 40, left: 50),
                      alignment: const Alignment(0, 0.8),
                      child: Joystick(
                          mode: _joystickModeLeft,
                          listener: handleJoystickMove),
                    ),
                  ),
                  Column(children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height * 0.5,
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: TextHighlight(
                        textAlign: TextAlign.center,
                        text: voicetotext == '' ? "..." : voicetotext,
                        words: _highlights,
                        textStyle: const TextStyle(
                          fontSize: 32.0,
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ]),
                  Showcase(
                    key: _eight,
                    description: 'Đây là nút di chuyển robot',
                    child: Container(
                      width: 170,
                      height: 170,
                      margin: EdgeInsets.only(bottom: 40, right: 50),
                      alignment: const Alignment(0, 0.8),
                      child: Joystick(
                          mode: _joystickModeRight,
                          listener: handleJoystickMove),
                    ),
                  ),
                ],
              )
            ]),
      ),
    );
  }

  void _sound() {
    if (isPressedSound) {
      print('EE');
      _bluetoothService.sendMessage('EE');
      Future.delayed(
        Duration(milliseconds: 200),
      );
    }
  }

  void _endsound() {
    if (isPressedSound == false) {
      print('NN');
      _bluetoothService.sendMessage('NN');
      Future.delayed(Duration(milliseconds: 200));
    }
  }

  void _light() {
    print('O');
    _bluetoothService.sendMessage('OO');
    Future.delayed(
      Duration(milliseconds: 200),
    );
  }

  void _endlight() {
    if (isPressedSound == false) {
      print('PP');
      _bluetoothService.sendMessage('PP');
      Future.delayed(Duration(milliseconds: 200));
    }
  }

  void _listenVoiceToText() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            voicetotext = val.recognizedWords;
            //_bluetoothService.sendMessage(voicetotext);
            moveMotor();
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
      moveMotor();
    }
  }

  void moveMotor() {
    if (voicetotext.contains('Tiến') ||
        voicetotext.contains('lên') ||
        voicetotext.contains('forward')) {
      _bluetoothService.sendMessage('f');
    } else if (voicetotext.contains('lui') ||
        voicetotext.contains('lùi') ||
        voicetotext.contains('back')) {
      _bluetoothService.sendMessage('b');
    } else if (voicetotext.contains('trái') || voicetotext.contains('left')) {
      _bluetoothService.sendMessage('l');
    } else if (voicetotext.contains('phải') || voicetotext.contains('right')) {
      _bluetoothService.sendMessage('r');
    } else if (voicetotext.contains('dừng lại') ||
        voicetotext.contains('stop')) {
      _bluetoothService.sendMessage('s');
    }
  }

  void handleJoystickMove(details) {
    _x = 100.0 + 10 * details.x;
    _y = 100.0 + 10 * details.y;
    String? message;
    if (_y < 100) {
      if (_x < 100) {
        print("Tien Trai");
        _bluetoothService.sendMessage("");
      } else if (_x > 100) {
        print("Tien Phai");
        _bluetoothService.sendMessage("");
      } else {
        print("Tien");
        //_bluetoothService.sendMessage("FF");
        _bluetoothService.sendMessage(_moveForwardCommand);
      }
    } else if (_y > 100) {
      if (_x < 100) {
        print("Lui Trai");
        _bluetoothService.sendMessage("");
      } else if (_x > 100) {
        print("Lui Phai");
        _bluetoothService.sendMessage("");
      } else {
        print("Lui");
        //_bluetoothService.sendMessage("BB");
        _bluetoothService.sendMessage(_moveBackwardCommand);
      }
    } else if (_x == 100 && _y == 100) {
      _bluetoothService.sendMessage("SS");
    } else {
      if (_x < 100) {
        print("Trai");
      _bluetoothService.sendMessage(_moveTurnLeftCommand);

      } else {
        print("Phai");
        _bluetoothService.sendMessage(_moveTurnRightCommand);
        
      }
    }
  }
}
