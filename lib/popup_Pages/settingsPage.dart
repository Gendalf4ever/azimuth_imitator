import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../components/colorManager.dart';
import '../dataProvider.dart';
import '../popup_page_widgets/customPopupPage.dart';
import '../widgets/customButton.dart';
import '../widgets/customNumberPicker.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with SingleTickerProviderStateMixin {
  late StreamSubscription<Map<String, double>> _subscription;

  bool isChanged = false;

  int startPower2GDG = 0;
  int startPower3GDG = 0;
  int startPower4GDG = 0;
  int startTime2GDG = 0;
  int startTime3GDG = 0;
  int startTime4GDG = 0;
  int stopPower2GDG = 0;
  int stopPower3GDG = 0;
  int stopPower4GDG = 0;
  int stopTime2GDG = 0;
  int stopTime3GDG = 0;
  int stopTime4GDG = 0;
  int cooldownGDG1 = 0;
  int cooldownGDG2 = 0;
  int cooldownGDG3 = 0;
  int cooldownGDG4 = 0;

  @override
  void initState() {
    super.initState();
    setState(() {
      // Привязка к датчикам
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _updateValue(VoidCallback updateAction) {
    setState(() {
      updateAction();
      isChanged = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final maxWidth = screenWidth * 0.9 > 1125.0 ? 1125.0 : screenWidth * 0.9;
    final halfWidth = (maxWidth - 20) / 2;

    return CustomPopupPage(
      title: 'Настройки параметров ГДГ',
      showCloseButton: true,
      widgetStack: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: halfWidth,
              height: 240, 
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.blue, width: 2.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Expanded(
                        child: Text('Кол-во\nна шинах',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16)),
                      ),
                      Expanded(
                        child: Text('Лимит пуска, %',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold, color: ColorManager.text, fontSize: 16)),
                      ),
                      Expanded(
                        child: Text('Задержка пуска, сек',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold, color: ColorManager.text, fontSize: 16)),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('1', style: TextStyle(fontWeight: FontWeight.bold, color: ColorManager.text, fontSize: 20)),
                      CustomNumberPicker(
                          initialValue: startPower2GDG,
                          min: 0, max: 100, step: 1,
                          onChanged: (newValue) => _updateValue(() => startPower2GDG = newValue)),
                      CustomNumberPicker(
                          initialValue: startTime2GDG,
                          min: 0, max: 100, step: 1,
                          onChanged: (newValue) => _updateValue(() => startTime2GDG = newValue)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('2', style: TextStyle(fontWeight: FontWeight.bold, color: ColorManager.text, fontSize: 20)),
                      CustomNumberPicker(
                          initialValue: startPower3GDG,
                          min: 0, max: 100, step: 1,
                          onChanged: (newValue) => _updateValue(() => startPower3GDG = newValue)),
                      CustomNumberPicker(
                          initialValue: startTime3GDG,
                          min: 0, max: 100, step: 1,
                          onChanged: (newValue) => _updateValue(() => startTime3GDG = newValue)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('3', style: TextStyle(fontWeight: FontWeight.bold, color: ColorManager.text, fontSize: 20)),
                      CustomNumberPicker(
                          initialValue: startPower4GDG,
                          min: 0, max: 100, step: 1,
                          onChanged: (newValue) => _updateValue(() => startPower4GDG = newValue)),
                      CustomNumberPicker(
                          initialValue: startTime4GDG,
                          min: 0, max: 100, step: 1,
                          onChanged: (newValue) => _updateValue(() => startTime4GDG = newValue)),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: 20), 
            Container(
              width: halfWidth, 
              height: 240,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: ColorManager.primary, width: 2.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: Text('Кол-во\nна шинах',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold, color: ColorManager.text, fontSize: 16)),
                      ),
                      Expanded(
                        child: Text('Лимит останова, %',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold, color: ColorManager.text, fontSize: 16)),
                      ),
                      Expanded(
                        child: Text('Задержка останова, сек',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold, color: ColorManager.text, fontSize: 16)),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('2', style: TextStyle(fontWeight: FontWeight.bold, color: ColorManager.text, fontSize: 20)),
                      CustomNumberPicker(
                          initialValue: stopPower2GDG,
                          min: 0, max: 100, step: 1,
                          onChanged: (newValue) => _updateValue(() => stopPower2GDG = newValue)),
                      CustomNumberPicker(
                          initialValue: stopTime2GDG,
                          min: 0, max: 100, step: 1,
                          onChanged: (newValue) => _updateValue(() => stopTime2GDG = newValue)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('3', style: TextStyle(fontWeight: FontWeight.bold, color: ColorManager.text, fontSize: 20)),
                      CustomNumberPicker(
                          initialValue: stopPower3GDG,
                          min: 0, max: 100, step: 1,
                          onChanged: (newValue) => _updateValue(() => stopPower3GDG = newValue)),
                      CustomNumberPicker(
                          initialValue: stopTime3GDG,
                          min: 0, max: 100, step: 1,
                          onChanged: (newValue) => _updateValue(() => stopTime3GDG = newValue)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('4', style: TextStyle(fontWeight: FontWeight.bold, color: ColorManager.text, fontSize: 20)),
                      CustomNumberPicker(
                          initialValue: stopPower4GDG,
                          min: 0, max: 100, step: 1,
                          onChanged: (newValue) => _updateValue(() => stopPower4GDG = newValue)),
                      CustomNumberPicker(
                          initialValue: stopTime4GDG,
                          min: 0, max: 100, step: 1,
                          onChanged: (newValue) => _updateValue(() => stopTime4GDG = newValue)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 15),

        Container(
          width: maxWidth, 
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: ColorManager.primary, width: 2.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(child: Text('Расхолаживание ГДГ1, мин', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: ColorManager.text, fontSize: 16))),
                  Expanded(child: Text('Расхолаживание ГДГ2, мин', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: ColorManager.text, fontSize: 16))),
                  Expanded(child: Text('Расхолаживание ГДГ3, мин', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: ColorManager.text, fontSize: 16))),
                  Expanded(child: Text('Расхолаживание ГДГ4, мин', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: ColorManager.text, fontSize: 16))),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomNumberPicker(
                      initialValue: cooldownGDG1,
                      min: 0, max: 100, step: 1,
                      onChanged: (newValue) => _updateValue(() => cooldownGDG1 = newValue)),
                  CustomNumberPicker(
                      initialValue: cooldownGDG2,
                      min: 0, max: 100, step: 1,
                      onChanged: (newValue) => _updateValue(() => cooldownGDG2 = newValue)),
                  CustomNumberPicker(
                      initialValue: cooldownGDG3,
                      min: 0, max: 100, step: 1,
                      onChanged: (newValue) => _updateValue(() => cooldownGDG3 = newValue)),
                  CustomNumberPicker(
                      initialValue: cooldownGDG4,
                      min: 0, max: 100, step: 1,
                      onChanged: (newValue) => _updateValue(() => cooldownGDG4 = newValue)),
                ],
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 20),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomButton(
              onPressed: () => Navigator.pop(context),
              label: 'Закрыть без изменений',
            ),
            const SizedBox(width: 20),
            CustomButton(
              onPressed: () {
                if (isChanged) {
                  sendData('startPower2GDG', startPower2GDG.toString());
                  sendData('startPower3GDG', startPower3GDG.toString());
                  sendData('startPower4GDG', startPower4GDG.toString());
                  sendData('startTime2GDG', startTime2GDG.toString());
                  sendData('startTime3GDG', startTime3GDG.toString());
                  sendData('startTime4GDG', startTime4GDG.toString());
                  sendData('stopPower2GDG', stopPower2GDG.toString());
                  sendData('stopPower3GDG', stopPower3GDG.toString());
                  sendData('stopPower4GDG', stopPower4GDG.toString());
                  sendData('stopTime2GDG', stopTime2GDG.toString());
                  sendData('stopTime3GDG', stopTime3GDG.toString());
                  sendData('stopTime4GDG', stopTime4GDG.toString());
                  sendData('cooldownGDG1', cooldownGDG1.toString());
                  sendData('cooldownGDG2', cooldownGDG2.toString());
                  sendData('cooldownGDG3', cooldownGDG3.toString());
                  sendData('cooldownGDG4', cooldownGDG4.toString());

                  setState(() {
                    isChanged = false;
                  });
                  Navigator.pop(context);
                }
              },
              label: 'Применить',
            ),
          ],
        ),
      ],
    );
  }
}

Future<void> sendData(String sensorName, String value) async {
  final url =
      'http://gui${DataProvider.getSensorValue('panelID').toStringAsFixed(0)}:8081/api/v01/SharedMemory/set?$sensorName=$value';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode != 200) {
    throw Exception('Failed to set $sensorName');
  }
}