import 'dart:math' as math;
import 'package:azimuth_imitator/components/colorManager.dart';
import 'package:flutter/material.dart';

class AzimuthWidget extends StatefulWidget {
  final double value;       // К какому углу летит ракета (после ПУСК)
  final double setPoint;    // Где стоит оранжевая стрелка (задается кнопками)
  final double size;
  final Color rocketColor;
  final String label;
  final ValueChanged<double>? onChanged;

  const AzimuthWidget({
    super.key,
    required this.value,
    this.setPoint = 0.0,
    this.size = 300.0,
    this.rocketColor = Colors.white,
    this.label = 'УГОЛ',
    this.onChanged,
  });

  @override
  State<AzimuthWidget> createState() => _AzimuthWidgetState();
}

class _AzimuthWidgetState extends State<AzimuthWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _lastAngle = 0;

  @override
  void initState() {
    super.initState();
    _lastAngle = widget.value;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _setupAnimation();
  }

  void _setupAnimation() {
    _animation = Tween<double>(begin: _lastAngle, end: widget.value).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic),
    )..addListener(() {
        if (mounted) setState(() {});
        widget.onChanged?.call(_animation.value);
      });
  }

  @override
  void didUpdateWidget(AzimuthWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Ракета начинает движение ТОЛЬКО если изменился параметр value (после ПУСК)
    if (oldWidget.value != widget.value) {
      _controller.reset();
      _setupAnimation();
      _controller.forward();
      _lastAngle = widget.value;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Ракета крутится за анимацией
    double rocketRotation = math.pi * (_animation.value - 180) / 180.0;
    // Оранжевая стрелка крутится за setPoint МГНОВЕННО (без анимации)
    double targetRotation = math.pi * (widget.setPoint - 180) / 180.0;

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: _StaticDialPainter(size: widget.size))),
          // Оранжевая стрелка (Задатчик)
          Positioned.fill(child: CustomPaint(painter: _TargetArrowPainter(rotationAngle: targetRotation, size: widget.size))),
          // Ракета (Исполнитель)
          Positioned.fill(child: CustomPaint(painter: _RotatingRocketPainter(rotationAngle: rocketRotation, color: widget.rocketColor, size: widget.size))),
          
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('${_animation.value.toInt()}°', style: TextStyle(color: Colors.white, fontSize: widget.size * 0.12, fontWeight: FontWeight.bold)),
                Text('${widget.setPoint.toInt()}°', style: TextStyle(color: Colors.orange, fontSize: widget.size * 0.07)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Рисование оранжевой стрелки
class _TargetArrowPainter extends CustomPainter {
  final double rotationAngle;
  final double size;
  _TargetArrowPainter({required this.rotationAngle, required this.size});
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotationAngle);
    final paint = Paint()..color = Colors.orange..style = PaintingStyle.fill;
    final path = Path()
      ..moveTo(0, -radius) 
      ..lineTo(-size.width * 0.035, -radius + size.width * 0.06)
      ..lineTo(size.width * 0.035, -radius + size.width * 0.06)
      ..close();
    canvas.drawPath(path, paint);
    canvas.restore();
  }
  @override bool shouldRepaint(_TargetArrowPainter old) => old.rotationAngle != rotationAngle;
}


class _StaticDialPainter extends CustomPainter {
  final double size;
  _StaticDialPainter({required this.size});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final stroke = size.width * 0.02;
    
    final paintGood = Paint()..color = Colors.green..style = PaintingStyle.stroke..strokeWidth = stroke;
    final paintBad = Paint()..color = Colors.red..style = PaintingStyle.stroke..strokeWidth = stroke;

    // Радиус самой шкалы (возвращаем ближе к краю)
    final arcRadius = radius - stroke * 2.5;
    canvas.drawArc(Rect.fromCircle(center: center, radius: arcRadius), -math.pi / 2, -math.pi, false, paintGood);
    canvas.drawArc(Rect.fromCircle(center: center, radius: arcRadius), -math.pi / 2, math.pi, false, paintBad);

    for (int i = 0; i < 360; i += 10) {
      final angle = (i - 270) * math.pi / 180;
      bool major = i % 30 == 0;
      double len = major ? size.width * 0.04 : size.width * 0.02;
      
      // Рисуем штрихи шкалы наружу
      canvas.drawLine(
        Offset(center.dx + arcRadius * math.cos(angle), center.dy + arcRadius * math.sin(angle)),
        Offset(center.dx + (arcRadius + len) * math.cos(angle), center.dy + (arcRadius + len) * math.sin(angle)),
        Paint()..color = Colors.white54..strokeWidth = 1.5,
      );

      // Рисуем цифровые подписи НАВЕРХУ (за пределами шкалы)
      if (major) {
        int displayDegree = i > 180 ? i - 360 : i;
        if (displayDegree == -180) displayDegree = 180;

        final textSpan = TextSpan(
          text: '$displayDegree',
          style: TextStyle(
            color: ColorManager.primary,
            fontSize: size.width * 0.038,
            fontWeight: FontWeight.w500,
          ),
        );
        
        final textPainter = TextPainter(
          text: textSpan,
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();

        double textRadius = arcRadius + size.width * 0.11;
        double x = center.dx + textRadius * math.cos(angle) - textPainter.width / 2;
        double y = center.dy + textRadius * math.sin(angle) - textPainter.height / 2;

        textPainter.paint(canvas, Offset(x, y));
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}
class _RotatingRocketPainter extends CustomPainter {
  final double rotationAngle;
  final Color color;
  final double size;
  _RotatingRocketPainter({required this.rotationAngle, required this.color, required this.size});
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotationAngle);
    canvas.translate(-center.dx, -center.dy);
    final p = Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = 2.5;
    final rW = size.width * 0.08;
    final rH = size.height * 0.3;
    final path = Path()
      ..moveTo(center.dx, center.dy - rH / 2)
      ..quadraticBezierTo(center.dx + rW, center.dy, center.dx, center.dy + rH / 2)
      ..quadraticBezierTo(center.dx - rW, center.dy, center.dx, center.dy - rH / 2);
    canvas.drawPath(path, p);
    canvas.restore();
  }
  @override bool shouldRepaint(_RotatingRocketPainter old) => old.rotationAngle != rotationAngle;
}