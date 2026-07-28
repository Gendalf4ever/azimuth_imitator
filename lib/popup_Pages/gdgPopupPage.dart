import 'dart:async';
import 'package:flutter/material.dart';
import '../components/colorManager.dart';
import '../dataProvider.dart';
import '../widgets/customButton.dart';
import '../widgets/customNumberPicker.dart';
import '../widgets/customProgressBar.dart';
import '../popup_page_widgets/customPopupPage.dart';
import '../popup_page_widgets/popupPageBlock.dart';

/// Всплывающая страница генератора (ГДГ).
/// Открывается по нажатию на [CustomGDGIndicator].
///
/// Заголовок — «ГДГ N: <состояние>», в шапке справа — режим управления (МУ/ДУ).
/// Тело — блок прогресс-баров, кнопки Пуск/Стоп и блок ограничения мощности.
///
/// Макс./мин. значения прогресс-баров читаются из DataProvider
/// (GDG_N_*_max / GDG_N_power_reserve_min). Исключение — PF: датчика максимума
/// нет, поэтому используется 1.0.
class GdgPopupPage extends StatefulWidget {
  final int gdgnum;

  /// Показать кнопку «Сброс защит СУ».
  /// Сам функционал не реализован — только видимость и хук [onResetProtections].
  final bool showResetButton;
  final VoidCallback? onResetProtections;

  const GdgPopupPage({
    super.key,
    required this.gdgnum,
    this.showResetButton = false,
    this.onResetProtections,
  });

  @override
  State<GdgPopupPage> createState() => _GdgPopupPageState();
}

class _GdgPopupPageState extends State<GdgPopupPage> {
  late StreamSubscription<Map<String, dynamic>> _subscription;

  // Заданное ограничение мощности (ОМ), % — редактируется кнопками -/+.
  late int _setLimit;

