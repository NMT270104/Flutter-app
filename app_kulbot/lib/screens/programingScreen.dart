import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blockly_plus/flutter_blockly_plus.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

import 'package:fluttertoast/fluttertoast.dart';

import '../data/contentPrograming.dart';
import '../service/bluetooth_service.dart';

class Programingscreen extends StatefulWidget {
    final bool checkAvailability;
  const Programingscreen({super.key, this.checkAvailability = true});

  @override
  State<Programingscreen> createState() => _ProgramingscreenState();
}

class _ProgramingscreenState extends State<Programingscreen> {

  final BluetoothService _bluetoothService = BluetoothService();
  bool get isConnected => (_bluetoothService.connection?.isConnected ?? false);
  String connectedDeviceName = "...";

  String _generatedCode = '';
  bool _isExpanded = false;

  final BlocklyOptions workspaceConfiguration =
      BlocklyOptions.fromJson(const {
    'grid': {
      'spacing': 12,
      'length': 30,
      'colour': '#b6b6b6',
      'snap': true,
    },
    'toolbox': initialToolboxJson,

    'theme': {
    'blockStyles': {
      'loop_blocks': BlocklyBlockStyle(
        colourPrimary: '#FFAB19', // Màu chính của khối
        colourSecondary: '#FF8000', // Màu phụ
        colourTertiary: '#CC6600', hat: '', // Màu thứ ba
      ),
      '/': BlocklyBlockStyle(
        colourPrimary: '#4C97FF',
        colourSecondary: '#3373CC',
        colourTertiary: '#2A64B3', hat: '',
      ),
      'math_blocks': BlocklyBlockStyle(
        colourPrimary: '#59C059',
        colourSecondary: '#46A546',
        colourTertiary: '#389438', hat: '',
      ),
      // Tiếp tục định nghĩa các khối khác
    },
    'startHats': true,  // Hiển thị nắp ở đầu khối sự kiện (giống Scratch)
  },
    // null safety example
      'collapse': null,
      'comments': true,
      'css': null,
      'disable': null,
      'horizontalLayout': null,
      'maxBlocks': 200,
      'maxInstances': null,
      'media': null,
      'modalInputs': null,
      'move': null,
      'oneBasedIndex': null,
      'readOnly': null,
      'renderer': 'zelos',
      'rendererOverrides': null,
      'rtl': null,
      'scrollbars': {
        'horizontal': false, 
        'vertical': false  
      },
      'sounds': true,
      'toolboxPosition': null,
      'trashcan': true,
      'maxTrashcanContents': null,
      'plugins': null,
      'zoom': {
        'controls': false,
        'wheel': false,
        'startScale': 0.6,
        'maxScale': 1.0,
        'minScale': 0.1,
        'scaleSpeed': 0.5
      },
      'parentWorkspace': null,
      
  });

  void onInject(BlocklyData data) {
    print('Injected: ${data.xml}');
  }

  void onChange(BlocklyData data) {
    setState(() {
      _generatedCode = data.js!;
    });
    print('Changed: ${data.xml}');
  }

  void onDispose(BlocklyData data) {
    print('Disposed: ${data.xml}');
  }

  void onError(dynamic err) {
    print('onError: $err');
  }

  Future<List<String>> loadAddons() async {
    List<String> addons = [];
    try {
      addons.add(await rootBundle.loadString('assets/scratch/blocks/events_generators.js'));
      addons.add(await rootBundle.loadString('assets/scratch/blocks/control.js'));
      addons.add(await rootBundle.loadString('assets/scratch/blocks/display.js'));
      addons.add(await rootBundle.loadString('assets/scratch/blocks/motions.js'));
      addons.add(await rootBundle.loadString('assets/scratch/blocks/led.js'));
      addons.add(await rootBundle.loadString('assets/scratch/blocks/sensor.js'));
      //Fluttertoast.showToast(msg: "Loaded addons successfully");
      print('Loaded addons successfully');
      //addons.add(await rootBundle.loadString('assets/scratch/blocks/motor.js'));
    } catch (e) {
      print("Error loading addons: $e");
    }
    return addons;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
    _bluetoothService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: FutureBuilder(
          future: loadAddons(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return BlocklyEditorWidget(
                workspaceConfiguration: workspaceConfiguration,
                initial: initialJson,
                onInject: onInject,
                onChange: onChange,
                onDispose: onDispose,
                onError: onError,
                addons: snapshot.data
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
            ),
        AnimatedContainer(
            duration: Duration(milliseconds: 300),
            width: _isExpanded ? 180 : 0,
            height: _isExpanded ? 335 : 0,
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.white,
            ),
             child: SingleChildScrollView(
              child: Text(
                _generatedCode,
                style: const TextStyle(fontSize: 14, fontFamily: 'Monospace'),
              ),
            ),
          ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('Programing'),
        toolbarHeight: 40,
        actions: [
          Padding(padding: EdgeInsets.only(right: 10),
          child: IconButton(
            icon: Icon(Icons.copy),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: _generatedCode));
            Fluttertoast.showToast(msg: 'Đã sao chép vào clipboard!');
            },
          ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () {
                Fluttertoast.showToast(msg: _generatedCode);
                String jsonData = jsonEncode(_generatedCode);
                _bluetoothService.sendMessage(jsonData);
              },
              icon: Icon(Icons.play_arrow),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10),
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
                  _bluetoothService.connectBluetoothDialog(context); 
                },
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: Container(
              child: IconButton(
                icon: Icon(Icons.open_in_full),
                onPressed: () {
                  setState(() {
                    _isExpanded = !_isExpanded; // Thay đổi trạng thái
                  });
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
