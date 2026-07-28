import 'package:flutter/material.dart';
import '../components/colorManager.dart';

class RectIndicator extends StatefulWidget {
  final double width;
  final double height;
  final Color stateColor;
  final Color? backgroundColor;
  final String? label;
  final Widget? extraWidget;
  final Widget? dialog;

  const RectIndicator({
    super.key,
    this.width = 80,
    this.height = 120,
    required this.stateColor,
    this.backgroundColor,
    this.label,
    this.extraWidget,
    this.dialog,
  });

  @override
  State<RectIndicator> createState() => _RectIndicatorState();
}

class _RectIndicatorState extends State<RectIndicator> {
  void _openDialog(BuildContext context) {
    if (widget.dialog == null) return;
    showDialog(context: context, builder: (_) => widget.dialog!);
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor =
        widget.backgroundColor ?? ColorManager.widgetBackground;
    final label = widget.label ?? '';
    final borderWidth = widget.height * 0.03;
    final borderRadius = widget.height * 0.15;

    return GestureDetector(
      onTap: () => _openDialog(context),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          color: backgroundColor,
          border: Border.all(color: widget.stateColor, width: borderWidth),
        ),
        alignment: Alignment.center,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: widget.width * 0.1),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (label != '')
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: widget.height,
                      fontWeight: FontWeight.w600,
                      color: ColorManager.text,
                      letterSpacing: 0.1,
                    ),
                  ),
                if (widget.extraWidget != null) widget.extraWidget!,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
