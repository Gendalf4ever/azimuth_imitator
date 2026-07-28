import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../components/colorManager.dart';
import '../dataProvider.dart';
import '../popup_Pages/gdgPopupPage.dart';

/// Круглый индикатор генератора (ГДГ).
///
/// Две узкие кольцевые шкалы с разрывом снизу:
///  • внешняя (синяя) — активная мощность (power_active / power_active_max) с красным
///    сегментом ограничения мощности (ОМ, current_power_limit): при ОМ = 100 %
///    красного нет, при ОМ < 100 % конец дуги [ОМ..100 %] окрашивается в красный;
///  • внутренняя (белая) — реактивная мощность
///    (power_reactive / power_reactive_max), без ОМ.
///
/// В центре — активная (кВт) и реактивная (кВАр) мощность.
/// По углам — приоритет, частота, коэффициент мощности.
class CustomGDGIndicator extends StatefulWidget {
  final int gdgnum;
  final double size;
  final Color? borderColor;

  const CustomGDGIndicator({
    super.key,
    required this.gdgnum,
    this.size = 320,
    this.borderColor,
  });

  @override
  State<CustomGDGIndicator> createState() => _CustomGDGIndicatorState();
}

class _CustomGDGIndicatorState extends State<CustomGDGIndicator> {
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

  Color borderColorPicker() {
    if (DataProvider.getInt("GDG_${widget.gdgnum}_state") == 3) {
      return Colors.red; // ХАРДКОД-ЦВЕТ — подключить к ColorManager
    }
    if (DataProvider.getInt("GDG_${widget.gdgnum}_current_power_limit") ==
        100) {
      return ColorManager.primary;
    } else {
      return Colors.yellow; // ХАРДКОД-ЦВЕТ — подключить к ColorManager
    }
  }

  // ── Хелперы форматирования ──────────────────────────────────────────────────
  // Число без лишнего «.0».
  String _num(double v) =>
      v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(1);

  // Коэффициент мощности в русском формате: 0,00.
  String _pf(double v) => v.toStringAsFixed(2).replaceAll('.', ',');

  @override
  Widget build(BuildContext context) {
    final size = widget.size;
    final inset = size * 0.045;

    final blue = ColorManager.primary;
    final reactive = ColorManager.text; // реактивная дуга (белая, как «кВАр»)
    final track = ColorManager.text.withValues(alpha: 0.22);
    final unit = ColorManager.text.withValues(alpha: 0.55);

    // Активная загрузка, % = power_active / power_active_max (без ОМ на дуге).
    final activeMax = DataProvider.getDouble(
      "GDG_${widget.gdgnum}_power_active_max",
    );
    final loadPct = activeMax > 0
        ? (DataProvider.getDouble("GDG_${widget.gdgnum}_power_active") /
                  activeMax *
                  100)
              .clamp(0, 100)
              .toDouble()
        : 0.0;
    // Реактивная, % = power_reactive / power_reactive_max (без ОМ).
    final reactiveMax = DataProvider.getDouble(
      "GDG_${widget.gdgnum}_power_reactive_max",
    );
    final reactivePct = reactiveMax > 0
        ? (DataProvider.getDouble("GDG_${widget.gdgnum}_power_reactive") /
                  reactiveMax *
                  100)
              .clamp(0, 100)
              .toDouble()
        : 0.0;
    final omPct = DataProvider.getDouble(
      "GDG_${widget.gdgnum}_current_power_limit",
    ).clamp(0, 100).toDouble();

    return GestureDetector(
      onTap: () => _openPopup(context),
      child: Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: ColorManager.primaryBackground,
        border: Border.all(
          color: widget.borderColor ?? borderColorPicker(),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(size * 0.03),
      ),
      child: Stack(
        children: [
          // ── Кольцевая шкала + красный хвост ОМ ─────────────────────────────
          Positioned.fill(
            child: CustomPaint(
              painter: _GDGRingPainter(
                loadPct: loadPct,
                omPct: omPct,
                reactivePct: reactivePct,
                band: blue,
                reactiveBand: reactive,
                track: track,
                redZone: Colors.red, // ХАРДКОД-ЦВЕТ — подключить к ColorManager
              ),
            ),
          ),

          // ── Центр: активная (кВт) и реактивная (кВАр) мощность ─────────────
          Align(
            alignment: const Alignment(0, -0.14),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'кВт',
                  style: TextStyle(color: unit, fontSize: size * 0.06),
                ),
                Text(
                  _num(
                    DataProvider.getDouble("GDG_${widget.gdgnum}_power_active"),
                  ),
                  style: TextStyle(
                    color: blue,
                    fontSize: size * 0.15,
                    fontWeight: FontWeight.bold,
                    height: 1.05,
                  ),
                ),
                Text(
                  _num(
                    DataProvider.getDouble(
                      "GDG_${widget.gdgnum}_power_reactive",
                    ),
                  ),
                  style: TextStyle(
                    color: ColorManager.text,
                    fontSize: size * 0.145,
                    fontWeight: FontWeight.bold,
                    height: 1.05,
                  ),
                ),
                Text(
                  'кВАр',
                  style: TextStyle(color: unit, fontSize: size * 0.06),
                ),
              ],
            ),
          ),

          // ── Заголовок и приоритет (верх-лево) ──────────────────────────────
          Positioned(
            top: inset * 0.8,
            left: inset,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ГДГ${widget.gdgnum}',
                  style: TextStyle(
                    color: ColorManager.text,
                    fontWeight: FontWeight.bold,
                    fontSize: size * 0.075,
                    height: 1.0,
                  ),
                ),
              ],
            ),
          ),

          // ── Заданный ОМ (верх-право) ───────────────────────────────────────
          Positioned(
            top: inset * 0.8,
            right: inset,
            child: Text(
              '${DataProvider.getInt("GDG_${widget.gdgnum}_priority")}',
              style: TextStyle(
                color: ColorManager.text,
                fontWeight: FontWeight.w600,
                fontSize: size * 0.06,
              ),
            ),
          ),

          // ── Частота (низ-лево) ─────────────────────────────────────────────
          Positioned(
            bottom: inset,
            left: inset,
            child: Text(
              '${_num(DataProvider.getDouble("GDG_${widget.gdgnum}_freq"))} Гц',
              style: TextStyle(
                color: ColorManager.text,
                fontWeight: FontWeight.w600,
                fontSize: size * 0.06,
              ),
            ),
          ),

          // ── Коэффициент мощности (низ-право) ───────────────────────────────
          Positioned(
            bottom: inset,
            right: inset,
            child: Text(
              'pf: ${_pf(DataProvider.getDouble("GDG_${widget.gdgnum}_PF"))}',
              style: TextStyle(
                color: ColorManager.text,
                fontWeight: FontWeight.w600,
                fontSize: size * 0.055,
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }

  void _openPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => GdgPopupPage(gdgnum: widget.gdgnum),
    );
  }
}

