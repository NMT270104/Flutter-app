import 'package:TEST/BluetoothDeviceListEntry.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

class JoystickControl extends StatefulWidget {
  final bool checkAvailability;

  const JoystickControl({this.checkAvailability = true});

  @override
  State<JoystickControl> createState() => _JoystickControlState();
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

class _Message {
  int whom;
  String text;

  _Message(this.whom, this.text);
}

class _JoystickControlState extends State<JoystickControl> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String voicetotext = "";

  BluetoothState _bluetoothState = BluetoothState.STATE_ON;
  String _address = "...";
  String _name = "...";
  String connectedDeviceName = "...";

  FlutterBluetoothSerial bluetooth = FlutterBluetoothSerial.instance;
  FlutterBluetoothSerial flutterBluetoothSerial =
      FlutterBluetoothSerial.instance;

  bool isPressedLed = false;
  bool isPressedSound = false;

  double _currentSlidevalueTien = 0;
  double _currentSlidevalueLui = 0;

  JoystickMode _joystickModeLeft = JoystickMode.horizontal;
  JoystickMode _joystickModeRight = JoystickMode.vertical;
  // Khai báo biến _x và _y ở mức độ toàn cục
  double _x = 100;
  double _y = 100;

  static final clientID = 0;
  BluetoothConnection? connection;

  List<_Message> messages = [];
  String _messageBuffer = '';

  final TextEditingController textEditingController = TextEditingController();
  final ScrollController listScrollController = ScrollController();

  //bool isConnecting = true;
  bool get isConnected => (connection?.isConnected ?? false);

  bool isDisconnecting = false;

  @override
  void initState() {
    super.initState();
    // Cài đặt cố định màn hình ở chế độ ngang
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

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

    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() {
        _bluetoothState = state;
      });
    });

    if (widget.checkAvailability) {
      _startDiscoveryWithTimeout();
    }

    _getBondedDevices();
    _checkBluetoothStatus();

    _speech = stt.SpeechToText();
  }

  void _connectToDevice(BluetoothDevice device) async {
    try {
      BluetoothConnection connection =
          await BluetoothConnection.toAddress(device.address);
      setState(() {
        // Cập nhật trạng thái kết nối
        _bluetoothState;
        // Lưu tên của thiết bị được kết nối
        connectedDeviceName = device.name ?? "Unknown";
        // Lưu kết nối Bluetooth
        this.connection = connection;
      });

      // Thêm các listeners cho dữ liệu nhận được từ thiết bị
      connection.input?.listen(_onDataReceived).onDone(() {
        // Xử lý khi kết nối bị đóng
        if (isDisconnecting) {
          print('Disconnecting locally!');
        } else {
          print('Disconnected remotely!');
        }
        if (this.mounted) {
          setState(() {});
        }
      });
    } catch (e) {
      // Xử lý khi có lỗi xảy ra trong quá trình kết nối
      print('Error connecting to device: $e');
    }
  }

  // Hàm này bắt đầu quá trình tìm kiếm thiết bị Bluetooth mới.
