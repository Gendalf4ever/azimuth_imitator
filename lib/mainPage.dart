// ignore_for_file: file_names
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
                            width: 80,
                            height: 40,
                            color: Colors.grey.withValues(alpha: 0.3),
                            onPressed: () => setState(() => _angle = (_angle - 15) % 360),
                          ),
                          const SizedBox(width: 15),
                          CustomButton(
                            label: ' + ',
                            width: 80,
                            height: 40,
                            color: Colors.grey.withValues(alpha: 0.3),
                            onPressed: () => setState(() => _angle = (_angle + 15) % 360),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(left: BorderSide(color: Colors.white10, width: 1)),
                    ),
                    child: const Center(
                      child: Text("Место для ползунков", style: TextStyle(color: Colors.white24)),
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
              CustomButton(label: 'ПУСК', width: 100, height: 70, textColor: Colors.green, borderColor: Colors.green, onPressed: () => debugPrint('PUSK pressed')),
              const SizedBox(width: 8),
              CustomButton(label: 'СТОП', width: 100, height: 70, textColor: Colors.red, borderColor: Colors.red, onPressed: () => debugPrint('STOP pressed')),
            ]),
            const SizedBox(width: 20),
            _group(children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomButton(label: 'ГОТОВНОСТЬ', width: 130, height: 32, color: Colors.blueAccent.withValues(alpha: 0.4), onPressed: () => debugPrint('ГОТОВНОСТЬ pressed')),
                  const SizedBox(height: 6),
                  CustomButton(label: 'ПРЕДУПР. / КВИТИРОВАНИЕ', width: 130, height: 32, textColor: Colors.yellow, borderColor: Colors.yellow, onPressed: () => debugPrint('ПРЕДУПР. / КВИТИРОВАНИЕ pressed')),
                ],
              ),
            ]),
            const SizedBox(width: 8),
            CustomButton(
              label: 'АВАРИЯ /\nКВИТИРОВАНИЕ', 
              width: 150, 
              height: 70, 
              color: Colors.red, 
              textColor: Colors.white, 
              onPressed: () => debugPrint('АВАРИЯ/КВИТИРОВАНИЕ pressed')
            ),
            const SizedBox(width: 8),
            _group(children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomButton(label: 'ОГРАНИЧЕНИЕ МОЩНОСТИ', width: 130, height: 32, textColor: Colors.yellow, borderColor: Colors.yellow, onPressed: () => debugPrint('ОГРАНИЧЕНИЕ МОЩНОСТИ pressed')),
                  const SizedBox(height: 6),
                  CustomButton(label: 'БЛОКИРОВКА ЗАЩИТ', width: 130, height: 32, textColor: Colors.yellow, borderColor: Colors.yellow, onPressed: () => debugPrint('БЛОКИРОВКА ЗАЩИТ pressed')),
                ],
              ),
            ]),
            const SizedBox(width: 20),
            CustomButton(label: 'МОЩНОСТЬ', width: 100, height: 70, borderColor: Colors.white38, onPressed: () => debugPrint('20 МЛН МОЩИ ТОМУ, КТО ЭТО НАЖАЛ')),
          ],
        ),
      ),
    );
  }

  Widget _group({required List<Widget> children}) => Row(mainAxisSize: MainAxisSize.min, children: children);

  Widget _buildHeaderLabels() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("УГОЛ\n234 DEG", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          Text("ЗАДАТЬ\n0 DEG", style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold), textAlign: TextAlign.right),
        ],
      ),
    );
  }
}