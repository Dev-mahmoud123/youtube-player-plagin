import 'package:flutter/material.dart';

Widget text(String title , String value){
  return RichText(
    text: TextSpan(
      text: title,
      style: const TextStyle(
        color: Colors.blueAccent,
        fontWeight: FontWeight.bold,
      ),
      children: [
        TextSpan(
          text: value,
        style: const TextStyle(
          color: Colors.blueAccent,
          fontWeight: FontWeight.w300,
        )
        )
      ]
    ),
  );
}