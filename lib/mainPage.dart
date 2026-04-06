// ignore_for_file: file_names
import 'package:azimuth_imitator/customProgressBar.dart';
import 'package:azimuth_imitator/customSlider.dart';
import 'package:flutter/material.dart';
import 'azimuthWidget.dart';
import 'customButton.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  double _angle = 234.0; //для азимута
  double progressBar1Value = 0;
  double progressBar2Value = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                // Виджет азимута
                Expanded(
                  flex: 5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // для заголовков (угол и задать)
                      _buildHeaderLabels(),
                      AzimuthWidget(
                        value: _angle,
                        setPoint: 0.0,
                        size: 380,
                        rocketColor: Colors.cyanAccent,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomButton(
                            label: ' - ',
                            color: Colors.grey.withValues(alpha: 0.3),
                            onPressed: () =>
                                setState(() => _angle = (_angle - 15) % 360),
                          ),
                          const SizedBox(width: 15),
                          CustomButton(
                            label: ' + ',
                            color: Colors.grey.withValues(alpha: 0.3),
                            onPressed: () =>
                                setState(() => _angle = (_angle + 15) % 360),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Правая часть с прогресс-барами
                Expanded(
                  flex: 5,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                          left: BorderSide(color: Colors.white10, width: 1)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Обороты в минуту прогресс бар
                        CustomProgressBar(
                            minValue: 0,
                            maxValue: 1500,
                            maxColorChangeValue: 1250,
                            onvalColorChangeColor: Colors.red,
                            currentValue: progressBar1Value,
                            title: 'Об/мин',
                            units: 'RPM'),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomButton(
                                label: ' - ',
                                color: Colors.grey.withValues(alpha: 0.3),
                                onPressed: () {
                                  setState(() {
                                    progressBar1Value--;
                                    debugPrint(
                                        'progress bar value: $progressBar1Value');
                                  });
                                  debugPrint('minus pressed');
                                }),
                            const SizedBox(width: 15),
                            CustomButton(
                                label: ' + ',
                                color: Colors.grey.withValues(alpha: 0.3),
                                onPressed: () {
                                  setState(() {
                                    progressBar1Value++;
                                    debugPrint(
                                        'progress bar value: $progressBar1Value');
                                  });
                                  debugPrint('plus pressed');
                                }),
                          ],
                        ),
                        const SizedBox(height: 40),
                        // мощность прогресс бар
                        CustomProgressBar(
                            minValue: 0,
                            maxValue: 120,
                            maxColorChangeValue: 100,
                            onvalColorChangeColor: Colors.red,
                            currentValue: progressBar2Value,
                            title: 'Мощность',
                            units: '%'),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomButton(
                                label: ' - ',
                                color: Colors.grey.withValues(alpha: 0.3),
                                onPressed: () {
                                  setState(() {
                                    progressBar2Value--;
                                    debugPrint(
                                        'progress bar 2 value: $progressBar2Value');
                                  });
                                  debugPrint('minus pressed');
                                }),
                            const SizedBox(width: 15),
                            CustomButton(
                                label: ' + ',
                                color: Colors.grey.withValues(alpha: 0.3),
                                onPressed: () {
                                  setState(() {
                                    progressBar2Value++;
                                    debugPrint(
                                        'progress bar value: $progressBar2Value');
                                  });
                                  debugPrint('plus pressed');
                                }),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          _buildBottomControlPanel(),
        ],
      ),
    );
  }

  Widget _buildBottomControlPanel() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      decoration: const BoxDecoration(
        color: Color(0xFF0A0A0A),
        border: Border(top: BorderSide(color: Colors.white10)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _group(children: [
              CustomButton(
                  label: 'ПУСК',
                  color: Colors.greenAccent,
                  onPressed: () => debugPrint('PUSK pressed')),
              const SizedBox(width: 8),
              CustomButton(
                  label: 'СТОП',
                  color: Colors.red,
                  onPressed: () => debugPrint('STOP pressed')),
            ]),
            const SizedBox(width: 20),
            _group(children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomButton(
                      label: 'ГОТОВНОСТЬ',
                      color: Colors.blueAccent.withValues(alpha: 0.4),
                      onPressed: () => debugPrint('ГОТОВНОСТЬ pressed')),
                  const SizedBox(height: 6),
                  CustomButton(
                      label: 'ПРЕДУПР. / КВИТИРОВАНИЕ',
                      onPressed: () =>
                          debugPrint('ПРЕДУПР. / КВИТИРОВАНИЕ pressed')),
                ],
              ),
            ]),
            const SizedBox(width: 8),
            CustomButton(
                label: 'АВАРИЯ /КВИТИРОВАНИЕ',
                width: 150,
                height: 70,
                color: Colors.redAccent,
                onPressed: () => debugPrint('АВАРИЯ/КВИТИРОВАНИЕ pressed')),
            const SizedBox(width: 8),
            _group(children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomButton(
                      label: 'ОГРАНИЧЕНИЕ МОЩНОСТИ',
                      width: 130,
                      height: 32,
                      onPressed: () =>
                          debugPrint('ОГРАНИЧЕНИЕ МОЩНОСТИ pressed')),
                  const SizedBox(height: 6),
                  CustomButton(
                      label: 'БЛОКИРОВКА ЗАЩИТ',
                      width: 130,
                      height: 32,
                      onPressed: () => debugPrint('БЛОКИРОВКА ЗАЩИТ pressed')),
                ],
              ),
            ]),
            const SizedBox(width: 20),
            CustomButton(
                label: 'МОЩНОСТЬ',
                width: 100,
                height: 70,
                onPressed: () => debugPrint('20 МЛН МОЩИ ТОМУ, КТО ЭТО НАЖАЛ')),
          ],
        ),
      ),
    );
  }

  Widget _group({required List<Widget> children}) =>
      Row(mainAxisSize: MainAxisSize.min, children: children);

  Widget _buildHeaderLabels() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("УГОЛ\n234 DEG",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          Text("ЗАДАТЬ\n0 DEG",
              style:
                  TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
              textAlign: TextAlign.right),
        ],
      ),
    );
  }
}