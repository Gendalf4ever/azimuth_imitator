import 'dart:async';
import 'package:flutter/material.dart';
import '../components/colorManager.dart';
import '../dataProvider.dart';

class CustomSizableGraph extends StatefulWidget {
  final List<String> sensorNames;
  final List<String>? buttonLabels;
  final String title;
  final double? minVal;
  final double? maxVal;
  final double? width;
  final double height;
  final Duration period;
  final List<Color>? palette;

  const CustomSizableGraph({
    super.key,
    required this.sensorNames,
    this.buttonLabels,
    this.title = "Мощность ГДГ (%)",
    this.minVal,
    this.maxVal,
    this.width,
    this.height = 300.0,
    this.period = const Duration(minutes: 1),
    this.palette,
  }) : assert(
          buttonLabels == null || buttonLabels.length == sensorNames.length,
          'buttonLabels должен содержать столько же элементов, сколько и sensorNames',
        );

  @override
  State<CustomSizableGraph> createState() => _CustomGraphState();
}

class _CustomGraphState extends State<CustomSizableGraph> {
  final Map<String, List<double>> _historyData = {};
  final Set<String> _manuallyHiddenSensors = {};
  late Timer _timer;

  final List<Color> _defaultPalette = [
    const Color(0xFF0D47A1),
    const Color(0xFF1976D2),
    const Color(0xFF03A9F4),
    const Color(0xFF00E5FF),
    const Color(0xFF00B0FF),
    const Color(0xFF29B6F6),
    const Color(0xFF4FC3F7),
    const Color(0xFF81D4FA),
  ];

  @override
  void initState() {
    super.initState();

    for (final name in widget.sensorNames) {
      _historyData[name] = [];
    }
    _collectData();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _collectData();
    });
  }

  double _getSensorValue(String sensorName) {
    final dynamic rawValue = DataProvider.getSensorValue(sensorName);

    if (rawValue is num && rawValue != -1) {
      return rawValue.toDouble();
    }
    return 0.0;
  }

  void _collectData() {
    final int maxPoints = widget.period.inSeconds > 0 ? widget.period.inSeconds : 60;

    setState(() {
      for (final sensorName in widget.sensorNames) {
        final list = _historyData.putIfAbsent(sensorName, () => []);

        if (list.length >= maxPoints) {
          list.removeAt(0);
        }

        final newValue = _getSensorValue(sensorName);
        list.add(newValue);
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ColorManager.activeTheme == 'dark';
    final colors = widget.palette ?? _defaultPalette;

    Widget graphContent = Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF11161B) : Colors.grey[50]!,
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(
          color: isDark ? ColorManager.primary : Colors.grey[300]!,
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(
                    color: ColorManager.text,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    alignment: WrapAlignment.end,
                    children: List.generate(widget.sensorNames.length, (index) {
                      final sensorKey = widget.sensorNames[index];
                      final buttonText = widget.buttonLabels != null
                          ? widget.buttonLabels![index]
                          : sensorKey;

                      final isVisible = !_manuallyHiddenSensors.contains(sensorKey);
                      final baseColor = colors[index % colors.length];

                      return Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              if (isVisible) {
                                _manuallyHiddenSensors.add(sensorKey);
                              } else {
                                _manuallyHiddenSensors.remove(sensorKey);
                              }
                            });
                          },
                          borderRadius: BorderRadius.circular(4),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: isVisible ? baseColor : Colors.transparent,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: baseColor, width: 1.5),
                            ),
                            child: Text(
                              buttonText,
                              style: TextStyle(
                                color: isVisible
                                    ? Colors.white
                                    : (isDark ? ColorManager.text : ColorManager.primary),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: CustomPaint(
                size: Size.infinite,
                painter: GraphPainter(
                  historyData: _historyData,
                  sensorNames: widget.sensorNames,
                  hiddenSensors: _manuallyHiddenSensors,
                  palette: colors,
                  period: widget.period,
                  userMinVal: widget.minVal,
                  userMaxVal: widget.maxVal,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: graphContent,
    );
  }
}

class GraphPainter extends CustomPainter {
  final Map<String, List<double>> historyData;
  final List<String> sensorNames;
  final Set<String> hiddenSensors;
  final List<Color> palette;
  final Duration period;
  final double? userMinVal;
  final double? userMaxVal;

  GraphPainter({
    required this.historyData,
    required this.sensorNames,
    required this.hiddenSensors,
    required this.palette,
    required this.period,
    this.userMinVal,
    this.userMaxVal,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    double effectiveMin = userMinVal ?? 0.0;
    double effectiveMax = userMaxVal ?? 150.0;
    double currentDataMax = double.negativeInfinity;
    double currentDataMin = double.infinity;
    bool hasData = false;

    for (var key in sensorNames) {
      if (hiddenSensors.contains(key)) continue;
      final points = historyData[key];
      if (points != null && points.isNotEmpty) {
        for (var p in points) {
          if (p > currentDataMax) currentDataMax = p;
          if (p < currentDataMin) currentDataMin = p;
          hasData = true;
        }
      }
    }

    if (hasData) {
      if (currentDataMax > effectiveMax) {
        effectiveMax = currentDataMax * 1.1;
      }
      if (currentDataMin < effectiveMin) {
        effectiveMin = currentDataMin < 0 ? currentDataMin * 1.1 : currentDataMin * 0.9;
      }
    }

    if (effectiveMax <= effectiveMin) {
      effectiveMax = effectiveMin + 1.0;
    }

    final double labelWidth = 45.0;
    final double graphWidth = size.width - labelWidth;
    final double graphHeight = size.height;

    final textPaint = TextPainter(textDirection: TextDirection.ltr);
    final gridPaint = Paint()
      ..color = ColorManager.text
      ..strokeWidth = 1.0;

    final int tickCount = 5;
    final double stepVal = (effectiveMax - effectiveMin) / tickCount;

    for (int i = 0; i <= tickCount; i++) {
      final double tickVal = effectiveMin + (stepVal * i);
      final double yPos = graphHeight - ((tickVal - effectiveMin) / (effectiveMax - effectiveMin) * graphHeight);

      final String labelText = tickVal % 1 == 0 ? tickVal.toInt().toString() : tickVal.toStringAsFixed(1);

      textPaint.text = TextSpan(
        text: labelText,
        style: TextStyle(
          color: ColorManager.text,
          fontSize: 11,
        ),
      );
      textPaint.layout();
      textPaint.paint(canvas, Offset(0, yPos - textPaint.height / 2));

      canvas.drawLine(
        Offset(labelWidth, yPos),
        Offset(size.width, yPos),
        gridPaint,
      );
    }

    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    final int totalPoints = period.inSeconds > 0 ? period.inSeconds : 60;
    final double xStep = graphWidth / (totalPoints > 1 ? totalPoints - 1 : 1);

    for (int index = 0; index < sensorNames.length; index++) {
      final currentKey = sensorNames[index];
      if (hiddenSensors.contains(currentKey)) continue;

      final points = historyData[currentKey];
      if (points == null || points.isEmpty) continue;

      linePaint.color = palette[index % palette.length];
      final Path path = Path();

      final double xOffset = labelWidth + (totalPoints - points.length) * xStep;

      for (int i = 0; i < points.length; i++) {
        final double x = xOffset + (i * xStep);
        final double clampedVal = points[i].clamp(effectiveMin, effectiveMax);
        final double y = graphHeight - ((clampedVal - effectiveMin) / (effectiveMax - effectiveMin) * graphHeight);

        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      canvas.drawPath(path, linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}