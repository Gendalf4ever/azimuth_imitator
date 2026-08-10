// ignore_for_file: file_names
import 'package:azimuth_imitator/diagram_widgets/CircuitBreakerIndicator.dart';
import 'package:azimuth_imitator/diagram_widgets/TransformerIndicator.dart';
import 'package:flutter/material.dart';
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
    ['5QG2', 180, 280, true],
    ['7QG1', 1370, 280, true],
    ['10Q4', 20, 450, true],
    ['2QT2', 125, 450, true],
    ['3Q1', 270, 450, true],
    ['4Q1', 470, 450, true],
    ['6QM', 580, 400, false],
    ['6QT7', 670, 450, true],
    ['8Q1', 1120, 450, true],
    ['10QT8', 1270, 450, true],
    ['9QT1', 1480, 450, true],
    ['1Q4', 1625, 450, true],
    ['QT2', 120, 850, true],
    ['QT1', 1470, 850, true],
    ['QM1', 550, 920, false],
    ['Q2', 170, 1220, true],
    ['Q1', 1370, 1220, true],
    ['QG', 1170, 1160, true],
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
              decoration: BoxDecoration(
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
                      width: (bus['width'] as num).toDouble() * s,
                      height: (bus['height'] as num).toDouble() * s,
                      decoration: BoxDecoration(
                        color: ColorManager.secondaryBackground,
                        border: Border.all(
                          color: ColorManager.primary,
                          width: 1 * s,
                        ),
                        borderRadius: BorderRadius.circular(4 * s),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(top: 5 * s, left: 15 * s),
                        child: Text(
                          bus['title'],
                          style: TextStyle(
                            fontSize: 20 * s,
                            color: ColorManager.text,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  )),

                  // scheme lines
                  Positioned.fill(
                    child: IgnorePointer(
                      child: CustomPaint(
                        size: Size(1780 * s, 1324 * s),
                        painter: SecondDiagramPainter(scale: s),
                      ),
                    ),
                  ),

                  _buildGDG('ГДГ 2', 350 * s, 250 * s),
                  _buildGDG('ГДГ 1', 1200 * s, 250 * s),
                  _buildGDG('АСДГ ', 1155 * s, 1050 * s),

                  ..._boxes.map((box) => Positioned(
                    top: (box[2] as num).toDouble() * s,
                    left: (box[1] as num).toDouble() * s,
                    child: CBIndicator(
                      width: 60 * s,
                      height: 60 * s,
                      isConnected: true, 
                      isVertical: box[3] as bool, 
                      stateColor: ColorManager.primary,
                      label: box[0],
                      labelPosition: CBLabelPosition.below, 
                    ),
                  )),

                  Positioned(
                    top: 620 * s,
                    left: 670 * s,
                    child: TransformerIndicator(
                      width: 60 * s,
                      height: 120 * s,
                      ringNumber: 2,
                      stateColor: ColorManager.primary,
                      label: 'T7',
                      labelPosition: TransformerLabelPosition.below,
                    ),
                  ),
                  Positioned(
                    top: 620 * s,
                    left: 1270 * s,
                    child: TransformerIndicator(
                      width: 60 * s,
                      height: 120 * s,
                      ringNumber: 2,
                      stateColor: ColorManager.primary,
                      label: 'T8',
                      labelPosition: TransformerLabelPosition.below,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGDG(String number, double left, double top) {
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
                number,
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
}