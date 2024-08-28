import 'package:Kulbot/utils/AnimatedToggleSwitch.dart';
import 'package:Kulbot/utils/SleekCircularSlider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/iot_screen/settingIoTScreen.dart';
import '../service/bluetooth_service.dart';

class IotWidget extends StatefulWidget {
  final bool checkAvailability;
  const IotWidget({super.key, this.checkAvailability = true});

  @override
  State<IotWidget> createState() => _IotWidgetState();
}

class _IotWidgetState extends State<IotWidget> {

  final TextEditingController _editingControllerTemp = TextEditingController();

  final BluetoothService _bluetoothService = BluetoothService();
  bool get isConnected => (_bluetoothService.connection?.isConnected ?? false);
  
  bool switchLed = false;

void initState() {
    // TODO: implement initState
    super.initState();
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
    super.dispose();
  }

  void dialogtest() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Nhập Temp'),
        content: Column(
          children: [
            Text('nhap o day'),
            TextField(
              controller: _editingControllerTemp,
              decoration: InputDecoration(
                border: OutlineInputBorder()
              ),
              
            )
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              _saveSettings();
              Fluttertoast.showToast(msg: "Đã lưu");
              Navigator.pop(context);
            },
            child: Center(child: Text('OK')),
          ),
        ],
      ),
    );
  }


  Future<void> _saveSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('_editingControllerTemp', _editingControllerTemp.text);
  }

  Future<void> _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _editingControllerTemp.text = prefs.getString('_editingControllerTemp') ?? '';
    });
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('IOT',style: TextStyle(color: Colors.white),),
          centerTitle: true,
          toolbarHeight: 40,
          backgroundColor: Colors.amber,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 18,
            ),
            onPressed: () {
              Navigator.pop(
                  context); // This will navigate back to the previous screen
            },
          ),

          actions: [
            
            Padding(
              padding: const EdgeInsets.only(right: 20),
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
            
          ],
        ),
        body: SingleChildScrollView(
            child: Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              SCS(
                value: 50,
                unit: '˚C',
                //colorText: Colors.amber,
                trackColor: Colors.amber,
                progressBarColor: Colors.orange,
                min: 0,
                max: 100,
                trackWidth: 5,
                progressBarWidth: 20,
                bottomLabelText: 'Temp',
                onLongPress: () {
                  dialogtest();
                },
              ),
              SCS(
                value: 50,
                unit: '˚C',
                //colorText: Colors.amber,
                trackColor: Colors.amber,
                progressBarColor: Colors.orange,
                min: 0,
                max: 100,
                trackWidth: 5,
                progressBarWidth: 20,
                bottomLabelText: 'Temp',
                onLongPress: () {
                  
                },
              ),
              
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              SCS(
                value: 50,
                unit: '˚C',
                //colorText: Colors.amber,
                trackColor: Colors.amber,
                progressBarColor: Colors.orange,
                min: 0,
                max: 100,
                trackWidth: 5,
                progressBarWidth: 20,
                bottomLabelText: 'Temp',
                onLongPress: () {
                  
                },
              ),
              SCS(
                value: 50,
                unit: '˚C',
                //colorText: Colors.amber,
                trackColor: Colors.amber,
                progressBarColor: Colors.orange,
                min: 0,
                max: 100,
                trackWidth: 5,
                progressBarWidth: 20,
                bottomLabelText: 'Temp',
                onLongPress: () {
                  
                },
              ),
            ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                    children: [
                      Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                          color: Colors.blue,
                        ),
                      )),
                      SizedBox(height: 20,),
                  ATSwitch(
                    current: switchLed,
                    first: false,
                    second: true,
                    spacing: 50,
                    onChanged: (valueSwitch) =>
                        setState(() => switchLed = valueSwitch),
                    titleSwitchTrue: 'ON',
                    titleSwitchFalse: 'OFF',
                    iconSwitchTrue: Icon(Icons.lightbulb),
                    iconSwitchFalse: Icon(Icons.lightbulb_outline),
                  )
                    ],
                  ),
                  Column(
                children: [
                  Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                      color: Colors.blue,
                    ),
                  )),
                  SizedBox(height: 20,),                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
              ATSwitch(
                current: switchLed,
                first: false,
                second: true,
                spacing: 50,
                onChanged: (valueSwitch) =>
                    setState(() => switchLed = valueSwitch),
                titleSwitchTrue: 'ON',
                titleSwitchFalse: 'OFF',
                iconSwitchTrue: Icon(Icons.lightbulb),
                iconSwitchFalse: Icon(Icons.lightbulb_outline),
              )
                ],
              )
              ],
            )
          ],
        )));
  }
}
