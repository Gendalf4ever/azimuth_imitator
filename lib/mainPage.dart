// ignore_for_file: file_names
import 'package:azimuth_imitator/customProgressBar.dart';
import 'package:flutter/material.dart';
import 'azimuthWidget.dart';
import 'customButton.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  double _angle = 234.0; // для азимута
  double progressBar1Value = 0; // обороты
  double progressBar2Value = 0; // мощность

  // true - мощность, false - обороты
  bool isPowerControlMode = false;

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
                        
                        // Кнопки для ОБОРОТОВ (видны, если НЕ режим мощности)
                        if (!isPowerControlMode)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomButton(
                                  label: ' - ',
                                  color: Colors.grey.withValues(alpha: 0.3),
                                  onPressed: () {
                                    setState(() {
                                      // Ограничение
                                      progressBar1Value = (progressBar1Value - 1).clamp(0, 1500);
                                      debugPrint('RPM value: $progressBar1Value');
                                    });
                                  }),
                              const SizedBox(width: 15),
                              CustomButton(
                                  label: ' + ',
                                  color: Colors.grey.withValues(alpha: 0.3),
                                  onPressed: () {
                                    setState(() {
                                      // Ограничение
                                      progressBar1Value = (progressBar1Value + 1).clamp(0, 1500);
                                      debugPrint('RPM value: $progressBar1Value');
                                    });
                                  }),
                            ],
                          )
                        else
                          const SizedBox(height: 48),

                        const SizedBox(height: 40),
                        
                        // Мощность прогресс бар
                        CustomProgressBar(
                            minValue: 0,
                            maxValue: 120,
                            maxColorChangeValue: 100,
                            onvalColorChangeColor: Colors.red,
                            currentValue: progressBar2Value,
                            title: 'Мощность',
                            units: '%'),
                        const SizedBox(height: 10),
                        
                        // Кнопки для мощности
                        if (isPowerControlMode)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomButton(
                                  label: ' - ',
                                  color: Colors.grey.withValues(alpha: 0.3),
                                  onPressed: () {
                                    setState(() {
                                      // Ограничение
                                      progressBar2Value = (progressBar2Value - 1).clamp(0, 120);
                                      debugPrint('Power value: $progressBar2Value');
                                    });
                                  }),
                              const SizedBox(width: 15),
                              CustomButton(
                                  label: ' + ',
                                  color: Colors.grey.withValues(alpha: 0.3),
                                  onPressed: () {
                                    setState(() {
                                      // Ограничение
                                      progressBar2Value = (progressBar2Value + 1).clamp(0, 120);
                                      debugPrint('Power value: $progressBar2Value');
                                    });
                                  }),
                            ],
                          )
                        else
                          const SizedBox(height: 48), // Заглушка
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
                label: isPowerControlMode ? 'ОБОРОТЫ' : 'МОЩНОСТЬ', 
                width: 100, 
                height: 70, 
                onPressed: () {
                  setState(() {
                    isPowerControlMode = !isPowerControlMode;
                  });
                  debugPrint('Control mode changed to: ${isPowerControlMode ? "Power" : "RPM"}');
                }
            ),
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