/// Отрисовка двух узких кольцевых шкал с разрывом снизу.
class _GDGRingPainter extends CustomPainter {
  final double loadPct; // 0..100 — активная мощность (внешняя дуга)
  final double omPct; // 0..100 — ограничение мощности (красный сегмент)
  final double reactivePct; // 0..100 — реактивная мощность (внутренняя дуга)
  final Color band; // цвет активной дуги
  final Color reactiveBand; // цвет реактивной дуги
  final Color track; // цвет незаполненной дуги
  final Color redZone; // цвет красного сегмента ОМ

  _GDGRingPainter({
    required this.loadPct,
    required this.omPct,
    required this.reactivePct,
    required this.band,
    required this.reactiveBand,
    required this.track,
    required this.redZone,
  });

  // Кольцо с разрывом снизу: старт в нижней-левой точке, размах 270°.
  // Углы Flutter: 0° — 3 часа, положительное направление — по часовой (y вниз).
  static const double _startDeg = 135; // нижняя-левая точка (значение 0 %)
  static const double _sweepDeg =
      270; // до нижней-правой точки (значение 100 %)
  static const double _deg = math.pi / 180;

  // Угол начала для значения [pct] (в радианах).
  double _a(double pct) => (_startDeg + pct / 100 * _sweepDeg) * _deg;

  // Размах дуги от pct0 до pct1 (в радианах).
  double _span(double pct0, double pct1) =>
      (pct1 - pct0) / 100 * _sweepDeg * _deg;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final base = math.min(size.width, size.height) / 2 * 0.80;
    final strokeW = base * 0.075; // узкие дуги
    final gap = strokeW * 0.7; // зазор между кольцами
    final rOuter = base; // активная (кВт) + ОМ
    final rInner = base - strokeW - gap; // реактивная (кВАр)

    // Внешнее кольцо — активная мощность с красным сегментом ОМ.
    _drawRing(canvas, center, rOuter, strokeW, loadPct, band, omPct);
    // Внутреннее кольцо — реактивная мощность, без ОМ.
    _drawRing(canvas, center, rInner, strokeW, reactivePct, reactiveBand, null);
  }

  // Одно кольцо: серый трек, цветная дуга заполнения и (опц.) красный ОМ.
  void _drawRing(
    Canvas canvas,
    Offset center,
    double radius,
    double strokeW,
    double fillPct,
    Color fillColor,
    double? om,
  ) {
    final rect = Rect.fromCircle(center: center, radius: radius);
    Paint p(Color c) => Paint()
      ..color = c
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeW
      ..strokeCap = StrokeCap.round;

    // Трек (0..100 %).
    canvas.drawArc(rect, _a(0), _span(0, 100), false, p(track));
    // Заполнение (0..fill).
    if (fillPct > 0) {
      canvas.drawArc(rect, _a(0), _span(0, fillPct), false, p(fillColor));
    }
    // Красный сегмент ОМ [ОМ..100] у конца дуги (только если задан).
    if (om != null && om < 100) {
      canvas.drawArc(rect, _a(om), _span(om, 100), false, p(redZone));
    }
  }

  @override
  bool shouldRepaint(covariant _GDGRingPainter old) =>
      old.loadPct != loadPct ||
      old.omPct != omPct ||
      old.reactivePct != reactivePct ||
      old.band != band ||
      old.reactiveBand != reactiveBand ||
      old.track != track ||
      old.redZone != redZone;
}
