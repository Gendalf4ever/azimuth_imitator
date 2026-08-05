import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../components/colorManager.dart';
import '../widgets/diagramPainter.dart';

class SchemePage extends StatefulWidget {
  const SchemePage({super.key});

  @override
  State<SchemePage> createState() => _SchemePageState();
}

class _SchemePageState extends State<SchemePage> {
  final double _scale = 0.7;
  final List<Map<String, dynamic>> _buses = [
    {'title': 'ГРЩ690', 'top': 370, 'left': 1, 'height': 200, 'width': 1770},
    {'title': 'ГРЩ400', 'top': 830, 'left': 17, 'height': 200, 'width': 1750},
    {'title': 'АРЩ400', 'top': 1150, 'left': 17, 'height': 150, 'width': 1750},
  ];
  final List<List<dynamic>> _boxes = [
    ['5QG2', 180, 280],
    ['7QG1', 1370, 280],
    ['10Q4', 25, 450],
    ['2QT2', 125, 450],
    ['3Q1', 270, 450],
    ['4Q1', 470, 450],
    ['6QM', 580, 410],
    ['6QT7', 670, 450],
    ['8Q1', 1120, 450],
    ['10QT8', 1270, 450],
    ['9QT1', 1480, 450],
    ['1Q4', 1625, 450],
  ];

  @override
  Widget build(BuildContext context) {
    final double s = _scale;
    return Scaffold(
      backgroundColor: ColorManager.primaryBackground,
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            child: Container(
              width: 1780 * s,
              height: 1324 * s,
              decoration:  BoxDecoration(
                color: ColorManager.primaryBackground,
                border: Border.all(
                  color: ColorManager.primary,
                  width: 1,
                ),
              ),
              child: Stack(
                children: [
                  ..._buses.map((bus) => Positioned(
                    top: (bus['top'] as num).toDouble() * s,
                    left: (bus['left'] as num).toDouble() * s,
                    child: Container(
                      padding: EdgeInsets.only(top: 5 * s, left: 25 * s),
                      child: Text(
                        bus['title'],
                        style: TextStyle(
                          fontSize: 26 * s,
                          color: ColorManager.text,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )),
                  //scheme lines
                  Positioned.fill(
                    child: IgnorePointer(
                      child: CustomPaint(
                        size: Size(1780 * s, 1324 * s),
                        painter: SecondDiagramPainter(scale: s),
                        ),
                      )
                    ),
                    _buildGDG('2', 350 * s, 250 * s),
                    _buildGDG('1', 1200 * s, 250 * s),

                    ..._boxes.map((box) => Positioned(
                      top: (box[2] as num).toDouble() * s,
                      left: (box[1] as num).toDouble() * s,
                      child: Container(
                        width: 60 * s,
                        height: 60 * s,
                        decoration: BoxDecoration(
                          color: ColorManager.primaryBackground,
                          border: Border.all(color: ColorManager.primary, width: 1.5 * s),
                          borderRadius: BorderRadius.circular(3 * s),
                        ),
                        child: Center(
                          child: Text(
                            box[0],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: ColorManager.text,
                              fontSize: 10 * s,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  _buildTransformer('T7', 670 * s, 620 * s),
                  _buildTransformer('T8', 1270 * s, 620 * s),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGDG(String number, double left, double top){
    final s = _scale;
    return Positioned(
      top: top,
      left: left,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 90 * s,
            height: 90 * s,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ColorManager.primaryBackground,
              border: Border.all(color: ColorManager.primary, width: 3.0 * s),
            ),
            child: Center(
              child: Text(
                'Г$number',
                style: TextStyle(
                  color: ColorManager.text,
                  fontSize: 16 * s,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildTransformer(String name, double left, double top){
    final s = _scale;
    return Positioned(
        top: top,
        left: left,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60 * s,
              height: 120 * s,
              decoration: BoxDecoration(
                color: ColorManager.primaryBackground,
                border: Border.all(color: ColorManager.primary, width: 2 * s),
              ),
              child: Center(
                child: Center(
                  child: Text(name, style: TextStyle(
                    color: ColorManager.text,
                    fontSize: 24 * s,
                    fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 5 * s),
            Text(
              name,
              style: TextStyle(
                color: ColorManager.text,
                fontSize: 12 * s,
              ),
            ),
          ],
        ),
    );
  }
}