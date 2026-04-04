import 'package:flutter/material.dart';
import 'azimuthWidget.dart';
import 'customButton.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  double _angle = 234.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: const Text('Azimuth Imitator'), backgroundColor: Colors.black),
      body: Column(
        children: [
          const SizedBox(height: 40),
          Center(
            child: AzimuthWidget(
              value: _angle,
              setPoint: 0.0,
              size: 350, 
              rocketColor: Colors.cyanAccent,
            ),
          ),
         // const Spacer(),
          // Управление
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomButton(
                  label: '-',
                  color: Colors.grey,
                  borderColor: Colors.grey,
                  onPressed: () => setState(() => _angle = (_angle - 15) % 360),
                ),
                const SizedBox(width: 20),
                CustomButton(
                  label: '+',
                  color: Colors.grey,
                  borderColor: Colors.grey,
                  onPressed: () => setState(() => _angle = (_angle + 15) % 360),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomButton(
                  label: 'СТОП',
                  color: Colors.grey,
                  textColor: Colors.red,
                  borderColor: Colors.redAccent,
                  onPressed: () => debugPrint('STOP pressed'),
                ),
                const SizedBox(width: 20),
                CustomButton(
                  label: 'ПУСК',
                  color: Colors.grey,
                  textColor: Colors.green,
                  borderColor: Colors.greenAccent,
                  onPressed: () => debugPrint('PUSK pressed'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          //5 кнопок управления
           Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomButton(
                  label: 'ГОТОВНОСТЬ',
                  color: Colors.blueAccent, //FromARGB
                  onPressed: () => debugPrint('ГОТОВНОСТЬ pressed'),
                ),
                const SizedBox(width: 20),
                CustomButton(
                  label: 'ПРЕДУПР./КВИТИРОВАНИЕ',
                  width: 250,
                  color: Colors.grey,
                  textColor: Colors.green,
                  borderColor: Colors.greenAccent,
                  onPressed: () => debugPrint('ПРЕДУПР./КВИТИРОВАНИЕ pressed'),
                ),
                const SizedBox(width: 20),
              ],
            ),
          ),
           CustomButton(
                  label: 'АВАРИЯ/КВИТИРОВАНИЕ',
                  width: 300,
                  //height: 150,
                  color: Colors.redAccent,
                  textColor: Colors.white,
                  borderColor: Colors.redAccent,
                  onPressed: () => debugPrint('АВАРИЯ/КВИТИРОВАНИЕ pressed'),
                ),
                const SizedBox(width: 20),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(children: [                
                CustomButton(
                  label: 'ОГРАНИЧЕНИЕ МОЩНОСТИ',
                  width: 300,
                  color: Colors.grey,
                  textColor: Colors.red,
                  borderColor: Colors.redAccent,
                  onPressed: () => debugPrint('ОГРАНИЧЕНИЕ МОЩНОСТИ pressed'),
                ),
                const SizedBox(width: 20),
                
                CustomButton(
                  label: 'БЛОКИРОВКА ЗАЩИТ',
                  color: Colors.grey,
                  width: 250,
                  textColor: Colors.red,
                  borderColor: Colors.redAccent,
                  onPressed: () => debugPrint('БЛОКИРОВКА ЗАЩИТ pressed'),
                ),
            ],),
          ),
        ],
      ),
    );
  }
}