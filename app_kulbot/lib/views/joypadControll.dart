import 'package:app_kulbot/views/bluetoothscreen.dart';
import 'package:flutter/material.dart';
import 'package:control_pad_plus/control_pad_plus.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

class JoystickControl extends StatefulWidget {
  final BluetoothDevice server;

  const JoystickControl({required this.server});

  @override
  State<JoystickControl> createState() => _JoystickControlState();
}

class _Message {
  int whom;
  String text;

  _Message(this.whom, this.text);
}

class _JoystickControlState extends State<JoystickControl> {
  bool isPressed = false;

  // String lastSentMessage = '';
  double _currentSlidevalue = 1;

  double _x = 100;
  double _y = 100;
  JoystickMode _joystickMode = JoystickMode.all;

  static final clientID = 0;
  BluetoothConnection? connection;

  List<_Message> messages = [];
  String _messageBuffer = '';

  final TextEditingController textEditingController = TextEditingController();
  final ScrollController listScrollController = ScrollController();

  bool isConnecting = true;
  bool get isConnected => (connection?.isConnected ?? false);

  bool isDisconnecting = false;

  // double? degree;
  // double? dist;

  @override
  void initState() {
    super.initState();
    // Cài đặt cố định màn hình ở chế độ ngang
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    BluetoothConnection.toAddress(widget.server.address).then((_connection) {
      print('Connected to the device');
      connection = _connection;
      setState(() {
        isConnecting = false;
        isDisconnecting = false;
      });

      connection!.input!.listen(_onDataReceived).onDone(() {
        if (isDisconnecting) {
          print('Disconnecting locally!');
        } else {
          print('Disconnected remotely!');
        }
        if (this.mounted) {
          setState(() {});
        }
      });
    }).catchError((error) {
      print('Cannot connect, exception occurred');
      print(error);
    });
  }

