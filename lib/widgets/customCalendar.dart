import 'package:flutter/material.dart';
import '../components/colorManager.dart';

class CustomCalendar extends StatefulWidget {
  final DateTime selectedDate;
  final DateTime? otherDate;
  final ValueChanged<DateTime> onDateSelected;

  const CustomCalendar({
    super.key,
    required this.selectedDate,
    this.otherDate,
    required this.onDateSelected,
  });

  @override
  State<CustomCalendar> createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  late DateTime _viewMonth;

  @override
  void initState() {
    super.initState();
    _viewMonth = DateTime(widget.selectedDate.year, widget.selectedDate.month);
  }

  @override
  void didUpdateWidget(CustomCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedDate.year != oldWidget.selectedDate.year ||
        widget.selectedDate.month != oldWidget.selectedDate.month) {
      setState(() {
        _viewMonth = DateTime(widget.selectedDate.year, widget.selectedDate.month);
      });
    }
  }

  static const _monthNames = [
    'Январь', 'Февраль', 'Март', 'Апрель', 'Май', 'Июнь',
    'Июль', 'Август', 'Сентябрь', 'Октябрь', 'Ноябрь', 'Декабрь',
  ];

  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateTime(_viewMonth.year, _viewMonth.month + 1, 0).day;
    final startOffset = DateTime(_viewMonth.year, _viewMonth.month, 1).weekday - 1;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => setState(() {
                _viewMonth = DateTime(_viewMonth.year, _viewMonth.month - 1);
              }),
              child: Icon(Icons.chevron_left, color: ColorManager.primary, size: 26),
            ),
            Text(
              '${_monthNames[_viewMonth.month - 1]} ${_viewMonth.year}',
              style: TextStyle(
                color: ColorManager.text,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            GestureDetector(
              onTap: () => setState(() {
                _viewMonth = DateTime(_viewMonth.year, _viewMonth.month + 1);
              }),
              child: Icon(Icons.chevron_right, color: ColorManager.primary, size: 26),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс']
              .map((d) => SizedBox(
                    width: 34,
                    child: Text(
                      d,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: ColorManager.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ))
              .toList(),
        ),
        const SizedBox(height: 4),
        ..._buildWeekRows(daysInMonth, startOffset),
      ],
    );
  }

  List<Widget> _buildWeekRows(int daysInMonth, int startOffset) {
    final rows = <Widget>[];
    final cells = <Widget>[];

    for (int i = 0; i < startOffset; i++) {
      cells.add(const SizedBox(width: 34, height: 34));
    }

    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(_viewMonth.year, _viewMonth.month, day);
      final isSelected = _sameDay(date, widget.selectedDate);
      final isOther = widget.otherDate != null && _sameDay(date, widget.otherDate!);

      BoxDecoration? decoration;
      if (isSelected) {
        decoration = BoxDecoration(color: ColorManager.primary, shape: BoxShape.circle);
      } else if (isOther) {
        decoration = BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: ColorManager.primary, width: 1.5),
        );
      }

      cells.add(GestureDetector(
        onTap: () => widget.onDateSelected(date),
        child: Container(
          width: 34,
          height: 34,
          alignment: Alignment.center,
          decoration: decoration,
          child: Text(
            '$day',
            style: TextStyle(
              color: isSelected ? ColorManager.primaryBackground : ColorManager.text,
              fontSize: 13,
              fontWeight: (isSelected || isOther) ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ));

      if (cells.length == 7) {
        rows.add(Row(children: List.from(cells)));
        rows.add(const SizedBox(height: 2));
        cells.clear();
      }
    }

    if (cells.isNotEmpty) {
      while (cells.length < 7) {
        cells.add(const SizedBox(width: 34, height: 34));
      }
      rows.add(Row(children: List.from(cells)));
    }

    return rows;
  }
}