  @override
  void initState() {
    super.initState();
    _setLimit = DataProvider.getInt(
      "GDG_${widget.gdgnum}_set_power_limit",
    ).clamp(0, 100);
    _subscription = DataProvider.stream.listen((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  // ── Текст состояния для заголовка ───────────────────────────────────────────
  String _stateText(int state) {
    switch (state) {
      case -1:
        return 'Неизвестно';
      case 0:
        return 'Ошибка чтения';
      case 1:
        return 'Включен, не готов\nк выключению';
      case 2:
        return 'Выключен, не готов\nк включению';
      case 3:
        return 'Авария';
      case 4:
        return 'Выключен, готов\nк включению';
      case 5:
        return 'Включен, готов\nк выключению';
      case 6:
        return 'В защите';
      case 7:
        return 'Включается';
      case 8:
        return 'Выключается';
      default:
        return 'Error, invalid state.';
    }
  }

  // ── Режим управления: МУ (местное) / ДУ (дистанционное) ─────────────────────
  String _controlMode() {
    final isLocal = DataProvider.getBool("GDG_${widget.gdgnum}_isLocal");
    if (isLocal == false) {
      return 'ДУ';
    } else {
      return 'МУ';
    }
  }

  // ── Обработчики ─────────────────────────────────────────────────────────────
  Future<void> _applyLimit() async {
    try {
      await DataProvider.sendData(
        "GDG_${widget.gdgnum}_set_power_limit",
        _setLimit.toString(),
      );
    } catch (_) {
      // отправка не удалась — значение останется локальным
    }
  }

  void _onStart() {
    // TODO: отправить команду «Пуск» на сервер (DataProvider.sendData(...)).
  }

  void _onStop() {
    // TODO: отправить команду «Стоп» на сервер (DataProvider.sendData(...)).
  }

  // ── Прогресс-бар одного параметра ───────────────────────────────────────────
  Widget _bar(
    String title,
    double value,
    String units,
    double maxValue, {
    double minValue = 0,
  }) {
    // Защита от деления на ноль, когда датчик максимума ещё не пришёл (0).
    final safeMax = maxValue > minValue ? maxValue : minValue + 1;
    return CustomProgressBar(
      minValue: minValue,
      maxValue: safeMax,
      currentValue: value,
      title: title,
      units: units,
      width: 300,
      height: 62,
    );
  }

  // Строка сетки: два бара с промежутком.
  Widget _row(Widget left, Widget right) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [left, const SizedBox(width: 12), right],
    ),
  );

  @override
  Widget build(BuildContext context) {
    final g = widget.gdgnum;
    final state = DataProvider.getInt("GDG_${g}_state");
    final title = 'ГДГ$g: ${_stateText(state).replaceAll('\n', ' ')}';
    final dimStyle = TextStyle(
      color: ColorManager.text.withValues(alpha: 0.7),
      fontSize: 18,
    );

    return CustomPopupPage(
      showCloseButton: true,
      title: title,
      // Режим управления (МУ/ДУ) в правом слоте шапки.
      appbarWidget: Text(
        _controlMode(),
        style: TextStyle(
          color: ColorManager.primary,
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
      ),
      widgetStack: [
        // ── Сброс защит СУ (по параметру) ──────────────────────────────────
        if (widget.showResetButton) ...[
          CustomButton(
            label: 'Сброс защит СУ',
            width: 220,
            height: 48,
            onPressed: () => widget.onResetProtections?.call(),
          ),
          const SizedBox(height: 12),
        ],

        // ── Сетка параметров (2 столбца × 5 строк) ─────────────────────────
        // Макс./мин. — из DataProvider (GDG_N_*_max / _min).
        PopupPageBlock(
          widgetStack: [
            _row(
              _bar(
                'Акт. Мощность',
                DataProvider.getDouble("GDG_${g}_power_active"),
                'кВт',
                DataProvider.getDouble("GDG_${g}_power_active_max"),
              ),
              _bar(
                'Напряжение',
                DataProvider.getDouble("GDG_${g}_voltage"),
                'В',
                DataProvider.getDouble("GDG_${g}_voltage_max"),
              ),
            ),
            _row(
              _bar(
                'Резерв мощности',
                DataProvider.getDouble("GDG_${g}_power_reserve"),
                'кВт',
                DataProvider.getDouble("GDG_${g}_power_reserve_max"),
                minValue: DataProvider.getDouble("GDG_${g}_power_reserve_min"),
              ),
              _bar(
                'Частота',
                DataProvider.getDouble("GDG_${g}_freq"),
                'Гц',
                DataProvider.getDouble("GDG_${g}_freq_max"),
              ),
            ),
            _row(
              _bar(
                'Ток U',
                DataProvider.getDouble("GDG_${g}_current_U"),
                'A',
                DataProvider.getDouble("GDG_${g}_current_U_max"),
              ),
              // PF: датчика максимума нет — берём 1.0.
              _bar('PF', DataProvider.getDouble("GDG_${g}_PF"), '', 1.0),
            ),
            _row(
              _bar(
                'Ток V',
                DataProvider.getDouble("GDG_${g}_current_V"),
                'A',
                DataProvider.getDouble("GDG_${g}_current_V_max"),
              ),
              _bar(
                'Реакт. Мощность',
                DataProvider.getDouble("GDG_${g}_power_reactive"),
                'кВАр',
                DataProvider.getDouble("GDG_${g}_power_reactive_max"),
              ),
            ),
            _row(
              _bar(
                'Ток W',
                DataProvider.getDouble("GDG_${g}_current_W"),
                'A',
                DataProvider.getDouble("GDG_${g}_current_W_max"),
              ),
              _bar(
                'Полная Мощность',
                DataProvider.getDouble("GDG_${g}_power_full"),
                'кВА',
                DataProvider.getDouble("GDG_${g}_power_full_max"),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // ── Пуск / Стоп ────────────────────────────────────────────────────
        PopupPageBlock(
          widgetStack: [
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomButton(
                  label: 'Пуск',
                  width: 300,
                  height: 56,
                  onPressed: _onStart,
                ),
                const SizedBox(width: 12),
                CustomButton(
                  label: 'Стоп',
                  width: 300,
                  height: 56,
                  onPressed: _onStop,
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 12),

        // ── Ограничение мощности ───────────────────────────────────────────
        PopupPageBlock(
          title: 'Ограничение мощности',
          widgetStack: [
            Row(
              //mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Пикер ОМ: кнопки -/+ управляют «Заданным», а внутреннее число
                // пикера закрыто подписью «Текущее / Заданное».
                SizedBox(
                  width: 360,
                  height: 70,
                  child: Stack(
                    children: [
                      CustomNumberPicker(
                        width: 360,
                        height: 70,
                        initialValue: _setLimit,
                        min: 0,
                        max: 100,
                        step: 1,
                        onChanged: (val) => setState(() => _setLimit = val),
                      ),
                      // Накрываем число пикера фоном и подписью.
                      Positioned(
                        left: 70,
                        right: 70,
                        top: 2,
                        bottom: 2,
                        child: IgnorePointer(
                          child: Container(
                            color: ColorManager.widgetBackground,
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Текущее: ${DataProvider.getInt("GDG_${g}_current_power_limit")}%',
                                  textAlign: TextAlign.center,
                                  style: dimStyle,
                                ),
                                Text(
                                  'Заданное: $_setLimit%',
                                  textAlign: TextAlign.center,
                                  style: dimStyle,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                CustomButton(
                  label: 'Применить',
                  width: 150,
                  height: 70,
                  onPressed: _applyLimit,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
