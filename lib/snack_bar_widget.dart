import 'package:flutter/material.dart';

void showSnackBar({required String message,required context}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      message,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w300,
      ),
    ),
    backgroundColor: Colors.blueAccent,
    elevation: 1.0,
    // This behavior will cause SnackBar to be shown above other widgets in the Scaffold
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(50.0),
    ),
  ));
}
