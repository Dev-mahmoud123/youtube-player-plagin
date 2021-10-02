import 'package:flutter/material.dart';

import 'home_screen.dart';
import 'item_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Youtube video player',
      home:  ItemScreen(),
    );
  }
}
