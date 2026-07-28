import 'package:flutter/material.dart';
import '../components/colorManager.dart';


enum CircleExtraWidgetPosition { above, below, left, right }

class CircleIndicator extends StatefulWidget {
  final double size;
  final Color stateColor;
  final Color? backgroundColor;
  final String? label;
  final Widget? extraWidget;
  final CircleExtraWidgetPosition extraWidgetPosition;
  final Widget? dialog;

  const CircleIndicator({
    super.key,
    this.size = 80,
    required this.stateColor,
    this.backgroundColor,
    this.extraWidget,
    this.extraWidgetPosition = CircleExtraWidgetPosition.below,
    required this.label,
    this.dialog,
  });

  @override
  State<CircleIndicator> createState() => _CircleIndicatorState();
}

class _CircleIndicatorState extends State<CircleIndicator> {
  void _openDialog(BuildContext context) {
    if (widget.dialog == null) return;
    showDialog(context: context, builder: (_) => widget.dialog!);
  }

  Widget _buildCore(Color backgroundColor) {
    return GestureDetector(
      onTap: () => _openDialog(context),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: backgroundColor,
          border: Border.all(
            color: widget.stateColor,
            width: widget.size * 0.03,
          ),
        ),
        alignment: Alignment.center,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: widget.size * 0.15),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              widget.label ?? '',
              style: TextStyle(
                fontSize: widget.size,
                fontWeight: FontWeight.w600,
                color: ColorManager.text,
                letterSpacing: 0.1,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExtraWidget() => widget.extraWidget!;

  @override
  Widget build(BuildContext context) {
    final backgroundColor =
        widget.backgroundColor ?? ColorManager.widgetBackground;
    final core = _buildCore(backgroundColor);

    if (widget.extraWidget == null) return core;

    final extra = _buildExtraWidget();
    final gap = widget.size * 0.1;

    switch (widget.extraWidgetPosition) {
      case CircleExtraWidgetPosition.above:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [extra, SizedBox(height: gap), core],
        );
      case CircleExtraWidgetPosition.below:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [core, SizedBox(height: gap), extra],
        );
      case CircleExtraWidgetPosition.left:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [extra, SizedBox(width: gap), core],
        );
      case CircleExtraWidgetPosition.right:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [core, SizedBox(width: gap), extra],
        );
    }
  }
}