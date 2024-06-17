import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ButtonHomeScreen extends StatelessWidget {
  final imgPath;
  final textButton;
  final navigator;

  const ButtonHomeScreen({super.key, this.imgPath, this.textButton, this.navigator});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => navigator));
          },
          child: Container(
            width: MediaQuery.of(context).size.width*0.2,
            height: MediaQuery.of(context).size.height*0.4,
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
        SizedBox(height: 12),
        Text(textButton,
            style: TextStyle(
              fontSize: 30,
            ))
      ],
    );
  }
}
