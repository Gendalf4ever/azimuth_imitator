import 'package:flutter/material.dart';
import '../widgets/customButton.dart';
import '../popup_page_widgets/customPopupPage.dart';
import '../popup_page_widgets/popupPageBlock.dart';
import '../popup_Pages/settingsPage.dart';
import '../diagram_widgets/CircleIndicator.dart';
import '../components/colorManager.dart';
import '../widgets/customDropdownMenu.dart';
import '../structures.dart';

class SesSetupPage extends StatefulWidget {
  const SesSetupPage({super.key});

  @override
  State<SesSetupPage> createState() => _SesSetupPageState();
}

class _SesSetupPageState extends State<SesSetupPage> {
  int? priorityVal1 = 0;
  int? priorityVal2 = 0;
  int? priorityVal3 = 0;
  int? priorityVal4 = 0;
  int? sesmode = 0;
  int? genNum = 0;

  @override
  Widget build(BuildContext context) {
    return CustomPopupPage(
      showCloseButton: true,
      title: 'Управление СЭС',
      widgetStack: [
        PopupPageBlock(
          widgetStack: [
            Row(
              children: [
                CircleIndicator(
                  size: 80,
                  stateColor: GDGStateWidget.getColor(3), //change later
                  label: ' Г1 ',
                  extraWidgetPosition: CircleExtraWidgetPosition.right,
                  extraWidget: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ГДГ1',
                        style: TextStyle(
                          color: ColorManager.text,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 60),
                      Text(
                        '1', //priority change later
                        style: TextStyle(
                          color: ColorManager.text,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                CircleIndicator(
                  size: 80,
                  stateColor: GDGStateWidget.getColor(1), //change later
                  label: ' Г2 ',
                  extraWidgetPosition: CircleExtraWidgetPosition.right,
                  extraWidget: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ГДГ2',
                        style: TextStyle(
                          color: ColorManager.text,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 60),
                      Text(
                        '2', //priority change later
                        style: TextStyle(
                          color: ColorManager.text,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                CircleIndicator(
                  size: 80,
                  stateColor: GDGStateWidget.getColor(2), //change later
                  label: ' Г3 ',
                  extraWidgetPosition: CircleExtraWidgetPosition.right,
                  extraWidget: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ГДГ3',
                        style: TextStyle(
                          color: ColorManager.text,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 60),
                      Text(
                        '3', //priority change later
                        style: TextStyle(
                          color: ColorManager.text,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                CircleIndicator(
                  size: 80,
                  stateColor: GDGStateWidget.getColor(4), //change later
                  label: ' Г4 ',
                  extraWidgetPosition: CircleExtraWidgetPosition.right,
                  extraWidget: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ГДГ4',
                        style: TextStyle(
                          color: ColorManager.text,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 60),
                      Text(
                        '4', //priority change later
                        style: TextStyle(
                          color: ColorManager.text,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CustomDropdown<String>(
                  selectedIndex: priorityVal1,
                  onIndexChanged: (val) => setState(() => priorityVal1 = val),
                  items: ['1', '2', '3', '4']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  width: 80,
                  height: 50,
                ),
                CustomDropdown<String>(
                  selectedIndex: priorityVal2,
                  onIndexChanged: (val) => setState(() => priorityVal2 = val),
                  items: ['1', '2', '3', '4']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  width: 80,
                  height: 50,
                ),
                CustomDropdown<String>(
                  selectedIndex: priorityVal3,
                  onIndexChanged: (val) => setState(() => priorityVal3 = val),
                  items: ['1', '2', '3', '4']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  width: 80,
                  height: 50,
                ),
                CustomDropdown<String>(
                  selectedIndex: priorityVal4,
                  onIndexChanged: (val) => setState(() => priorityVal4 = val),
                  items: ['1', '2', '3', '4']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  width: 80,
                  height: 50,
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 10),
        PopupPageBlock(
          widgetStack: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Текущий режим СЭС: ${SesModeStateWidget.get(1)}', // change later
                  style: TextStyle(color: ColorManager.text, fontSize: 26),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Выбор режима СЭС: ',
                      style: TextStyle(color: ColorManager.text, fontSize: 26),
                    ),
                    CustomDropdown<int>(
                      value: sesmode,
                      onChanged: (val) => setState(() => sesmode = val),
                      excludeKeys: const [-1, 0, 6],
                      disabledKeys: const [3, 4],
                      items: SesModeStateWidget.getList().entries
                          .map(
                            (e) => DropdownMenuItem<int>(
                              value: e.key,
                              child: Text(e.value),
                            ),
                          )
                          .toList(),
                      width: 200,
                      height: 40,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 10),
        PopupPageBlock(
          widgetStack: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Генераторов на шине: ',
                  style: TextStyle(color: ColorManager.text, fontSize: 26),
                ),
                CustomDropdown<String>(
                  selectedIndex: genNum,
                  onIndexChanged: (val) => setState(() => genNum = val),
                  items: ['1', '2', '3', '4']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  width: 80,
                  height: 40,
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CustomButton(
              icon: Icon(Icons.settings, size: 40, color: ColorManager.text),
              onPressed: () => {
                showDialog(context: context, builder: (_) => SettingsPage()),
              },
              width: 60,
              height: 60,
            ),
            CustomButton(
              isBlocked:
                  {
                    priorityVal1,
                    priorityVal2,
                    priorityVal3,
                    priorityVal4,
                  }.length !=
                  4,
              label:
                  {
                        priorityVal1,
                        priorityVal2,
                        priorityVal3,
                        priorityVal4,
                      }.length ==
                      4
                  ? 'Применить'
                  : 'Некорректные приоритеты',
              onPressed: () => {Navigator.pop(context)},
              width: 470,
              height: 60,
            ),
          ],
        ),
      ],
    );
  }
}
