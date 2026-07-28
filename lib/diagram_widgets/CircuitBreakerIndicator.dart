import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../components/colorManager.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum CBLabelPosition { above, below, left, right }

class CBIndicator extends StatefulWidget {
  final double width;
  final double height;
  final bool isConnected;
  final bool isVertical;
  final Color stateColor;
  final Color? backgroundColor;
  final String? label;
  final CBLabelPosition labelPosition;
  final Widget? dialog;

  const CBIndicator({
    super.key,
    this.width = 60,
    this.height = 60,
    this.isVertical = false,
    required this.stateColor,
    required this.isConnected,
    this.backgroundColor,
    this.label,
    this.labelPosition = CBLabelPosition.below,
    this.dialog,
  });

  @override
  State<CBIndicator> createState() => _CBIndicatorState();
}

class _CBIndicatorState extends State<CBIndicator> {
  void _openDialog(BuildContext context) {
    if (widget.dialog == null) return;
    showDialog(context: context, builder: (_) => widget.dialog!);
  }

  Widget _buildCore(Color backgroundColor) {
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
            child: _CBPictureWidget(
              color: widget.stateColor,
              isConnected: widget.isConnected,
              rot: widget.isVertical,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel() {
    final fontSize = math.min(widget.width, widget.height) * 0.35;

    return Text(
      widget.label!,
      style: TextStyle(
        fontSize: fontSize,
        color: ColorManager.text,
        fontWeight: FontWeight.w500,
      ),
      textAlign: TextAlign.center,
      overflow: TextOverflow.ellipsis,
    );
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor =
        widget.backgroundColor ?? ColorManager.widgetBackground;
    final hasLabel = widget.label != null && widget.label!.isNotEmpty;
    final core = _buildCore(backgroundColor);

    if (!hasLabel) return core;

    final label = _buildLabel();
    final gap = math.min(widget.width, widget.height) * 0.1;

    switch (widget.labelPosition) {
      case CBLabelPosition.above:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            label,
            SizedBox(height: gap),
            core,
          ],
        );
      case CBLabelPosition.below:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            core,
            SizedBox(height: gap),
            label,
          ],
        );
      case CBLabelPosition.left:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            label,
            SizedBox(width: gap),
            core,
          ],
        );
      case CBLabelPosition.right:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            core,
            SizedBox(width: gap),
            label,
          ],
        );
    }
  }
}

Widget _CBPictureWidget({
  required Color color,
  required bool isConnected,
  required bool rot,
}) {
  Widget imageWidget;

  if (isConnected) {
    imageWidget = SvgPicture.asset(
      'lib/imgs/CBConnected.svg',
      colorFilter: ColorFilter.mode(color, BlendMode.modulate),
    );
  } else {
    imageWidget = SvgPicture.asset(
      'lib/imgs/CBDisconnected.svg',
      colorFilter: ColorFilter.mode(color, BlendMode.modulate),
    );
  }

  return Transform.rotate(
    angle: rot ? 90 * (math.pi / 180) : 0,
    child: imageWidget,
  );
}
