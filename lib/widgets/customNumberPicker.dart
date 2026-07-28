import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../components/colorManager.dart';

class CustomNumberPicker extends StatefulWidget {
  final double width;
  final double height;
  final int initialValue;
  final int min;
  final int max;
  final int step;
  final ValueChanged<int> onChanged;
  final Color? color;
  final Color? backgroundColor;
  final bool isBlocked;

  const CustomNumberPicker({
    super.key,
    this.width = 160,
    this.height = 40,
    this.initialValue = 0,
    this.min = 0,
    this.max = 99,
    this.step = 1,
    required this.onChanged,
    this.color,
    this.backgroundColor,
    this.isBlocked = false,
  });

  @override
  State<CustomNumberPicker> createState() => _CustomNumberPickerState();
}

class _CustomNumberPickerState extends State<CustomNumberPicker> {
  late int _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue.clamp(widget.min, widget.max);
  }

  void _decrement() {
    if (widget.isBlocked) return;
    final next = (_value - widget.step).clamp(widget.min, widget.max);
    if (next != _value) {
      setState(() => _value = next);
      widget.onChanged(_value);
    }
  }

  void _increment() {
    if (widget.isBlocked) return;
    final next = (_value + widget.step).clamp(widget.min, widget.max);
    if (next != _value) {
      setState(() => _value = next);
      widget.onChanged(_value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? ColorManager.primary;
    final backgroundColor =
        widget.backgroundColor ?? ColorManager.widgetBackground;
    final fontSize = widget.height * 0.34;
    final buttonSize = widget.height * 0.6;

    return Opacity(
      opacity: widget.isBlocked ? 0.4 : 1.0,
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(widget.height / 2),
          border: Border.all(color: color, width: 1.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _PickerButton(
              icon: Icons.remove,
              size: buttonSize,
              color: ColorManager.text,
              height: widget.height,
              onTap: _decrement,
            ),
            Text(
              '$_value',
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w500,
                color: ColorManager.text,
                height: 1,
              ),
            ),
            _PickerButton(
              icon: Icons.add,
              size: buttonSize,
              color: ColorManager.text,
              height: widget.height,
              onTap: _increment,
            ),
          ],
        ),
      ),
    );
  }
}

class _PickerButton extends StatefulWidget {
  final IconData icon;
  final double size;
  final double height;
  final Color color;
  final VoidCallback onTap;

  const _PickerButton({
    required this.icon,
    required this.size,
    required this.height,
    required this.color,
    required this.onTap,
  });

  @override
  State<_PickerButton> createState() => _PickerButtonState();
}

class _PickerButtonState extends State<_PickerButton> {
  Timer? _timer;

  void _onTapDown(TapDownDetails _) {
    widget.onTap();
    // after 400ms initial hold, start accelerating repeats
    _timer = Timer(const Duration(milliseconds: 400), () {
      _scheduleRepeat(const Duration(milliseconds: 200));
    });
  }

  void _scheduleRepeat(Duration interval) {
    widget.onTap();
    final next = Duration(milliseconds: max(40, interval.inMilliseconds - 25));
    _timer = Timer(next, () => _scheduleRepeat(next));
  }

  void _stop() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: (_) => _stop(),
      onTapCancel: _stop,
      child: Container(
        width: widget.height,
        height: widget.height,
        alignment: Alignment.center,
        child: Icon(widget.icon, size: widget.size, color: widget.color),
      ),
    );
  }
}
