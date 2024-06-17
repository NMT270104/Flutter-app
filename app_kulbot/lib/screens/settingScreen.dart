import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class settingScreen extends StatefulWidget {
  const settingScreen({super.key});

  @override
  State<settingScreen> createState() => _settingScreenState();
}

class _settingScreenState extends State<settingScreen> {
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
