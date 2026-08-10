// ignore_for_file: library_private_types_in_public_api

import 'dart:async';
import 'package:flutter/material.dart';
import '../dataProvider.dart';
import '../components/colorManager.dart';

class DiagramPage extends StatefulWidget {
  const DiagramPage({super.key});

  @override
  _DiagramPageState createState() => _DiagramPageState();
}

class _DiagramPageState extends State<DiagramPage> {
  late StreamSubscription<Map<String, dynamic>> _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = DataProvider.stream.listen((data) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.primaryBackground,
      body: Stack(
        children: [
          /*CustomPaint(
            size: const Size(screenWidth, screenHeight),
            painter: MyMainDiagramPainter(),
          ),*/
        ],
      ),
    );
  }
}

class MyMainDiagramPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint linePaint = Paint()
      ..color = ColorManager.primary
      ..strokeWidth = 5;

    /*
    EXAMPLE LINE
    
    canvas.drawLine(
      const Offset(70, 110),
      const Offset(1194, 110),
      linePaint,
    ); //main
    */
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
