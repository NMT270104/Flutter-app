import 'package:TEST/screens/homeScreen.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter/material.dart';

void main() {
  
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: const Kulbot(),
  ));
}

class Kulbot extends StatelessWidget {
  const Kulbot({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kulbot',
      home: HomeScreen(),
      theme: ThemeData(
        useMaterial3: true,
      ),
    );
  }
}
