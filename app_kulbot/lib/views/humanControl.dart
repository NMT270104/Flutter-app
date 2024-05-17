import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class humanControl extends StatefulWidget {
  const humanControl({super.key});

  @override
  State<humanControl> createState() => _humanControlState();
}

class _humanControlState extends State<humanControl> {
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
