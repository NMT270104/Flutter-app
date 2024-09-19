import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blockly_plus/flutter_blockly_plus.dart';

import 'package:fluttertoast/fluttertoast.dart';

import '../data/contentPrograming.dart';

class Programingscreen extends StatefulWidget {
  const Programingscreen({super.key});

  @override
  State<Programingscreen> createState() => _ProgramingscreenState();
}

class _ProgramingscreenState extends State<Programingscreen> {
  String _generatedCode = '';


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
      'logic_blocks': BlocklyBlockStyle(
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
      addons.add(await rootBundle.loadString('assets/scratch/blocks/variables.js'));
      addons.add(await rootBundle.loadString('assets/scratch/blocks/led.js'));
      addons.add(await rootBundle.loadString('assets/scratch/blocks/sensor.js'));
      Fluttertoast.showToast(msg: "Loaded addons successfully");
      print('Loaded addons successfully');
      //addons.add(await rootBundle.loadString('assets/scratch/blocks/motor.js'));
    } catch (e) {
      print("Error loading addons: $e");
    }
    return addons;
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
            Container(
              width: 150,
              height: 330,
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
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: IconButton(
              onPressed: () {
                Fluttertoast.showToast(msg: _generatedCode);
              },
              icon: Icon(Icons.play_arrow),
            ),
          ),
        ],
      ),
    );
  }
}
