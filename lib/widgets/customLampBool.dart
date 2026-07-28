import 'package:flutter/material.dart';
import '../components/colorManager.dart';

class CustomLampBool extends StatefulWidget {
  final bool isOn;
  final Color? colorOff;
  final Color? colorOn;
  final double size;

  const CustomLampBool({
    super.key,
    required this.isOn,
    this.colorOff,
    this.colorOn,
    this.size = 30,
  });

  @override
  State<CustomLampBool> createState() => _CustomLampBoolState();
}

class _CustomLampBoolState extends State<CustomLampBool> {
  @override
  Widget build(BuildContext context) {
    final colorOff = widget.colorOff ?? ColorManager.primaryBackground;
    final colorOn = widget.colorOn ?? ColorManager.primary;
    final Color activeColor = widget.isOn ? colorOn : colorOff;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: activeColor,
        border: Border.all(color: Colors.white, width: widget.size * 0.03),
        // Inner gradient for a glass/bulb effect
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
