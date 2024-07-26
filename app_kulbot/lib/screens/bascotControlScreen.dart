import 'package:TEST/utils/BluetoothDeviceListEntry.dart';
import 'package:TEST/utils/GestureHome.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

class Bascotcontrolscreen extends StatefulWidget {
  final bool checkAvailability;

  const Bascotcontrolscreen({this.checkAvailability = true});

  @override
  State<Bascotcontrolscreen> createState() => _BascotcontrolscreenState();
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

class _BascotcontrolscreenState extends State<Bascotcontrolscreen> {
//highlight voice to text
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

  BluetoothState _bluetoothState = BluetoothState.STATE_ON;
  String _address = "...";
  String _name = "...";
  String connectedDeviceName = "...";

  FlutterBluetoothSerial bluetooth = FlutterBluetoothSerial.instance;
  FlutterBluetoothSerial flutterBluetoothSerial =
      FlutterBluetoothSerial.instance;

  bool isPressedSound = false;
  bool isPressedLight = false;
  bool isPressedServo = false;

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

requestLocationPermission().then((_) {
    if (widget.checkAvailability) {
      _startDiscoveryWithTimeout();
    }
});
    _getBondedDevices();
    _checkBluetoothStatus();

    _speech = stt.SpeechToText();
  }

  //hàm kết nối bluetooth
  void _connectToDevice(BluetoothDevice device, BuildContext context) async {
    if (isConnected) {
      Navigator.of(context).pop();
    }
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

// Một hàm để yêu cầu quyền truy cập vị trí
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
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    //   DeviceOrientation.portraitDown,
    //   DeviceOrientation.landscapeLeft,
    //   DeviceOrientation.landscapeRight,
    // ]);

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
              color:
                  _bluetoothState.isEnabled ? Colors.blueAccent : Colors.amber,
              borderRadius: BorderRadius.circular(50.0),
            ),
            child: IconButton(
              icon: _bluetoothState.isEnabled
                  ? Icon(
                      isConnected ? Icons.bluetooth_connected : Icons.bluetooth,
                      color: isConnected ? Colors.green : Colors.red,
                    )
                  : Icon(Icons.bluetooth, color: Colors.red),
              onPressed: () {
                // _bluetoothState.isEnabled
                //     ?
                _startDiscoveryWithTimeout();
                isConnected ? _disconnectDevice() : _connectBluetoothDialog();
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
              GestureDetector(
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
              GestureDetector(
                onTap: () {
                  setState(() {
                    isPressedServo = !isPressedServo;
                    isPressedServo == true ? _light() : _endlight();
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                  color: isPressedServo ? Colors.grey : Colors.green,
                  borderRadius: BorderRadius.circular(50.0),
                  ),
                  padding: EdgeInsets.all(12.0),
                  child: Icon(Icons.swap_horizontal_circle_outlined),
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
                child: Container(
                  decoration: BoxDecoration(
                      color: isPressedSound ? Colors.grey : Colors.green,
                      borderRadius: BorderRadius.circular(50.0)),
                  padding: EdgeInsets.all(12.0),
                  child: Icon(Icons.volume_up),
                ),
              ),
            ]),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // joystick left
            Container(
              width: 170,
              height: 170,
              margin: EdgeInsets.only(bottom: 40, left: 50),
              alignment: const Alignment(0, 0.8),
              child: Joystick(
                  mode: _joystickModeLeft, listener: handleJoystickMove),
            ),
            // label voice to textb
            Column(children: <Widget>[
              Container(
                
                height: MediaQuery.of(context).size.height*0.5,
                width: MediaQuery.of(context).size.width*0.3,
                //padding: const EdgeInsets.only(30.0, 30.0, 30.0, 150.0),
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
            // joystick right
            Container(
              width: 170,
              height: 170,
              margin: EdgeInsets.only(bottom: 40, right: 50),
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
  Widget _buildDevicesListView(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    List<BluetoothDeviceListEntry> list = devices
        .map((_device) => BluetoothDeviceListEntry(
              device: _device.device,
              rssi: _device.rssi,
              enabled: _device.availability == _DeviceAvailability.yes,
              onTap: () {
                // Gọi hàm để kết nối Bluetooth khi người dùng chọn thiết bị
                _connectToDevice(_device.device, context);
              },
            ))
        .toList();

    return Column(
      children: [
        Container(
          color: Colors.grey[50],
          width: screenWidth * 1,
          height: screenHeight * 0.50,
          child: ListView(children: list),
        ),
      ],
    );
  }

  void _sound() {
    if (isPressedSound) {
      // In liên tục khi nút được nhấn giữ
      print('EE');
      _sendMessage('EE');
      Future.delayed(
        Duration(milliseconds: 200),
      );
    }
  }

  void _endsound() {
    if (isPressedSound == false) {
      // In liên tục khi nút được thả
      print('NN');
      _sendMessage('NN');
      Future.delayed(Duration(milliseconds: 200));
    }
  }

  void _light() {
    // In liên tục khi nút được nhấn giữ
    print('O');
    _sendMessage('OO');
    Future.delayed(
      Duration(milliseconds: 200),
    );
  }

  void _endlight() {
    if (isPressedSound == false) {
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

  //hàm gửi data đến thiết bị kết nối
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

// hàm nghe voice to text
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
            moveMotor();
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
      moveMotor();
    }
  }

// ham gui data sau khi ket thuc voice to text
  void moveMotor() {
    if (voicetotext.contains('Tiến') ||
        voicetotext.contains('lên') ||
        voicetotext.contains('forward')) {
      _sendMessage('FF');
    } else if (voicetotext.contains('lui') ||
        voicetotext.contains('lùi') ||
        voicetotext.contains('back')) {
      _sendMessage('BB');
    } else if (voicetotext.contains('trái') || voicetotext.contains('left')) {
      _sendMessage('LL');
    } else if (voicetotext.contains('phải') || voicetotext.contains('right')) {
      _sendMessage('RR');
    }
  }

  //hàm show dialog danh sách các thiết bị bluetooth
  Future<void> _connectBluetoothDialog() async {
    double screenWidth = MediaQuery.of(context).size.width * 1;
    double screenHeight = MediaQuery.of(context).size.height;
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
          alignment: Alignment.center,
          title: const Text(
            'Bluetooth ',
            style: TextStyle(fontSize: 20, color: Colors.black),
          ),
          content: _bluetoothState.isEnabled
              ? _buildDevicesListView(context)
              : Text("Bluetooth chưa được bật")),
    );
  }

  void _closeBluetoothDialog(BuildContext context) {
    Navigator.of(context).pop();
  }

//hàm yêu cầu mở bluetooth
  // void _enableBluetoothAndConnectDialog() async {
  //   // Yêu cầu bật Bluetooth
  //   await FlutterBluetoothSerial.instance.requestEnable();

  //   // Sau khi yêu cầu đã hoàn thành, hiển thị dialog Bluetooth
  //   _connectBluetoothDialog();
  // }

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

  // Hàm để in giá trị _x,_y và gửi chuỗi JSON tương ứng
  void handleJoystickMove(details) {
    _x = 100.0 + 10 * details.x;
    _y = 100.0 + 10 * details.y;
    print("X: ${_x.toStringAsFixed(0)}");
    //_sendMessage('${_x.toStringAsFixed(0)}');
    print("Y: ${_y.toStringAsFixed(0)}");
    //_sendMessage('${_y.toStringAsFixed(0)}');

    String? message;
    if (_y < 100) {
      if (_x < 100) {
        print("Tien Trai");
        _sendMessage("");
      } else if (_x > 100) {
        print("Tien Phai");
        _sendMessage("");
      } else {
        print("Tien");
        _sendMessage("FF");
      }
    } else if (_y > 100) {
      if (_x < 100) {
        print("Lui Trai");
        _sendMessage("");
      } else if (_x > 100) {
        print("Lui Phai");
        _sendMessage("");
      } else {
        print("Lui");
        _sendMessage("BB");
      }
    } else {
      if (_x < 100) {
        print("Trai");
        _sendMessage("LL");
      } else {
        print("Phai");
        _sendMessage("RR");
      }
    }
    // Tạo một đối tượng JSON
    // Map<String, dynamic> jsonData = {
    //   'command': message,
    //   'x': _x.toStringAsFixed(2), // Đưa _x về dạng chuỗi với 2 chữ số thập phân
    //   'y': _y.toStringAsFixed(2),
    // };

    // // Chuyển đối JSON thành chuỗi
    // String jsonString = jsonEncode(jsonData);

    // // Gửi chuỗi JSON đi
    // _sendMessage(jsonString);
    // print(' jsonString: $jsonString');
  }
}
