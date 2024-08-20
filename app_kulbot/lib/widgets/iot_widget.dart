import 'package:flutter/material.dart';

class IotWidget extends StatefulWidget {
  const IotWidget({super.key});

  @override
  State<IotWidget> createState() => _IotWidgetState();
}

class _IotWidgetState extends State<IotWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text('IOT Widget'),
        ])));
  }
}
