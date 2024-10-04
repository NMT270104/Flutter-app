import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ButtonHomeScreen extends StatelessWidget {
  final imgPath;
  final textButton;
  final VoidCallback navigator;

  ButtonHomeScreen({
    super.key,
    required this.imgPath,
    required this.textButton,
    required this.navigator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: navigator,
          child: Padding(
            padding: EdgeInsets.only(top: 20),
            child: Container(
              width: MediaQuery.of(context).size.width*40/100,
              height: MediaQuery.of(context).size.height*60/100,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: Colors.grey.shade400,
                  //     blurRadius: 20,
                  //     spreadRadius: 10,
                  //   )
                  // ]
                  ),
              child: Center(
                child: Image.asset(imgPath),
              ),
            ),
          ),
        ),
        SizedBox(height: 12),
        Text(textButton,
            style: TextStyle(
              fontSize: 30,
            ))
      ],
    );
  }
}
