// import 'dart:convert';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_blockly/flutter_blockly.dart';

// import '../data/contentPrograming.dart';

// class Programingscreen extends StatefulWidget {
//   const Programingscreen({super.key});

//   @override
//   State<Programingscreen> createState() => _ProgramingscreenState();
// }

// class _ProgramingscreenState extends State<Programingscreen> {

//     final BlocklyOptions workspaceConfiguration =
//         BlocklyOptions.fromJson(const {
//       'grid': {
//         'spacing': 20,
//         'length': 3,
//         'colour': '#ccc',
//         'snap': true,
//       },
//       'toolbox': initialToolboxJson,
//       // null safety example
//       'collapse': null,
//       'comments': null,
//       'css': null,
//       'disable': null,
//       'horizontalLayout': null,
//       'maxBlocks': null,
//       'maxInstances': null,
//       'media': null,
//       'modalInputs': null,
//       'move': null,
//       'oneBasedIndex': null,
//       'readOnly': null,
//       'renderer': null,
//       'rendererOverrides': null,
//       'rtl': null,
//       'scrollbars': null,
//       'sounds': null,
//       'theme': null,
//       'toolboxPosition': null,
//       'trashcan': null,
//       'maxTrashcanContents': null,
//       'plugins': null,
//       'zoom': null,
//       'parentWorkspace': null,
//     });

//     void onInject(BlocklyData data) {
//       debugPrint('onInject: ${data.xml}\n${jsonEncode(data.json)}');
//     }

//     void onChange(BlocklyData data) {
//       debugPrint(
//           'onChange: ${data.xml}\n${jsonEncode(data.json)}\n${data.dart}');
//     }

//     void onDispose(BlocklyData data) {
//       debugPrint('onDispose: ${data.xml}\n${jsonEncode(data.json)}');
//     }

//     void onError(dynamic err) {
//       debugPrint('onError: $err');
//     }

//     @override
//     Widget build(BuildContext context) {
//       return Scaffold(
//         body: SafeArea(
//           child: BlocklyEditorWidget(
//             workspaceConfiguration: workspaceConfiguration,
//             initial: initialJson,
//             onInject: onInject,
//             onChange: onChange,
//             onDispose: onDispose,
//             onError: onError,
//             style: '.wrapper-web {top:58px;}',
//           ),
//         ),
//         appBar: AppBar(
//           title: const Text('Programing'),
//         ),
//         floatingActionButton: FloatingActionButton(
//           onPressed: () {},
//           tooltip: 'Increment',
//           child: const Icon(Icons.add),
//         ),
//         bottomNavigationBar: const SizedBox(height: 50),
//       );
//     }
//   }
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

class Programingscreen extends StatefulWidget {
  const Programingscreen({super.key});

  @override
  State<Programingscreen> createState() => _ProgramingscreenState();
}

class _ProgramingscreenState extends State<Programingscreen> {

  late WebViewControllerPlus _controlerWebview;

  @override

  void initState() {
    _controlerWebview = WebViewControllerPlus()
      ..loadFlutterAssetServer('assets/blockly/index.html')
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (url) {
            _controlerWebview.getWebViewHeight().then((value) {
              var height = int.parse(value.toString()).toDouble();
              if (height != _height) {
                if (kDebugMode) {
                  print("Height is: $value");
                }
                setState(() {
                  _height = height;
                });
              }
            });
          },
        ),
      );
    super.initState();
  }

  double _height = 1.0;

  @override
  void dispose() {
    _controlerWebview.server.close();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        backgroundColor: Colors.amber,
        leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: Colors.white, size:18, ), 
        onPressed: () {
          Navigator.pop(context); // This will navigate back to the previous screen
        },
      ),
      ),
      body: WebViewWidget(controller: _controlerWebview,)
    );
  }
}

