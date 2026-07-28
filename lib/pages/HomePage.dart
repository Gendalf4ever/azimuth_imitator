import 'dart:async';
import 'package:flutter/material.dart';
import '../dataProvider.dart';
import '../components/colorManager.dart';
import '../widgets/customNumberPicker.dart';
import '../widgets/customButton.dart';
import '../widgets/customGDGindicator.dart';
import '../widgets/customSizableGraph.dart';
import '../popup_Pages/popupDatePicker.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  late StreamSubscription<Map<String, dynamic>> _subscription;
  late DateTime _pickerBegin;
  late DateTime _pickerEnd;

  @override
  void initState() {
    super.initState();
    _subscription = DataProvider.stream.listen((data) {
      setState(() {});
    });
    final now = DateTime.now();
    _pickerEnd = now;
    _pickerBegin = now.subtract(const Duration(hours: 24));
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: ColorManager.primaryBackground,
      body: Stack(
        children: [
          /*CustomPaint(
            size: const Size(screenWidth, screenHeight),
            painter: MyMainDiagramPainter(),
          ),*/
          Column(
            children: [
              CustomSizableGraph(sensorNames: ["1", "2"]),
              SizedBox(height: 20),
              CustomButton(
                label: 'change theme',
                onPressed: () {
                  setState(() {
                    if (ColorManager.activeTheme == 'dark') {
                      ColorManager.switchTheme('light');
                    } else {
                      ColorManager.switchTheme('dark');
                    }
                  });
                },
              ),
              SizedBox(height: 20),
              CustomGDGIndicator(gdgnum: 1, size: 250),
              SizedBox(height: 20),
              CustomButton(
                label: 'календарь',
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => PopupDatePicker(
                      initialBegin: _pickerBegin,
                      initialEnd: _pickerEnd,
                      onChanged: (range) => setState(() {
                        _pickerBegin = range.begin;
                        _pickerEnd = range.end;
                      }),
                    ),
                  );
                },
              ),
              CustomNumberPicker(
                initialValue: 1,
                min: 0,
                max: 1000,
                onChanged: (val) => print(val),
              ),
            ],
          ),
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
