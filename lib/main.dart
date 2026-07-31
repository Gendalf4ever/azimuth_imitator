import 'package:azimuth_imitator/pages/mainScreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Azimuth Imitator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const Mainscreen(),
    );
  }
}