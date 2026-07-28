import 'package:flutter/material.dart';
import '../components/colorManager.dart';

class CustomTable extends StatelessWidget {
  final List<Map<String, String>> data;
  final List<String> columns; 
  final double rowHeight;
  final Color firstCellColor;
  final Color secondCellColor;

  CustomTable({
    super.key,
    required this.data,
    required this.columns,
    this.rowHeight = 35,
    Color? firstCellColor,
    Color? secondCellColor,
  })  : firstCellColor = firstCellColor ?? ColorManager.primaryDark,
        secondCellColor = secondCellColor ?? ColorManager.primaryLight;

  @override
  Widget build(BuildContext context) {
    final displayRowsCount = data.isEmpty ? 15 : data.length;

    return Table(
      columnWidths: Map.fromIterable(
        List.generate(columns.length, (i) => i),
        value: (_) => const FlexColumnWidth(1),
      ),
      border: TableBorder.all(color: ColorManager.primary, width: 1.0),
      children: [
        TableRow(
          decoration: BoxDecoration(color: ColorManager.primary),
          children: columns.map((colName) => Container(
            height: rowHeight,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Text(
              colName,
              style: TextStyle(
                color: Colors.white, 
                fontSize: 14, 
                fontWeight: FontWeight.bold
              ),
              overflow: TextOverflow.ellipsis,
            ),
          )).toList(),
        ),
  
        ...List.generate(displayRowsCount, (index) {
          final rowColor = index % 2 == 0 ? firstCellColor : secondCellColor;
          final item = data.isNotEmpty ? data[index] : null;

          return TableRow(
            decoration: BoxDecoration(color: rowColor),
            children: columns.map((key) {
              final cellText = item != null ? (item[key] ?? '') : '';
              return _buildCell(cellText);
            }).toList(),
          );
        }),
      ],
    );
  }

  Widget _buildCell(String text) {
    return Container(
      height: rowHeight,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Text(
        text,
        style: TextStyle(color: ColorManager.text, fontSize: 13),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}