// Khi một thiết bị mới được phát hiện, nó được thêm vào danh sách devices nếu chưa tồn tại trong danh sách.
  void _startDiscoveryWithTimeout() {
    Timer(Duration(seconds: 10), () {
      // Dừng quá trình tìm kiếm sau 10 giây
      FlutterBluetoothSerial.instance.cancelDiscovery();
    });
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
    FlutterBluetoothSerial.instance
        .getBondedDevices()
        .then((List<BluetoothDevice> bondedDevices) {
      setState(() {
        devices = bondedDevices
            .map((device) => _DeviceWithAvailability(
                  device,
                  widget.checkAvailability
                      ? _DeviceAvailability.maybe
                      : _DeviceAvailability.yes,
                ))
            .toList();
      });
    });
  }

  void _checkBluetoothStatus() {
    flutterBluetoothSerial.state.then((state) {
      setState(() {
        _bluetoothState;
      });
    });
  }

  List<_DeviceWithAvailability> devices = [];
  @override
  void dispose() {
    // Loại bỏ cài đặt khi StatefulWidget bị hủy
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    FlutterBluetoothSerial.instance.cancelDiscovery();

    if (isConnected) {
      isDisconnecting = true;
      connection?.dispose();
      connection = null;
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //final serverName = widget.server?.name ?? "Unknown";
    return Scaffold(
      appBar: AppBar(
        title: Text(isConnected
            ? 'Đã kết nối với robot $connectedDeviceName'
            : 'Chưa kết nối với robot'),
        actions: [
          Container(
            decoration: BoxDecoration(
              color: _bluetoothState.isEnabled ? Colors.blueAccent : Colors.amber,
              borderRadius: BorderRadius.circular(50.0),
            ),
            child: IconButton(
              icon: _bluetoothState.isEnabled
                  ? Icon(
                      isConnected?
                      Icons.bluetooth_connected : Icons.bluetooth,
                      color: isConnected? Colors.green : Colors.red,
                    )
                  : Icon(Icons.bluetooth, color: Colors.red),
              onPressed: () {
                // _bluetoothState.isEnabled
                //     ?
                _connectBluetoothDialog();
                    //: _enableBluetoothAndConnectDialog();
              },
            ),
          ),
          Padding(padding: EdgeInsets.only(right: 20)),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
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
      body:
          Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text('Voice'),
              GestureDetector(
                
                onTapDown: (_) {
                  setState(() {
                    isPressedLed = true;
                    _led();
                  });
                },
                onTapUp: (_) {
                  setState(() {
                    isPressedLed = false;
                    _endled();
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(50.0)
                  ),
                  padding: EdgeInsets.all(12.0),
                  child: IconButton(
                    icon: Icon(Icons.volume_up),
                    onPressed: () {
                      
                    },
                  ),
                ),
              ),
            ]),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 150,
              height: 150,
              margin: EdgeInsets.only(top: 40, left: 10),
              alignment: const Alignment(0, 0.8),
              child: Joystick(
                  mode: _joystickModeLeft, listener: handleJoystickMove),
            ),
            // Container(
            //   margin: EdgeInsets.only(top: 50),
            //   decoration: BoxDecoration(
            //       color: Colors.green, borderRadius: BorderRadius.circular(50)),
            //   child: IconButton(

            //     icon: Icon(_isListening? Icons.mic : Icons.mic_none),
            //     onPressed: () {

            //     },
            //   ),
            // ),
            Container(
              width: 150,
              height: 150,
              margin: EdgeInsets.only(top: 40, right: 10),
              alignment: const Alignment(0, 0.8),
              child: Joystick(
                  mode: _joystickModeRight, listener: handleJoystickMove),
            ),
          ],
        )
      ]),
    );
  }

