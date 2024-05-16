import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final imgPath;
  final textButton;
  final navigator;

  const Button({super.key, this.imgPath, this.textButton, this.navigator});

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
            width: 100,
            height: 100,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade400,
                    blurRadius: 20,
                    spreadRadius: 10,
                  )
                ]),
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
