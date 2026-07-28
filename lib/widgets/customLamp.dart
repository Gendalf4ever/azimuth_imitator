import 'package:flutter/material.dart';

class CustomLamp extends StatefulWidget {
  final int state;
  final Map<int, Color> stateColors;
  final Color fallbackColor;
  final double size;

  const CustomLamp({
    super.key,
    required this.state,
    required this.stateColors,
    this.fallbackColor =
        Colors.grey, // color if there are no valid states provided
    this.size = 30,
  });

  @override
  State<CustomLamp> createState() => _LampWidgetState();
}

class _LampWidgetState extends State<CustomLamp> {
  @override
  Widget build(BuildContext context) {
    final Color activeColor =
        widget.stateColors[widget.state] ?? widget.fallbackColor;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: activeColor,
        border: Border.all(color: Colors.white, width: widget.size * 0.03),
        gradient: RadialGradient(
          center: const Alignment(-0.3, -0.3),
          radius: 0.85,
          colors: [
            Color.lerp(activeColor, Colors.white, 0.55)!,
            activeColor,
            Color.lerp(activeColor, Colors.black, 0.35)!,
          ],
          stops: const [0.0, 0.55, 1.0],
        ),
      ),
    );
  }
}
