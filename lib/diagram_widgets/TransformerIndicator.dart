import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../components/colorManager.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum TransformerLabelPosition { above, below, left, right }

class TransformerIndicator extends StatefulWidget {
  final double width;
  final double height;
  final int ringNumber;
  final Color stateColor;
  final Color? backgroundColor;
  final String? label;
  final TransformerLabelPosition labelPosition;
  final Widget? dialog;

  const TransformerIndicator({
    super.key,
    this.width = 80,
    this.height = 120,
    required this.ringNumber,
    required this.stateColor,
    this.backgroundColor,
    this.label,
    this.labelPosition = TransformerLabelPosition.below,
    this.dialog,
  });

  @override
  State<TransformerIndicator> createState() => _TransformerIndicatorState();
}

class _TransformerIndicatorState extends State<TransformerIndicator> {
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
            child: _TransformerPictureWidget(
              color: widget.stateColor,
              ringNum: widget.ringNumber,
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
      case TransformerLabelPosition.above:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            label,
            SizedBox(height: gap),
            core,
          ],
        );
      case TransformerLabelPosition.below:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            core,
            SizedBox(height: gap),
            label,
          ],
        );
      case TransformerLabelPosition.left:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            label,
            SizedBox(width: gap),
            core,
          ],
        );
      case TransformerLabelPosition.right:
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

Widget _TransformerPictureWidget({required Color color, required int ringNum}) {
  switch (ringNum) {
    case 2:
      return SvgPicture.asset(
        'lib/imgs/2circles.svg',
        colorFilter: ColorFilter.mode(color, BlendMode.modulate),
      );
    case 3:
      return SvgPicture.asset(
        'lib/imgs/3circles.svg',
        colorFilter: ColorFilter.mode(color, BlendMode.modulate),
      );
    case 4:
      return SvgPicture.asset(
        'lib/imgs/4circles.svg',
        colorFilter: ColorFilter.mode(color, BlendMode.modulate),
      );
    default:
      return Text(
        'missing picture',
        style: TextStyle(
          fontSize: 14,
          color: ColorManager.text,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
      );
  }
}
