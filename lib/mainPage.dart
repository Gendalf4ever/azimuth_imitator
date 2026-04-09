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
  double _targetAngle = 234.0;    // Куда смотрит оранжевая стрелка (задается кнопками)
  double _confirmedAngle = 234.0; // Куда летит ракета (фиксируется после ПУСК)
  double _currentAngleValue = 234.0; // Текущее положение ракеты в анимации
  
  double progressBar1Value = 0;
  double progressBar2Value = 0;
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
                Expanded(
                  flex: 5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildHeaderLabels(_currentAngleValue, _targetAngle),
                      AzimuthWidget(
                        value: _confirmedAngle, // Ракета летит к подтвержденному углу
                        setPoint: _targetAngle, // Стрелка всегда показывает заданный
                        size: 380,
                        rocketColor: Colors.cyanAccent,
                        onChanged: (val) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (mounted) { 
                              setState(() {
                                _currentAngleValue = val;
                              });
                            }
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomButton(
                            label: ' - ',
                            color: Colors.grey.withValues(alpha: 0.3),
                            onPressed: () => setState(() => _targetAngle = (_targetAngle - 15) % 360),
                          ),
                          const SizedBox(width: 15),
                          CustomButton(
                            label: ' + ',
                            color: Colors.grey.withValues(alpha: 0.3),
                            onPressed: () => setState(() => _targetAngle = (_targetAngle + 15) % 360),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Правая часть с барами
                Expanded(
                  flex: 5,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(left: BorderSide(color: Colors.white10, width: 1)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomProgressBar(
                            minValue: 0, maxValue: 1500, maxColorChangeValue: 1250,
                            onvalColorChangeColor: Colors.red, currentValue: progressBar1Value,
                            title: 'Об/мин', units: 'RPM'),
                        const SizedBox(height: 10),
                        // Исправил работу слайдера
                        CustomSlider(
                          min: 0, 
                          max: 1500, 
                          onChanged: (value) {
                            setState(() {
                              progressBar1Value = value;
                            });
                          }
                        ),
                        if (!isPowerControlMode)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomButton(
                                  label: ' - ',
                                  color: Colors.grey.withValues(alpha: 0.3),
                                  onPressed: () => setState(() => progressBar1Value = (progressBar1Value - 10).clamp(0, 1500))),
                              const SizedBox(width: 15),
                              CustomButton(
                                  label: ' + ',
                                  color: Colors.grey.withValues(alpha: 0.3),
                                  onPressed: () => setState(() => progressBar1Value = (progressBar1Value + 10).clamp(0, 1500))),
                            ],
                          )
                        else
                          const SizedBox(height: 48),

                        const SizedBox(height: 40),
                        CustomProgressBar(
                            minValue: 0, maxValue: 120, maxColorChangeValue: 100,
                            onvalColorChangeColor: Colors.red, currentValue: progressBar2Value,
                            title: 'Мощность', units: '%'),
                        const SizedBox(height: 10),
                        if (isPowerControlMode)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomButton(
                                  label: ' - ',
                                  color: Colors.grey.withValues(alpha: 0.3),
                                  onPressed: () => setState(() => progressBar2Value = (progressBar2Value - 1).clamp(0, 120))),
                              const SizedBox(width: 15),
                              CustomButton(
                                  label: ' + ',
                                  color: Colors.grey.withValues(alpha: 0.3),
                                  onPressed: () => setState(() => progressBar2Value = (progressBar2Value + 1).clamp(0, 120))),
                            ],
                          )
                        else
                          const SizedBox(height: 48),
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
                onPressed: () {
                  setState(() {
                    // Ракета получает команду лететь к стрелке
                    _confirmedAngle = _targetAngle;
                  });
                }
              ),
              const SizedBox(width: 8),
              CustomButton(label: 'СТОП', color: Colors.red, onPressed: () {}),
            ]),
            const SizedBox(width: 20),
            _group(children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomButton(label: 'ГОТОВНОСТЬ', color: Colors.blueAccent.withValues(alpha: 0.4), onPressed: () {}),
                  const SizedBox(height: 6),
                  CustomButton(label: 'ПРЕДУПР. / КВИТ.', onPressed: () {}),
                ],
              ),
            ]),
            const SizedBox(width: 8),
            CustomButton(label: 'АВАРИЯ / КВИТ.', width: 150, height: 70, color: Colors.redAccent, onPressed: () {}),
            const SizedBox(width: 8),
            _group(children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomButton(label: 'ОГРАНИЧЕНИЕ', width: 130, height: 32, onPressed: () {}),
                  const SizedBox(height: 6),
                  CustomButton(label: 'БЛОКИРОВКА', width: 130, height: 32, onPressed: () {}),
                ],
              ),
            ]),
            const SizedBox(width: 20),
            CustomButton(
                label: isPowerControlMode ? 'ОБОРОТЫ' : 'МОЩНОСТЬ', 
                width: 100, height: 70, 
                onPressed: () => setState(() => isPowerControlMode = !isPowerControlMode)
            ),
          ],
        ),
      ),
    );
  }

  Widget _group({required List<Widget> children}) => Row(mainAxisSize: MainAxisSize.min, children: children);

  Widget _buildHeaderLabels(double current, double target) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("УГОЛ\n${current.toInt()} DEG", 
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          Text("ЗАДАТЬ\n${target.toInt()} DEG", 
              style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold), 
              textAlign: TextAlign.right),
        ],
      ),
    );
  }
}