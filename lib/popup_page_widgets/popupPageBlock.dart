import 'package:flutter/material.dart';
import '../components/colorManager.dart';

class PopupPageBlock extends StatefulWidget {
  final String? title;
  final Color? color;
  final List<Widget> widgetStack;
  final double titleFontSize;

  const PopupPageBlock({
    super.key,
    this.title,
    this.color,
    required this.widgetStack,
    this.titleFontSize = 20,
  });

  @override
  State<PopupPageBlock> createState() => _PopupPageBlockState();
}

class _PopupPageBlockState extends State<PopupPageBlock> {
  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? ColorManager.secondaryBackground;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: color,
        //border: Border.all(color: widget.color),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.title != null)
            Text(
              widget.title ?? '',
              style: TextStyle(
                fontSize: widget.titleFontSize,
                fontWeight: FontWeight.w600,
                color: ColorManager.text,
                letterSpacing: 0.4,
              ),
            ),
          if (widget.title != null) const SizedBox(height: 10),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: widget.widgetStack,
          ),
        ],
      ),
    );
  }
}
