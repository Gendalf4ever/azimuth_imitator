// ignore_for_file: file_names
import 'dart:async';
import 'package:azimuth_imitator/components/colorManager.dart';
import 'package:azimuth_imitator/customProgressBar.dart';
import 'package:azimuth_imitator/widgets/customButton.dart';
import 'package:flutter/material.dart';
import 'azimuthWidget.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  double _targetAngle = 0.0;       
  double _confirmedAngle = 0.0;    
  double _currentAngleValue = 0.0; 
  
  bool _isStarted = false;         
  Timer? _movementTimer;          

  final GlobalKey<State<AzimuthWidget>> _azimuthKey = GlobalKey<State<AzimuthWidget>>();

  double progressBar1Value = 0;
  double progressBar2Value = 0;
  bool isPowerControlMode = false;

  void _changeTargetAngle(double newTarget) {
    if (!_isStarted) return; 

    setState(() {
      _targetAngle = newTarget; 
    });

    _movementTimer?.cancel();

    _movementTimer = Timer(const Duration(seconds: 2), () {
      if (mounted && _isStarted) {
        setState(() {
          _confirmedAngle = _targetAngle;
        });
      }
    });
  }

  @override
  void dispose() {
    _movementTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.primaryBackground,
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
                        key: _azimuthKey,
                        value: _confirmedAngle, 
                        setPoint: _targetAngle, 
                        size: 380,
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
                            onPressed: _isStarted 
                              ? () => _changeTargetAngle((_targetAngle - 15) % 360) 
                              : () {},
                          ),
                          const SizedBox(width: 15),
                          CustomButton(
                            label: ' + ',
                            onPressed: _isStarted 
                              ? () => _changeTargetAngle((_targetAngle + 15) % 360) 
                              : () {},
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
                    decoration: const BoxDecoration(
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
                        if (!isPowerControlMode)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomButton(
                                  label: ' - ',
                                  onPressed: () => setState(() => progressBar1Value = (progressBar1Value - 10).clamp(0, 1500))),
                              const SizedBox(width: 15),
                              CustomButton(
                                  label: ' + ',
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
                                  onPressed: () => setState(() => progressBar2Value = (progressBar2Value - 1).clamp(0, 120))),
                              const SizedBox(width: 15),
                              CustomButton(
                                  label: ' + ',
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
      decoration: BoxDecoration(
        color: ColorManager.primaryBackground,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _group(children: [
              CustomButton(
                label: 'ПУСК', 
                onPressed: () {
                  setState(() {
                    _isStarted = true; 
                  });
                      ScaffoldMessenger.of(context).clearSnackBars();
                     ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: const Text(
                    'Система активна',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  backgroundColor: Colors.green.shade700,
                      duration: const Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                  )
                );
                }
             
              ),
              const SizedBox(width: 8),
              CustomButton(
                label: 'СТОП', 
                onPressed: () {
                  _movementTimer?.cancel();
                  final currentState = _azimuthKey.currentState;
                  if (currentState != null) {
                    (currentState as dynamic).stopAnimation();
                  }
                  
                  setState(() {
                    _isStarted = false; 
                    _confirmedAngle = _currentAngleValue;
                  });
                   ScaffoldMessenger.of(context).clearSnackBars();
                     ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: const Text(
                    'Система неактивна',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  backgroundColor: Colors.red.shade700,
                      duration: const Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                  )
                );
                }
              ),
            ]),
            const SizedBox(width: 20),
            _group(children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomButton(label: 'ГОТОВНОСТЬ', onPressed: () {}),
                  const SizedBox(height: 6),
                  CustomButton(label: 'ПРЕДУПР. / КВИТ.', onPressed: () {}),
                ],
              ),
            ]),
            const SizedBox(width: 8),
            CustomButton(label: 'АВАРИЯ / КВИТ.',  onPressed: () {}),
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
              style: TextStyle(color: ColorManager.text, fontWeight: FontWeight.bold)),
          Text("ЗАДАТЬ\n${target.toInt()} DEG", 
              style: TextStyle(color: ColorManager.text, fontWeight: FontWeight.bold), 
              textAlign: TextAlign.right),
        ],
      ),
    );
  }
}