import 'dart:async';
import 'dart:convert';

import 'package:Kulbot/utils/AnimatedToggleSwitch.dart';
import 'package:Kulbot/utils/SleekCircularSlider.dart';
import 'package:Kulbot/widgets/settingIoT_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../service/bluetooth_service.dart';

class IotWidget extends StatefulWidget {
  final bool checkAvailability;
  const IotWidget({super.key, this.checkAvailability = true});

  @override
  State<IotWidget> createState() => _IotWidgetState();
}

class _IotWidgetState extends State<IotWidget> {
  String _ControllerSwitch1_On = "";
  String _ControllerSwitch1_Off = "";

  String _ControllerSwitch2_On = "";
  String _ControllerSwitch2_Off = "";

  String _ControllerLight1_On = "";
  String _ControllerLight1_Off = "";

  String _ControllerLight2_On = "";
  String _ControllerLight2_Off = "";

  final TextEditingController _editingSCS_title_1 = TextEditingController();
  final TextEditingController _editingSCS_dv_1 = TextEditingController();
  String SCS_title_1 = "";
  String SCS_dv_1 = "";

  final TextEditingController _editingSCS_title_2 = TextEditingController();
  final TextEditingController _editingSCS_dv_2 = TextEditingController();
  String SCS_title_2 = "";
  String SCS_dv_2 = "";

  final TextEditingController _editingSCS_title_3 = TextEditingController();
  final TextEditingController _editingSCS_dv_3 = TextEditingController();
  String SCS_title_3 = "";
  String SCS_dv_3 = "";

  final TextEditingController _editingSCS_title_4 = TextEditingController();
  final TextEditingController _editingSCS_dv_4 = TextEditingController();
  String SCS_title_4 = "";
  String SCS_dv_4 = "";

  final BluetoothService _bluetoothService = BluetoothService();
  bool get isConnected => (_bluetoothService.connection?.isConnected ?? false);
  String connectedDeviceName = "...";

  bool switch1 = false;
  bool switch2 = false;
  Color _containerColor_1 = Colors.blue;
  Color _containerColor_2 = Colors.blue;

  late Stream<List<int>> stream;
  bool isConnecting = false;
  late List<String> _temphumidata;
  double _currentValueTemp = 0.0;
  double _currentValueHumidity = 0.0;

  StreamSubscription? _subscription;
  
  @override
  void initState() {
    super.initState();
    stream = Stream.empty(); // This will ensure stream is not null
    _loadSettings();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    _bluetoothService.startDiscoveryWithTimeout();

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
    _bluetoothService.onDeviceConnected = (String deviceName) {
      setState(() {
        connectedDeviceName = deviceName;
      });
    };

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
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    _bluetoothService.connection!.dispose();
    super.dispose();
  }

  Future<void> _saveSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('_editingSCS_title_1', _editingSCS_title_1.text);
    await prefs.setString('_editingSCS_dv_1', _editingSCS_dv_1.text);

    await prefs.setString('_editingSCS_title_2', _editingSCS_title_2.text);
    await prefs.setString('_editingSCS_dv_2', _editingSCS_dv_2.text);

    await prefs.setString('_editingSCS_title_3', _editingSCS_title_3.text);
    await prefs.setString('_editingSCS_dv_3', _editingSCS_dv_3.text);

