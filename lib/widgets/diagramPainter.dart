import 'package:azimuth_imitator/components/colorManager.dart';
import 'package:flutter/material.dart';

class SecondDiagramPainter extends CustomPainter {
  final double scale;
  
  SecondDiagramPainter({required this.scale});
  
  @override
  void paint(Canvas canvas, Size size) {
    final Paint linePaint = Paint()
      ..color = ColorManager.primary
      ..strokeWidth = 2 * scale;
    
    double s(double value) => value * scale;
    
    // Основные горизонтальные линии
    // ГРЩ690
    canvas.drawLine(
      Offset(s(50), s(430)), 
      Offset(s(1650), s(430)), 
      linePaint,
    );
    
    // ГРЩ400
    canvas.drawLine(
      Offset(s(150), s(950)), 
      Offset(s(1500), s(950)),
      linePaint,
    );
    
    // АРЩ400
    canvas.drawLine(
      Offset(s(200), s(1250)), 
      Offset(s(1400), s(1250)),
      linePaint,
    );
    
    // Вертикальные соединительные линии
    
    // Линия ГДГ2 (левый)
    canvas.drawLine(
      Offset(s(200), s(430)), 
      Offset(s(200), s(300)), 
      linePaint,
    );
    canvas.drawLine(
      Offset(s(200), s(300)), 
      Offset(s(350), s(300)), 
      linePaint,
    );

    // Линия ГДГ1 (правый)
    canvas.drawLine(
      Offset(s(1400), s(430)),
      Offset(s(1400), s(300)), 
      linePaint,
    );
    canvas.drawLine(
      Offset(s(1400), s(300)), 
      Offset(s(1250), s(300)), 
      linePaint,
    );
    
    // Нижние полосы ГРЩ690
    // 1
    canvas.drawLine(
      Offset(s(50), s(430)), 
      Offset(s(50), s(620)), 
      linePaint,
    );
    // 2 
    canvas.drawLine(
      Offset(s(150), s(430)), 
      Offset(s(150), s(950)),
      linePaint,
    );
    // 3 
    canvas.drawLine(
      Offset(s(300), s(430)), 
      Offset(s(300), s(650)),
      linePaint,
    );
    // 4 
    canvas.drawLine(
      Offset(s(500), s(430)),
      Offset(s(500), s(600)),
      linePaint,
    );
    // 5 
    canvas.drawLine(
      Offset(s(700), s(430)),
      Offset(s(700), s(950)),
      linePaint,
    );
    // 6 
    canvas.drawLine(
      Offset(s(1150), s(430)),
      Offset(s(1150), s(600)),
      linePaint,
    );
    // 7 
    canvas.drawLine(
      Offset(s(1300), s(430)),
      Offset(s(1300), s(650)),
      linePaint,
    );
    // 8 
    canvas.drawLine(
      Offset(s(1500), s(430)),
      Offset(s(1500), s(950)),
      linePaint,
    );
    // 9
    canvas.drawLine(
      Offset(s(1650), s(430)),
      Offset(s(1650), s(620)),
      linePaint,
    );
    
    // Нижние линии ГРЩ400
    canvas.drawLine(
      Offset(s(200), s(1250)),
      Offset(s(200), s(950)),
      linePaint,
    );
    canvas.drawLine(
      Offset(s(1400), s(1250)),
      Offset(s(1400), s(950)),
      linePaint,
    );
    
    // Верхняя линия ГРЩ400
    canvas.drawLine(
      Offset(s(1250), s(830)),
      Offset(s(1250), s(950)),
      linePaint,
    );
    
    // Верхние линии АРЩ400
    canvas.drawLine(
      Offset(s(1200), s(1250)),
      Offset(s(1200), s(1100)),
      linePaint,
    );
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}