  @override
  void dispose() {
    // Loại bỏ cài đặt khi StatefulWidget bị hủy
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    if (isConnected) {
      isDisconnecting = true;
      connection?.dispose();
      connection = null;
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final serverName = widget.server.name ?? "Unknown";
    return Scaffold(
      appBar: AppBar(
        title: Text(isConnecting
            ? 'Connecting to $serverName...'
            : isConnected
                ? 'Connected to $serverName'
                : 'Log with $serverName'),
        actions: [
          IconButton(
            icon: Icon(Icons.bluetooth),
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => BluetoothScreen()));
            },
          ),
        ],
      ),
      body:
          Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text('Speed'),
              Slider(
                  value: _currentSlidevalue,
                  label: _currentSlidevalue.toString(),
                  min: 1,
                  max: 9,
                  onChanged: (value) {
                    setState(() {
                      _currentSlidevalue = value;
                      print('${_currentSlidevalue.toInt()}');
                      _sendMessage(
                          '${_currentSlidevalue.toInt()}${_currentSlidevalue.toInt()}');
                    });
                  }),
            ]),
        GestureDetector(
          onTapDown: (_) {
            setState(() {
              isPressed = true;
              _startPrinting();
            });
          },
          onTapUp: (_) {
            setState(() {
              isPressed = false;
              _endPrinting();
            });
          },
          child: Container(
            padding: EdgeInsets.all(12.0),
            color: isPressed ? Colors.blue : Colors.grey,
            child: Text(
              'Press and Hold',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),

        // JoystickView(
        //   innerCircleColor: Color.fromARGB(255, 131, 1, 1),
        //   backgroundColor: Color.fromARGB(255, 166, 1, 1),
        //   onDirectionChanged: (degrees, distance) {
        //     var degree = degrees;
        //     if (degree != null) {
        //       // degree = degrees;
        //       // dist = distance;
        //       print("$degree: $distance");
        //       if ((degree >= 322 || degree <= 32) && degree!= 0) {
        //         debugPrint("FORWARD");
        //         _sendMessage("forward");
        //       } else if (degree >= 230 && degree <= 305) {
        //         debugPrint("LEFT");
        //         _sendMessage("left");
        //       } else if (degree >= 60 && degree <= 125) {
        //         debugPrint("RIGHT");
        //         _sendMessage("right");
        //       } else if (degree >= 155 && degree <= 225) {
        //         debugPrint("BACKWARD");
        //         _sendMessage("backward");
        //       } else if (degree== 0) {
        //         debugPrint("STOP");
        //         _sendMessage("stop");
        //       }
        //     } else {
        //       print("degree is null");
        //     }
        //   },
        // ),
        Align(
          alignment: const Alignment(0, 0.8),
          child: Joystick(
            mode: _joystickMode,
            listener: (details) {
              setState(() {
                double _x = 100 + 10 * details.x;
                double _y = 100 + 10 * details.y;
                print("X: ${_x}");
                print("Y: ${_y}");
                if (_x >= 97 && _x <= 102 && _y < 100 && _y >= 90) {
                  _sendMessage('FF');
                } else if (_x >= 91 && _x <= 96 && _y < 100 && _y > 90) {
                  _sendMessage('GG');
                } else if (_x > 100 && _x <= 108 && _y < 100 && _y >= 90) {
                  _sendMessage('II');
                } else if (_x >= 97 && _x <= 102 && _y > 100 && _y <= 109) {
                  _sendMessage('BB');
                } else if (_x <= 98 && _x >= 91 && _y > 100 && _y <= 109) {
                  _sendMessage('JJ');
                } else if (_x > 100 && _x < 107 && _y > 100 && _y <= 107) {
                  _sendMessage('HH');
                } else if (_x >= 90 && _x < 100 && _y >= 97 && _y <= 102) {
                  _sendMessage('LL');
                } else if (_x > 100 && _x <= 109 && _y >= 97 && _y <= 102) {
                  _sendMessage('RR');
                } else if (_x == 100 && _y == 100) {
                  _sendMessage('SS');
                }
              });
            },
          ),
        ),
      ]),
    );
  }

  void _startPrinting() {
    if (isPressed) {
      // In liên tục khi nút được nhấn giữ
      print('O');
      _sendMessage('OO');
      Future.delayed(Duration(milliseconds: 200), _startPrinting);
    }
  }

  void _endPrinting() {
    if (isPressed == false) {
      // In liên tục khi nút được thả
      print('O');
      _sendMessage('PP');
      Future.delayed(Duration(milliseconds: 200), _endPrinting);
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
  //   String dataString = String.fromCharCodes(buffer);
  //   int index = buffer.indexOf(13);
  //   if (~index != 0) {
  //     setState(() {
  //       messages.add(
  //         _Message(
  //           1,
  //           backspacesCounter > 0
  //               ? _messageBuffer.substring(
  //                   0, _messageBuffer.length - backspacesCounter)
  //               : _messageBuffer + dataString.substring(0, index),
  //         ),
  //       );
  //       _messageBuffer = dataString.substring(index);
  //     });
  //   } else {
  //     _messageBuffer = (backspacesCounter > 0
  //         ? _messageBuffer.substring(
  //             0, _messageBuffer.length - backspacesCounter)
  //         : _messageBuffer + dataString);
  //   }
  // }

  // void _sendMessage(String text) async {
  //   text = text.trim();
  //   textEditingController.clear();

  //   if (text.isNotEmpty) {
  //     try {
  //       connection!.output.add(Uint8List.fromList(utf8.encode(text + "\r\n")));
  //       await connection!.output.allSent;

  //       setState(() {
  //         messages.add(_Message(clientID, text));
  //       });
  //     } catch (e) {
  //       print("Error sending message: $e");
  //     }
  //   }
  // }
  void _sendMessage(String text) async {
    text = text.trim();
    textEditingController.clear();

    if (text.isNotEmpty) {
      try {
        // Gửi tin nhắn xuống ESP32
        connection!.output.add(Uint8List.fromList(utf8.encode(text)));
        await connection!.output.allSent;

        // Thêm tin nhắn vào danh sách tin nhắn
        setState(() {
          messages.add(_Message(clientID, text));
        });
      } catch (e) {
        print("Error sending message: $e");
      }
    }
  }
}
