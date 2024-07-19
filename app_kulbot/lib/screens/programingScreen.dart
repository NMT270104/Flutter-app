import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blockly/flutter_blockly.dart';

import '../data/contentPrograming.dart';

class Programingscreen extends StatefulWidget {
  const Programingscreen({super.key});

  @override
  State<Programingscreen> createState() => _ProgramingscreenState();
}

class _ProgramingscreenState extends State<Programingscreen> {

    final BlocklyOptions workspaceConfiguration =
        BlocklyOptions.fromJson(const {
      'grid': {
        'spacing': 20,
        'length': 3,
        'colour': '#ccc',
        'snap': true,
      },
      'toolbox': initialToolboxJson,
      // null safety example
      'collapse': null,
      'comments': null,
      'css': null,
      'disable': null,
      'horizontalLayout': null,
      'maxBlocks': null,
      'maxInstances': null,
      'media': null,
      'modalInputs': null,
      'move': null,
      'oneBasedIndex': null,
      'readOnly': null,
      'renderer': null,
      'rendererOverrides': null,
      'rtl': null,
      'scrollbars': null,
      'sounds': null,
      'theme': null,
      'toolboxPosition': null,
      'trashcan': null,
      'maxTrashcanContents': null,
      'plugins': null,
      'zoom': null,
      'parentWorkspace': null,
    });

    void onInject(BlocklyData data) {
      debugPrint('onInject: ${data.xml}\n${jsonEncode(data.json)}');
    }

    void onChange(BlocklyData data) {
      debugPrint(
          'onChange: ${data.xml}\n${jsonEncode(data.json)}\n${data.dart}');
    }

    void onDispose(BlocklyData data) {
      debugPrint('onDispose: ${data.xml}\n${jsonEncode(data.json)}');
    }

    void onError(dynamic err) {
      debugPrint('onError: $err');
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: SafeArea(
          child: BlocklyEditorWidget(
            workspaceConfiguration: workspaceConfiguration,
            initial: initialJson,
            onInject: onInject,
            onChange: onChange,
            onDispose: onDispose,
            onError: onError,
            style: '.wrapper-web {top:58px;}',
          ),
        ),
        appBar: AppBar(
          title: const Text('Programing'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
        bottomNavigationBar: const SizedBox(height: 50),
      );
    }
  }