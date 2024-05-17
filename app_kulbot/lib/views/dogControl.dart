import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class dogControl extends StatefulWidget {
  const dogControl({super.key});

  @override
  State<dogControl> createState() => _dogControlState();
}

class _dogControlState extends State<dogControl> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Settings"),
      ),
      body: 
      Center(
      child: Container(
          padding: EdgeInsets.only(left: 50),
          child: Text('Comming Soon', style: TextStyle(fontSize: 50))),
    )
    );
    
  }
}
