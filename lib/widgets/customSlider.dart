import 'package:flutter/material.dart';
import '../components/colorManager.dart';

class CustomSlider extends StatefulWidget {
  final double min;
  final double max;
  final double step;
  final double labelPeriod;
  final ValueChanged<double> onChanged;
  final Color? color;
  final Color? secondaryColor;
  final double width;
  final double height;
  final bool isBlocked;

  const CustomSlider({
    super.key,
    required this.min,
    required this.max,
    this.step = 1,
    this.labelPeriod = 1,
    required this.onChanged,
    this.color,
    this.secondaryColor,
    this.width = 280,
    this.height = 40,
    this.isBlocked = false,
  });

  @override
  State<CustomSlider> createState() => _CustomSliderState();
}

class _CustomSliderState extends State<CustomSlider> {
  late double _value;

  double get _fraction =>
      ((_value - widget.min) / (widget.max - widget.min)).clamp(0.0, 1.0);

  @override
  void initState() {
    super.initState();
    _value = widget.min;
  }

  void _onDrag(double localX, double inset, double innerWidth) {
    if (widget.isBlocked) return;
    final fraction = ((localX - inset) / innerWidth).clamp(0.0, 1.0);
    final raw = widget.min + fraction * (widget.max - widget.min);
    final stepped = (raw / widget.step).round() * widget.step;
    final clamped = stepped.clamp(widget.min, widget.max);
    if (clamped != _value) {
      setState(() => _value = clamped);
      widget.onChanged(_value);
    }
  }

  String _fmt(double v) =>
      v == v.roundToDouble() ? v.toInt().toString() : v.toStringAsFixed(1);

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? ColorManager.primary;
    final secondaryColor = widget.secondaryColor ?? ColorManager.primaryLight;
    final knobSize = widget.height * 0.8;
    final fontSize = widget.height * 0.34;
    final inset = knobSize / 2;

    return Opacity(
      opacity: widget.isBlocked ? 0.4 : 1.0,
      child: SizedBox(
        width: widget.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: widget.height + fontSize + 4,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final totalWidth = constraints.maxWidth;
                  final innerWidth = totalWidth - inset * 2;
                  final knobLeft = inset + _fraction * innerWidth;
                  final trackTop = fontSize + 4 + (widget.height - 2) / 2;
                  final knobTop = trackTop - knobSize / 2;

                  return GestureDetector(
                    onHorizontalDragUpdate: (d) =>
                        _onDrag(d.localPosition.dx, inset, innerWidth),
                    onTapDown: (d) =>
                        _onDrag(d.localPosition.dx, inset, innerWidth),
                    behavior: HitTestBehavior.opaque,
                    child: Stack(
                      children: [
                        // Value above knob
                        Positioned(
                          top: 0,
                          left: knobLeft,
                          child: FractionalTranslation(
                            translation: const Offset(-0.5, 0),
                            child: Text(
                              _fmt(_value),
                              style: TextStyle(
                                fontSize: fontSize,
                                fontWeight: FontWeight.w600,
                                color: ColorManager.text,
                              ),
                            ),
                          ),
                        ),
                        // Track background
                        Positioned(
                          top: trackTop,
                          left: inset,
                          right: inset,
                          child: Container(
                            height: 2,
                            decoration: BoxDecoration(
                              color: secondaryColor,
                              borderRadius: BorderRadius.circular(1),
                            ),
                          ),
                        ),
                        // Track fill
                        Positioned(
                          top: trackTop,
                          left: inset,
                          child: Container(
                            width: _fraction * innerWidth,
                            height: 2,
                            decoration: BoxDecoration(
                              color: secondaryColor,
                              borderRadius: BorderRadius.circular(1),
                            ),
                          ),
                        ),
                        // Knob
                        Positioned(
                          top: knobTop,
                          left: knobLeft,
                          child: FractionalTranslation(
                            translation: const Offset(-0.5, 0),
                            child: Container(
                              width: knobSize,
                              height: knobSize,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: color,
                                border: Border.all(
                                  color: secondaryColor,
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.2),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 4),

            // Period labels
            SizedBox(
              height: fontSize + 4,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final totalWidth = constraints.maxWidth;
                  final innerWidth = totalWidth - inset * 2;
                  final steps = ((widget.max - widget.min) / widget.labelPeriod)
                      .round();
                  return Stack(
                    children: List.generate(steps + 1, (i) {
                      final v = widget.min + i * widget.labelPeriod;
                      final frac = (v - widget.min) / (widget.max - widget.min);
                      return Positioned(
                        left: inset + frac * innerWidth,
                        child: FractionalTranslation(
                          translation: Offset(
                            frac == 0
                                ? 0
                                : frac == 1
                                ? -1
                                : -0.5,
                            0,
                          ),
                          child: Text(
                            _fmt(v),
                            style: TextStyle(
                              fontSize: fontSize,
                              fontWeight: FontWeight.w500,
                              color: ColorManager.text,
                            ),
                          ),
                        ),
                      );
                    }),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