//   Hàm này xây dựng giao diện danh sách các thiết bị Bluetooth được hiển thị.
// Nó tạo ra các mục danh sách từ danh sách devices
  Widget _buildDevicesListView() {
    List<BluetoothDeviceListEntry> list = devices
        .map((_device) => BluetoothDeviceListEntry(
              device: _device.device,
              rssi: _device.rssi,
              enabled: _device.availability == _DeviceAvailability.yes,
              onTap: () {
                // Gọi hàm để kết nối Bluetooth khi người dùng chọn thiết bị
                _connectToDevice(_device.device);
              },
            ))
        .toList();

    return Column(
      children: [
        Container(
          color: Colors.grey,
          width: 500,
          height: 193,
          child: ListView(children:
          list),
        ),
        IconButton(
          color: Colors.green,

                onPressed: () {
                  _startDiscoveryWithTimeout();
                }, icon: Icon(Icons.autorenew),
            ),

      ],
    );
  }

  // void _tien() {
  //   if (isPressedTien) {
  //     // In liên tục khi nút được nhấn giữ
  //     print('FF');
  //     _sendMessage('FF');
  //     Future.delayed(Duration(milliseconds: 200), () {
  //       _tien();
  //     });
  //   }
  // }

  // void _lui() {
  //   if (isPressedLui) {
  //     // In liên tục khi nút được nhấn giữ
  //     print('BB');
  //     _sendMessage('BB');
  //     Future.delayed(Duration(milliseconds: 200), _lui);
  //   }
  // }

  // void _stop() {
  //   if (isPressedTien == false && isPressedLui == false) {
  //     // In liên tục khi nút được thả
  //     print('SS');
  //     _sendMessage('SS');
  //     Future.delayed(Duration(milliseconds: 200));
  //   }
  // }

  void _led() {
    if (isPressedLed) {
      // In liên tục khi nút được nhấn giữ
      print('O');
      _sendMessage('OO');
      Future.delayed(Duration(milliseconds: 200),);
    }
  }

  void _endled() {
    if (isPressedLed == false) {
      // In liên tục khi nút được thả
      print('PP');
      _sendMessage('PP');
      Future.delayed(Duration(milliseconds: 200));
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
        connection!.output.add(Uint8List.fromList(ascii.encode(text)));
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

  void _listenVoiceToText() async {
    if (!_isListening) {
      print('_listenVoiceToText : false');
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        print("_listenVoiceToText : true");
        _speech.listen(
          onResult: (val) => setState(() {
            voicetotext = val.recognizedWords;
            _sendMessage(voicetotext);
            print("VoiceToText: $voicetotext");
            // if (val.hasConfidenceRating && val.confidence > 0) {
            //   _confidence = val.confidence;
            // }
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  Future<void> _connectBluetoothDialog() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
          titlePadding: EdgeInsets.only(left: 20, top: 3),
          title: Text(
            'Bluetooth',
            style: TextStyle(fontSize: 20),
          ),
          content: isConnected ? _disconnectDevice() : _buildDevicesListView()
      ),
    );
  }

//hàm yêu cầu mở bluetooth
  void _enableBluetoothAndConnectDialog() async {
    // Yêu cầu bật Bluetooth
    await FlutterBluetoothSerial.instance.requestEnable();

    // Sau khi yêu cầu đã hoàn thành, hiển thị dialog Bluetooth
    _connectBluetoothDialog();
  }

// hàm ngắt kết nối với thiết bị
  _disconnectDevice() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          minimumSize: Size(50, 40),
        ),
        onPressed: () {
          connection?.dispose();
        },
        child: Text('Ngắt kết nối với $connectedDeviceName'));
  }

  // Hàm để in giá trị _x và gửi chuỗi JSON tương ứng
  void handleJoystickMove(details) {
    _x = 100.00 + 10 * details.x;
    _y = 100.00 + 10 * details.y;
    // print("X: ${_x}");
    // print("Y: ${_y}");

    String? message;
    if (_x < 100) {
      message = 'LL';
      print("LL");
    } else if (_x < 100 && _y < 100) {
      message = 'GG';
      print("GG");
    } else if (_x < 100 && _y > 100) {
      message = 'JJ';
      print("JJ");
    } else if (_x > 100) {
      message = 'RR';
      print("RR");
    } else if (_x > 100 && _y < 100) {
      message = 'II';
      print("II");
    } else if (_x > 100 && _y > 100) {
      message = 'HH';
      print("HH");
    } else if (_x == 100 && _y == 100) {
      message = 'SS';
      print("SS");
    } else if (_y > 100) {
      message = 'BB';
      print("BB");
    } else if (_y < 100) {
      message = 'FF';
      print("FF");
    }

    // Tạo một đối tượng JSON
    Map<String, dynamic> jsonData = {
      'command': message,
      'x': _x.toStringAsFixed(2), // Đưa _x về dạng chuỗi với 2 chữ số thập phân
      'y': _y.toStringAsFixed(2),
    };

    // Chuyển đối JSON thành chuỗi
    String jsonString = jsonEncode(jsonData);

    // Gửi chuỗi JSON đi
    _sendMessage(jsonString);
    print(' jsonString: $jsonString');
  }
}
