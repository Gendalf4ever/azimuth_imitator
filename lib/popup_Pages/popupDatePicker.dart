import 'package:flutter/material.dart';
import '../components/colorManager.dart';
import '../popup_page_widgets/customPopupPage.dart';
import '../popup_page_widgets/popupPageBlock.dart';
import '../widgets/customButton.dart';
import '../widgets/customCalendar.dart';
import '../widgets/customNumberPicker.dart';

class PopupDatePicker extends StatefulWidget {
  final DateTime? initialBegin;
  final DateTime? initialEnd;
  final void Function(({DateTime begin, DateTime end}))? onChanged;

  const PopupDatePicker({
    super.key,
    this.initialBegin,
    this.initialEnd,
    this.onChanged,
  });

  @override
  State<PopupDatePicker> createState() => _PopupDatePickerState();
}

class _PopupDatePickerState extends State<PopupDatePicker>
    with AutomaticKeepAliveClientMixin {
  late DateTime _beginDate;
  late DateTime _endDate;
  late int _beginHour;
  late int _beginMinute;
  late int _endHour;
  late int _endMinute;

  // Bumped whenever time pickers must reinitialize (preset applied or clamped).
  int _keyGen = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _load(
      begin: widget.initialBegin ?? now.subtract(const Duration(hours: 24)),
      end: widget.initialEnd ?? now,
    );
  }

  // ── Internal loaders ──────────────────────────────────────────────────────

  void _load({required DateTime begin, required DateTime end}) {
    _beginDate = DateTime(begin.year, begin.month, begin.day);
    _beginHour = begin.hour;
    _beginMinute = begin.minute;
    _endDate = DateTime(end.year, end.month, end.day);
    _endHour = end.hour;
    _endMinute = end.minute;
  }

  DateTime get _beginDT => DateTime(
      _beginDate.year, _beginDate.month, _beginDate.day, _beginHour, _beginMinute);

  DateTime get _endDT => DateTime(
      _endDate.year, _endDate.month, _endDate.day, _endHour, _endMinute);

  void _notifyChanged() =>
      widget.onChanged?.call((begin: _beginDT, end: _endDT));

  // ── Validated apply helpers ───────────────────────────────────────────────
  // Return true when the value was clamped so caller can bump _keyGen.

  bool _applyBegin(DateTime date, int hour, int minute) {
    final candidate = DateTime(date.year, date.month, date.day, hour, minute);
    if (candidate.isAfter(_endDT)) {
      final clamped = _endDT;
      _beginDate = DateTime(clamped.year, clamped.month, clamped.day);
      _beginHour = clamped.hour;
      _beginMinute = clamped.minute;
      return true;
    }
    _beginDate = DateTime(date.year, date.month, date.day);
    _beginHour = hour;
    _beginMinute = minute;
    return false;
  }

  bool _applyEnd(DateTime date, int hour, int minute) {
    final candidate = DateTime(date.year, date.month, date.day, hour, minute);
    if (candidate.isBefore(_beginDT)) {
      final clamped = _beginDT;
      _endDate = DateTime(clamped.year, clamped.month, clamped.day);
      _endHour = clamped.hour;
      _endMinute = clamped.minute;
      return true;
    }
    _endDate = DateTime(date.year, date.month, date.day);
    _endHour = hour;
    _endMinute = minute;
    return false;
  }

  // ── Event handlers ────────────────────────────────────────────────────────

  void _onBeginDateChanged(DateTime d) {
    setState(() { if (_applyBegin(d, _beginHour, _beginMinute)) _keyGen++; });
    _notifyChanged();
  }

  void _onEndDateChanged(DateTime d) {
    setState(() { if (_applyEnd(d, _endHour, _endMinute)) _keyGen++; });
    _notifyChanged();
  }

  void _onBeginHourChanged(int h) {
    setState(() { if (_applyBegin(_beginDate, h, _beginMinute)) _keyGen++; });
    _notifyChanged();
  }

  void _onBeginMinuteChanged(int m) {
    setState(() { if (_applyBegin(_beginDate, _beginHour, m)) _keyGen++; });
    _notifyChanged();
  }

  void _onEndHourChanged(int h) {
    setState(() { if (_applyEnd(_endDate, h, _endMinute)) _keyGen++; });
    _notifyChanged();
  }

  void _onEndMinuteChanged(int m) {
    setState(() { if (_applyEnd(_endDate, _endHour, m)) _keyGen++; });
    _notifyChanged();
  }

  void _applyPreset(Duration duration) {
    final now = DateTime.now();
    setState(() {
      _load(begin: now.subtract(duration), end: now);
      _keyGen++;
    });
    _notifyChanged();
  }

  void _confirm() => Navigator.of(context).pop((begin: _beginDT, end: _endDT));

  // ── Build helpers ─────────────────────────────────────────────────────────

  Widget _timePicker({
    required int hour,
    required int minute,
    required ValueChanged<int> onHourChanged,
    required ValueChanged<int> onMinuteChanged,
    required String keyPrefix,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomNumberPicker(
          key: ValueKey('${keyPrefix}_h_$_keyGen'),
          initialValue: hour,
          min: 0,
          max: 23,
          width: 110,
          height: 40,
          onChanged: onHourChanged,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Text(
            ':',
            style: TextStyle(
              color: ColorManager.text,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              height: 1,
            ),
          ),
        ),
        CustomNumberPicker(
          key: ValueKey('${keyPrefix}_m_$_keyGen'),
          initialValue: minute,
          min: 0,
          max: 59,
          width: 110,
          height: 40,
          onChanged: onMinuteChanged,
        ),
      ],
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return CustomPopupPage(
      title: 'Выбор периода',
      widgetStack: [
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 290,
              child: PopupPageBlock(
                title: 'Начало',
                widgetStack: [
                  CustomCalendar(
                    selectedDate: _beginDate,
                    otherDate: _endDate,
                    onDateSelected: _onBeginDateChanged,
                  ),
                  const SizedBox(height: 10),
                  _timePicker(
                    hour: _beginHour,
                    minute: _beginMinute,
                    onHourChanged: _onBeginHourChanged,
                    onMinuteChanged: _onBeginMinuteChanged,
                    keyPrefix: 'begin',
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 290,
              child: PopupPageBlock(
                title: 'Конец',
                widgetStack: [
                  CustomCalendar(
                    selectedDate: _endDate,
                    otherDate: _beginDate,
                    onDateSelected: _onEndDateChanged,
                  ),
                  const SizedBox(height: 10),
                  _timePicker(
                    hour: _endHour,
                    minute: _endMinute,
                    onHourChanged: _onEndHourChanged,
                    onMinuteChanged: _onEndMinuteChanged,
                    keyPrefix: 'end',
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomButton(
              label: 'день',
              width: 100,
              height: 40,
              onPressed: () => _applyPreset(const Duration(hours: 24)),
            ),
            const SizedBox(width: 10),
            CustomButton(
              label: '3 дня',
              width: 100,
              height: 40,
              onPressed: () => _applyPreset(const Duration(days: 3)),
            ),
            const SizedBox(width: 10),
            CustomButton(
              label: 'неделя',
              width: 100,
              height: 40,
              onPressed: () => _applyPreset(const Duration(days: 7)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        CustomButton(
          label: 'Применить',
          width: 160,
          height: 44,
          onPressed: _confirm,
        ),
      ],
    );
  }
}
