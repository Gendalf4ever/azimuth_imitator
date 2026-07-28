import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../components/colorManager.dart';

class CustomGraph extends StatelessWidget {
  final Map<String, List<FlSpot>> data;
  final DateTime startTimestamp;
  final DateTime endTimestamp;

  const CustomGraph({
    super.key,
    required this.data,
    required this.startTimestamp,
    required this.endTimestamp,
  });

  // Fixed palette for chart lines — kept distinct regardless of theme
  static const List<Color> _lineColors = [
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.red,
    Colors.teal,
    Colors.pink,
    Colors.indigo,
    Colors.amber,
    Colors.yellow,
  ];

  String _formatTs(double ms) {
    final dt = DateTime.fromMillisecondsSinceEpoch(ms.toInt());
    final now = DateTime.now();
    final isToday =
        dt.year == now.year && dt.month == now.month && dt.day == now.day;
    return isToday
        ? DateFormat('HH:mm:ss').format(dt)
        : '${DateFormat('HH:mm:ss').format(dt)}\n${DateFormat('dd/MM/yy').format(dt)}';
  }

  (double minY, double maxY) _yRange() {
    double minY = double.infinity;
    double maxY = double.negativeInfinity;
    for (final pts in data.values) {
      for (final p in pts) {
        if (p.y < minY) minY = p.y;
        if (p.y > maxY) maxY = p.y;
      }
    }
    if (!minY.isFinite || !maxY.isFinite) return (0.0, 1.0);
    if (minY >= 0) minY = 0;
    return (minY, maxY + (maxY - minY) * 0.05 + 0.01);
  }

  @override
  Widget build(BuildContext context) {
    final textColor = ColorManager.text;
    final borderColor = ColorManager.primary;

    final (minY, maxY) = _yRange();
    final startMs = startTimestamp.millisecondsSinceEpoch.toDouble();
    final endMs = endTimestamp.millisecondsSinceEpoch.toDouble();

    final bars = <LineChartBarData>[];
    final legend = <Widget>[];

    data.forEach((name, pts) {
      if (name.isEmpty || pts.isEmpty) return;
      final color = _lineColors[bars.length % _lineColors.length];
      bars.add(LineChartBarData(
        spots: pts,
        isCurved: false,
        color: color,
        barWidth: 2,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
      ));
      legend.add(Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 10, height: 10, color: color),
            const SizedBox(width: 4),
            Text(name, style: TextStyle(color: textColor, fontSize: 12)),
          ],
        ),
      ));
    });

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalMs = (endMs - startMs).abs();
        final labelCount = (constraints.maxWidth / 100).clamp(2.0, 20.0);
        final xInterval = totalMs > 0 ? totalMs / labelCount : 1.0;
        // ignore: deprecated_member_use
        final gridColor = textColor.withOpacity(0.15);

        return RepaintBoundary(
          child: Column(
            children: [
              Expanded(
                child: LineChart(
                  LineChartData(
                    clipData: const FlClipData.all(),
                    minX: startMs,
                    maxX: endMs,
                    minY: minY,
                    maxY: maxY,
                    lineBarsData: bars,
                    gridData: FlGridData(
                      show: true,
                      getDrawingHorizontalLine: (_) =>
                          FlLine(color: gridColor, strokeWidth: 1),
                      getDrawingVerticalLine: (_) =>
                          FlLine(color: gridColor, strokeWidth: 1),
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border.all(color: borderColor, width: 2),
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 52,
                          getTitlesWidget: (value, meta) {
                            if (value == maxY) return const SizedBox.shrink();
                            return Padding(
                              padding: const EdgeInsets.only(right: 6),
                              child: Text(
                                value.toStringAsFixed(1),
                                style: TextStyle(color: textColor, fontSize: 11),
                              ),
                            );
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 48,
                          interval: xInterval,
                          getTitlesWidget: (value, meta) {
                            if (value == startMs || value == endMs) {
                              return const SizedBox.shrink();
                            }
                            return Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                _formatTs(value),
                                style: TextStyle(color: textColor, fontSize: 10),
                                textAlign: TextAlign.center,
                              ),
                            );
                          },
                        ),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                  ),
                ),
              ),
              if (legend.isNotEmpty) ...[
                const SizedBox(height: 10),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 2,
                  runSpacing: 4,
                  children: legend,
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
