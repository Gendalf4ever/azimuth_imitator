// ignore_for_file: file_names
import 'package:azimuth_imitator/customProgressBar.dart';
import 'package:azimuth_imitator/diagram_widgets/CircleIndicator.dart';
import 'package:azimuth_imitator/diagram_widgets/CircuitBreakerIndicator.dart';
import 'package:azimuth_imitator/diagram_widgets/RectIndicator.dart';
import 'package:azimuth_imitator/diagram_widgets/TransformerIndicator.dart';
import 'package:azimuth_imitator/popup_page_widgets/popupPageBlock.dart';
import 'package:azimuth_imitator/widgets/customButton.dart';
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

  final List<Map<String, dynamic>> _transformers = [
    {
     'label': 'TV7',
     'left': 670,
     'top': 620,
     'width': 60,
     'height': 120,
     'ringNumber': 2,
    },
    {
     'label': 'TV8',
     'left': 1270,
     'top': 620,
     'width': 60,
     'height': 120,
     'ringNumber': 2,
    },
   {
    'label': 'TV2',
    'left': 270,
    'top': 620,
    'width': 60,
    'height': 120,
    'ringNumber': 2,
    },
    {
    'label': 'TV1',
    'left': 1470,
    'top': 620,
    'width': 60,
    'height': 120,
    'ringNumber': 2,
    },
  ];

  late final List<Map<String, dynamic>> _rectIndicators = [
    {
      'label': 'ТРАЛ',
      'left': 10,
      'top': 600,
      'width': 90,
      'height': 70,
    },
    {
      'label': 'ВРК ЛБ',
      'left': 450,
      'top': 600,
      'width': 110,
      'height': 90,
      'dialog': _buildVrkDialog('ВРК ЛБ'),
    },
    {
      'label': 'ВРК ПБ',
      'left': 1100,
      'top': 600,
      'width': 110,
      'height': 90,
      'dialog': _buildVrkDialog('ВРК ПБ'),
    },
    {
      'label': 'ТРАЛ',
      'left': 1600,
      'top': 600,
      'width': 90,
      'height': 70,
    },
  ];

  late final List<Map<String, dynamic>> _circleIndicators = [
    {
      'label': 'ГДГ 2',
      'left': 350,
      'top': 250,
      'size': 90,
      'dialog': null, 
    },
    {
      'label': 'ГДГ 1',
      'left': 1200,
      'top': 250,
      'size': 90,
      'dialog': null,
    },
    {
      'label': 'АСДГ',
      'left': 1155,
      'top': 1050,
      'size': 90,
      'dialog': null,
    },
  ];

  Widget _buildVrkDialog(String title) {
    return AlertDialog(
      backgroundColor: ColorManager.primaryBackground,
      title: Text(
        title,
        style: TextStyle(
          color: ColorManager.text,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SizedBox(
        width: 950,
        height: 750,
        child: SingleChildScrollView(
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              SizedBox(
                width: 300,
                child: PopupPageBlock(
                  title: 'Вход',
                  widgetStack: const [
                    CustomProgressBar(minValue: 0, maxValue: 700, currentValue: 400, title: 'Напряжение', units: 'В'),
                    SizedBox(height: 8),
                    CustomProgressBar(minValue: 0, maxValue: 500, currentValue: 120, title: 'Ток', units: 'А'),
                    SizedBox(height: 8),
                    CustomProgressBar(minValue: 0, maxValue: 60, currentValue: 50, title: 'Частота', units: 'Гц'),
                  ],
                ),
              ),
              SizedBox(
                width: 300,
                child: PopupPageBlock(
                  title: 'ЗПТ',
                  widgetStack: const [
                    CustomProgressBar(minValue: 0, maxValue: 1000, currentValue: 540, title: 'Напряжение', units: 'В'),
                  ],
                ),
              ),
              SizedBox(
                width: 300,
                child: PopupPageBlock(
                  title: 'Выход',
                  widgetStack: const [
                    CustomProgressBar(minValue: 0, maxValue: 400, currentValue: 380, title: 'Напряжение', units: 'В'),
                    SizedBox(height: 8),
                    CustomProgressBar(minValue: 0, maxValue: 500, currentValue: 150, title: 'Ток', units: 'А'),
                    SizedBox(height: 8),
                    CustomProgressBar(minValue: 0, maxValue: 1000, currentValue: 500, title: 'Огр. мощности', units: 'кВт'),
                    SizedBox(height: 8),
                    CustomProgressBar(minValue: 0, maxValue: 1000, currentValue: 550, title: 'Полная мощность', units: 'кВА'),
                  ],
                ),
              ),
              SizedBox(
                width: 300,
                child: PopupPageBlock(
                  title: 'ГЭУ',
                  widgetStack: const [
                    CustomProgressBar(minValue: 0, maxValue: 5000, currentValue: 1200, title: 'Момент на валу', units: 'Н·м'),
                    SizedBox(height: 8),
                    CustomProgressBar(minValue: 0, maxValue: 3000, currentValue: 1500, title: 'Задан. скорость', units: 'об/мин'),
                    SizedBox(height: 8),
                    CustomProgressBar(minValue: 0, maxValue: 3000, currentValue: 1490, title: 'Факт. скорость', units: 'об/мин'),
                    SizedBox(height: 8),
                    CustomProgressBar(minValue: 0, maxValue: 1000, currentValue: 400, title: 'Задан. мощность', units: 'кВт'),
                    SizedBox(height: 8),
                    CustomProgressBar(minValue: 0, maxValue: 1000, currentValue: 395, title: 'Факт. мощность', units: 'кВт'),
                  ],
                ),
              ),
              SizedBox(
                width: 300,
                child: PopupPageBlock(
                  title: 'Температура ПЧ',
                  widgetStack: const [
                    CustomProgressBar(minValue: 0, maxValue: 100, currentValue: 45, title: 'ФАЗА U', units: '°C'),
                    SizedBox(height: 8),
                    CustomProgressBar(minValue: 0, maxValue: 100, currentValue: 47, title: 'ФАЗА V', units: '°C'),
                    SizedBox(height: 8),
                    CustomProgressBar(minValue: 0, maxValue: 100, currentValue: 46, title: 'ФАЗА W', units: '°C'),
                  ],
                ),
              ),
              SizedBox(
                width: 300,
                child: PopupPageBlock(
                  title: 'Температура ГЭД',
                  widgetStack: [
                    const CustomProgressBar(minValue: 0, maxValue: 150, currentValue: 65, title: 'ФАЗА U', units: '°C'),
                    const SizedBox(height: 8),
                    const CustomProgressBar(minValue: 0, maxValue: 150, currentValue: 68, title: 'ФАЗА V', units: '°C'),
                    const SizedBox(height: 8),
                    const CustomProgressBar(minValue: 0, maxValue: 150, currentValue: 66, title: 'ФАЗА W', units: '°C'),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Система охлаждения:',
                            style: TextStyle(
                              color: ColorManager.text,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Неисправность',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        CustomButton(
          onPressed: () => Navigator.of(context).pop(),
          label: 'Закрыть',
        ),
      ],
    );
  }

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

                  Positioned.fill(
                    child: IgnorePointer(
                      child: CustomPaint(
                        size: Size(1780 * s, 1324 * s),
                        painter: SecondDiagramPainter(scale: s),
                      ),
                    ),
                  ),

                  ..._circleIndicators.map((item) => Positioned(
                    top: (item['top'] as num).toDouble() * s,
                    left: (item['left'] as num).toDouble() * s,
                    child: CircleIndicator(
                      size: (item['size'] as num).toDouble() * s,
                      stateColor: ColorManager.primary,
                      backgroundColor: ColorManager.primaryBackground,
                      label: item['label'],
                      dialog: item['dialog'],
                    ),
                  )),

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

                  ..._transformers.map((tr) => Positioned(
                    top: (tr['top'] as num).toDouble() * s,
                    left: (tr['left'] as num).toDouble() * s,
                    child: TransformerIndicator(
                      width: (tr['width'] as num).toDouble() * s,
                      height: (tr['height'] as num).toDouble() * s,
                      ringNumber: tr['ringNumber'],
                      stateColor: ColorManager.primary,
                      label: tr['label'],
                      labelPosition: TransformerLabelPosition.below,
                    ),
                  )),

                  ..._rectIndicators.map((item) => Positioned(
                    top: (item['top'] as num).toDouble() * s,
                    left: (item['left'] as num).toDouble() * s,
                    child: RectIndicator(
                      width: (item['width'] as num).toDouble() * s,
                      height: (item['height'] as num).toDouble() * s,
                      stateColor: ColorManager.primary,
                      label: item['label'],
                      dialog: item['dialog'], 
                    ),
                  )),
                ],  
              ),
            ),
          ),
        ),
      ),
    );
  }
}