    await prefs.setString('_editingSCS_title_4', _editingSCS_title_4.text);
    await prefs.setString('_editingSCS_dv_4', _editingSCS_dv_4.text);
  }

  Future<void> _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _ControllerSwitch1_On =
          prefs.getString('_editingControllerSwitch1_On') ?? '';
      _ControllerSwitch1_Off =
          prefs.getString('_editingControllerSwitch1_Off') ?? '';

      _ControllerSwitch2_On =
          prefs.getString('_editingControllerSwitch2_On') ?? '';
      _ControllerSwitch2_Off =
          prefs.getString('_editingControllerSwitch2_Off') ?? '';

      _ControllerLight1_On =
          prefs.getString('_editingControllerLight1_On') ?? '';
      _ControllerLight1_Off =
          prefs.getString('_editingControllerLight1_Off') ?? '';

      _ControllerLight2_On =
          prefs.getString('_editingControllerLight2_On') ?? '';
      _ControllerLight2_Off =
          prefs.getString('_editingControllerLight2_Off') ?? '';

      SCS_title_1 = prefs.getString('_editingSCS_title_1') ?? 'Temp 1';
      //_editingSCS_title_1.text = prefs.getString('_editingSCS_title_1')?? 'Temp 1';
      SCS_dv_1 = prefs.getString('_editingSCS_dv_1') ?? '˚C';
      //_editingSCS_dv_1.text = prefs.getString('_editingSCS_dv_1')?? '˚C';

      SCS_title_2 = prefs.getString('_editingSCS_title_2') ?? 'Humidity 2';
      //_editingSCS_title_2.text = prefs.getString('_editingSCS_title_2')?? 'Humidity 2';
      SCS_dv_2 = prefs.getString('_editingSCS_dv_2') ?? '%';
      //_editingSCS_dv_2.text = prefs.getString('_editingSCS_dv_2')?? '%';

      SCS_title_3 = prefs.getString('_editingSCS_title_3') ?? 'Temp 3';
      //_editingSCS_title_3.text = prefs.getString('_editingSCS_title_3')?? 'Temp 3';
      SCS_dv_3 = prefs.getString('_editingSCS_dv_3') ?? '˚C';
      //_editingSCS_dv_3.text = prefs.getString('_editingSCS_dv_3')?? '˚C';

      SCS_title_4 = prefs.getString('_editingSCS_title_4') ?? 'Humidity 4';
      //_editingSCS_title_4.text = prefs.getString('_editingSCS_title_4')?? 'Humidity 4';
      SCS_dv_4 = prefs.getString('_editingSCS_dv_4') ?? '%';
      //_editingSCS_dv_4.text = prefs.getString('_editingSCS_dv_4')?? '%';

      // print(
      //     "Loaded settings: $_ControllerSwitch1_On, $_ControllerSwitch1_Off, $_ControllerSwitch2_On, $_ControllerSwitch2_Off");
      // Fluttertoast.showToast(
      //     msg:
      //         "Loaded settings: $_ControllerSwitch1_On, $_ControllerSwitch1_Off, $_ControllerSwitch2_On, $_ControllerSwitch2_Off");
    });
  }

  Future<void> _delayedLoadSettings() async {
  // Gọi _loadSettings() lần đầu
  await _loadSettings();

  // Tạo độ trễ, ví dụ 2 giây
  await Future.delayed(Duration(milliseconds: 500));

  // Gọi _loadSettings() lần thứ hai
  await _loadSettings();
}


  List<double> _dataParser(List<int> dataFromDevice) {
  // Convert raw byte data to a string
  String dataString = utf8.decode(dataFromDevice);
  
  // Remove whitespace to clean up the string
  dataString = dataString.replaceAll(' ', '');

  // Split the data using the semicolon as a delimiter
  List<String> dataList = dataString.split(';');

  // Prepare a list to store parsed values, initializing it for 2 values (temperature and humidity)
  List<double> parsedValues = List.filled(2, 0.0);

  for (var item in dataList) {
    if (item.isNotEmpty) {
      // Split each entry by the colon to separate 'id x:' from the value
      var parts = item.split(':');
      if (parts.length == 2) {
        // Extract id and value
        int id = int.parse(parts[0].replaceAll('id', '')) - 1; // Get 0-indexed ID
        double value = double.parse(parts[1]);

        if (id >= 0 && id < parsedValues.length) {
          parsedValues[id] = value; // Assign the parsed value to the correct index
        }
      }
    }
  }

  return parsedValues;
}


  void _connectAndStartReceiving() async {
    setState(() {
      isConnecting = true;
    });

    try {
      // Kết nối với thiết bị
      await _bluetoothService.connectBluetoothDialog(context);

      if (_bluetoothService.connection!.isConnected) {
  setState(() {
    Fluttertoast.showToast(
        msg: "Connected to device " + connectedDeviceName);
    print("Connected to device " + connectedDeviceName);
    isConnecting = false;
  });

  // Chờ một chút trước khi nhận dữ liệu
  await Future.delayed(Duration(seconds: 1));

  setState(() {
    stream = _bluetoothService.receiveDataStream();
    Fluttertoast.showToast(msg: "Temp: ${stream}");
    print("Temp: ${stream}");
  });
} else {
  throw Exception("Kết nối không thành công.");
}

    } catch (e) {
      setState(() {
        isConnecting = false;
      });
      print('Error connecting to device: $e');
    }
  }

  void _listenForESPResponseSwitch() {
    _subscription?.cancel();
    _subscription = stream.listen((data) {
      String response = utf8.decode(data);

      // Assuming ESP sends back 'OK' when successful
      if (response.contains(_ControllerLight1_On)) {
        setState(() {
          // Update the color of the container to green
          _containerColor_1 = Colors.green;
        });
      } else if (response.contains(_ControllerLight1_Off)) {
        _containerColor_2 = Colors.red;
      } else if (response.contains(_ControllerLight2_On)) {
        _containerColor_2 = Colors.green;
      } else if (response.contains(_ControllerLight2_Off)) {
        _containerColor_2 = Colors.red;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'IOT',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.amber,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 18,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50.0),
            ),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingiotWidget()),
                ).then((_) {
                  // Sau khi quay lại, load lại dữ liệu từ SharedPreferences
                  _loadSettings();
                });
              },
              icon: Icon(Icons.settings),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50.0),
              ),
              child: IconButton(
                icon: _bluetoothService.bluetoothState.isEnabled
                    ? Icon(
                        _bluetoothService.connection != null &&
                                _bluetoothService.connection!.isConnected
                            ? Icons.bluetooth_connected
                            : Icons.bluetooth,
                        color: _bluetoothService.connection != null &&
                                _bluetoothService.connection!.isConnected
                            ? Colors.green
                            : Colors.red,
                      )
                    : Icon(Icons.bluetooth, color: Colors.red),
                onPressed: () {
                  _connectAndStartReceiving(); // Kết nối và nhận dữ liệu
                },
              ),
            ),
          ),
        ],
      ),
      body: isConnecting
          ? Center(child: CircularProgressIndicator())
          : stream == null
              ? Center(child: Text('Chưa kết nối với thiết bị Bluetooth.'))
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        child: StreamBuilder<List<int>>(
                          stream: stream,
                          builder: (BuildContext context, AsyncSnapshot<List<int>> snapshot) {
                            if (snapshot.hasError) return Text('Error: ${snapshot.error}');
                            if (snapshot.connectionState == ConnectionState.active && snapshot.hasData) {
                              // Parse the incoming data
                              var parsedValues = _dataParser(snapshot.data!);
                              
                              // Ensure you have exactly two values: temperature and humidity
                              if (parsedValues.length == 2) {
                                setState(() {
                                  _currentValueTemp = parsedValues[0];    // Temperature value
                                  _currentValueHumidity = parsedValues[1]; // Humidity value
                                });
                              }
                              return Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        child: SCS(
                                          value: parsedValues[0],
                                          unit: SCS_dv_1.isEmpty
                                              ? '˚C'
                                              : SCS_dv_1,
                                          trackColor: Colors.amber,
                                          progressBarColor: Colors.orange,
                                          min: 0,
                                          max: 100,
                                          trackWidth: 5,
                                          progressBarWidth: 20,
                                          bottomLabelText: SCS_title_1.isEmpty
                                              ? 'Temp 1'
                                              : SCS_title_1,
                                          editingControllerTitle:
                                              _editingSCS_title_1,
                                          editingControllerUnit:
                                              _editingSCS_dv_1,
                                          onPress: () {
                                            _saveSettings();
                                            Navigator.pop(context);
                                            _delayedLoadSettings();
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        child: SCS(
                                          value: parsedValues[1],
                                          unit:
                                              SCS_dv_2.isEmpty ? '%' : SCS_dv_2,
                                          trackColor: Colors.amber,
                                          progressBarColor: Colors.orange,
                                          min: 0,
                                          max: 100,
                                          trackWidth: 5,
                                          progressBarWidth: 20,
                                          bottomLabelText: SCS_title_2.isEmpty
                                              ? 'Humidity 2'
                                              : SCS_title_2,
                                          editingControllerTitle:
                                              _editingSCS_title_2,
                                          editingControllerUnit:
                                              _editingSCS_dv_2,
                                          onPress: () {
                                            _saveSettings();
                                            Navigator.pop(context);
                                            _delayedLoadSettings();
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        child: SCS(
                                          value: 0, //parsedValues[2],
                                          unit: SCS_dv_3.isEmpty
                                              ? '˚C'
                                              : SCS_dv_3,
                                          trackColor: Colors.amber,
                                          progressBarColor: Colors.orange,
                                          min: 0,
                                          max: 100,
                                          trackWidth: 5,
                                          progressBarWidth: 20,
                                          bottomLabelText: SCS_title_3.isEmpty
                                              ? 'Temp 3'
                                              : SCS_title_3,
                                          editingControllerTitle:
                                              _editingSCS_title_3,
                                          editingControllerUnit:
                                              _editingSCS_dv_3,
                                          onPress: () {
                                            _saveSettings();
                                            Navigator.pop(context);
                                            _delayedLoadSettings();

                                          },
                                        ),
                                      ),
                                      Expanded(
                                        child: SCS(
                                          value: 0,// parsedValues[3],
                                          unit:
                                              SCS_dv_4.isEmpty ? '%' : SCS_dv_4,
                                          trackColor: Colors.amber,
                                          progressBarColor: Colors.orange,
                                          min: 0,
                                          max: 100,
                                          trackWidth: 5,
                                          progressBarWidth: 20,
                                          bottomLabelText: SCS_title_4.isEmpty
                                              ? 'Humtidity 4'
                                              : SCS_title_4,
                                          editingControllerTitle:
                                              _editingSCS_title_4,
                                          editingControllerUnit:
                                              _editingSCS_dv_4,
                                          onPress: () {
                                            _saveSettings();
                                            Navigator.pop(context);
                                            _delayedLoadSettings();

                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            } else {
                              return Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        child: SCS(
                                          value: 0,
                                          unit: SCS_dv_1.isEmpty
                                              ? '˚C'
                                              : SCS_dv_1,
                                          trackColor: Colors.amber,
                                          progressBarColor: Colors.orange,
                                          min: 0,
                                          max: 100,
                                          trackWidth: 5,
                                          progressBarWidth: 20,
                                          bottomLabelText: SCS_title_1.isEmpty
                                              ? 'Temp 1'
                                              : SCS_title_1,
                                          editingControllerTitle:
                                              _editingSCS_title_1,
                                          editingControllerUnit:
                                              _editingSCS_dv_1,
                                          onPress: () {
                                            _saveSettings();
                                            Navigator.pop(context);
                                            _delayedLoadSettings();

                                          },
                                        ),
                                      ),
                                      Expanded(
                                        child: SCS(
                                          value: 0,
                                          unit:
                                              SCS_dv_2.isEmpty ? '%' : SCS_dv_2,
                                          trackColor: Colors.amber,
                                          progressBarColor: Colors.orange,
                                          min: 0,
                                          max: 100,
                                          trackWidth: 5,
                                          progressBarWidth: 20,
                                          bottomLabelText: SCS_title_2.isEmpty
                                              ? 'Humidity 2'
                                              : SCS_title_2,
                                          editingControllerTitle:
                                              _editingSCS_title_2,
                                          editingControllerUnit:
                                              _editingSCS_dv_2,
                                          onPress: () {
                                            _saveSettings();
                                            Navigator.pop(context);
                                            _delayedLoadSettings();

                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        child: SCS(
                                          value: 0,
                                          unit: SCS_dv_3.isEmpty
                                              ? '˚C'
                                              : SCS_dv_3,
                                          trackColor: Colors.amber,
                                          progressBarColor: Colors.orange,
                                          min: 0,
                                          max: 100,
                                          trackWidth: 5,
                                          progressBarWidth: 20,
                                          bottomLabelText: SCS_title_3.isEmpty
                                              ? 'Temp 3'
                                              : SCS_title_3,
                                          editingControllerTitle:
                                              _editingSCS_title_3,
                                          editingControllerUnit:
                                              _editingSCS_dv_3,
                                          onPress: () {
                                            _saveSettings();
                                            Navigator.pop(context);
                                            _delayedLoadSettings();

                                          },
                                        ),
                                      ),
                                      Expanded(
                                        child: SCS(
                                          value: 0,
                                          unit:
                                              SCS_dv_4.isEmpty ? '%' : SCS_dv_4,
                                          trackColor: Colors.amber,
                                          progressBarColor: Colors.orange,
                                          min: 0,
                                          max: 100,
                                          trackWidth: 5,
                                          progressBarWidth: 20,
                                          bottomLabelText: SCS_title_4.isEmpty
                                              ? 'Humtidity 4'
                                              : SCS_title_4,
                                          editingControllerTitle:
                                              _editingSCS_title_4,
                                          editingControllerUnit:
                                              _editingSCS_dv_4,
                                          onPress: () {
                                            _saveSettings();
                                            Navigator.pop(context);
                                            setState(() {
                                              _delayedLoadSettings();
                                            });

                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            }
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            decoration: BoxDecoration(border: Border.all()),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text("Light & Switch 1"),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 20),
                                    child: Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        border: Border.all(),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(100)),
                                        color: _containerColor_1,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  ATSwitch(
                                    current: switch1,
                                    first: false,
                                    second: true,
                                    spacing: 50,
                                    onChanged: (valueSwitch) {
                                      setState(() {
                                        switch1 = valueSwitch;
                                        if (switch1) {
                                          _bluetoothService.sendMessage(
                                              _ControllerSwitch1_On);
                                          Fluttertoast.showToast(
                                              msg: _ControllerSwitch1_On);
                                          print(_ControllerSwitch1_On);
                                          _listenForESPResponseSwitch();
                                        } else {
                                          _bluetoothService.sendMessage(
                                              _ControllerSwitch1_Off);
                                          Fluttertoast.showToast(
                                              msg: _ControllerSwitch1_Off);
                                          print(_ControllerSwitch1_Off);
                                          _listenForESPResponseSwitch();
                                        }
                                      });
                                    },
                                    titleSwitchTrue: 'ON',
                                    titleSwitchFalse: 'OFF',
                                  )
                                ],
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(border: Border.all()),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text("Light & Switch 2"),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 20),
                                    child: Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        border: Border.all(),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(100)),
                                        color: _containerColor_2,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  ATSwitch(
                                    current: switch2,
                                    first: false,
                                    second: true,
                                    spacing: 50,
                                    onChanged: (valueSwitch) {
                                      setState(() {
                                        switch2 = valueSwitch;
                                        if (switch2) {
                                          _bluetoothService.sendMessage(
                                              _ControllerSwitch2_On);
                                          Fluttertoast.showToast(
                                              msg: _ControllerSwitch2_On);
                                          print(_ControllerSwitch1_On);
                                          _listenForESPResponseSwitch();
                                        } else {
                                          _bluetoothService.sendMessage(
                                              _ControllerSwitch2_Off);
                                          Fluttertoast.showToast(
                                              msg: _ControllerSwitch2_Off);
                                          print(_ControllerSwitch2_Off);
                                          _listenForESPResponseSwitch();
                                        }
                                      });
                                    },
                                    titleSwitchTrue: 'ON',
                                    titleSwitchFalse: 'OFF',
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                ),
    );
  }
}
