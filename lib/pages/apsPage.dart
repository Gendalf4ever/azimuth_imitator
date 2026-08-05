import 'package:flutter/material.dart';
import '../components/colorManager.dart';
import '../structures.dart'; 
import '../widgets/customLamp.dart'; 

class Apspage extends StatefulWidget {
  const Apspage({super.key});

  @override
  State<Apspage> createState() => _ApspageState();
}

class _ApspageState extends State<Apspage> {
  // demo
  final int _phaseVState = 1; 
  final int _phaseUState = 1; 
  final int _phaseWState = 1; 

  //test
  final int _pcFaultState = 3;     
  final int _pcWarningState = 9; 
  final int _gdg1State = 5;        
  final int _gdg2State = 5;        
  final int _sesReadyState = 1;    
  final int _sesNotReadyState = 9; 


  String _getTempStatusText(int state) {
    switch (state) {
      case 1: return 'Норма';
      case 2:
      case 4: return 'Перегрев';
      case 3:
      case 5: return 'Ав. перегрев';
      default: return 'Не определено';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.primaryBackground,
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(child: _buildPhaseCard('ФАЗА V', '123', _phaseVState)),
                  const SizedBox(width: 10),
                  Expanded(child: _buildPhaseCard('ФАЗА U', '123', _phaseUState)),
                  const SizedBox(width: 10),
                  Expanded(child: _buildPhaseCard('ФАЗА W', '123', _phaseWState)),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: _buildSectionBox(
                      title: 'ПЧ - состояния',
                      children: [
                        _buildStructStatusButton('НЕИСПР. ПЧ', _pcWarningState),
                        const SizedBox(height: 8),
                        _buildStructStatusButton('АВАРИЯ ПЧ', _pcFaultState),
                        const SizedBox(height: 8),
                        _buildStructStatusButton('АВАРИЙНЫЙ СТОП', _pcFaultState),
                        const SizedBox(height: 8),
                        _buildStructStatusButton('ЗАПРЕТ ОТ СУ ГЭУ', _pcWarningState),
                      ],
                    ), 
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    flex: 4,
                    child: _buildSectionBox(
                      title: 'ПЧ - питание',
                      children: [
                        Row(
                          children: [
                            Expanded(child: _buildStructStatusButton('НЕИСПР. ПИТАЮЩ. СЕТИ', _pcWarningState)),
                            const SizedBox(width: 8),
                            Expanded(child: _buildStructStatusButton('ВЫСОКОЕ НАПР. ЗПТ', _pcFaultState)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(child: _buildStructStatusButton('НЕИСПР. ВЫХОД. СЕТИ', _pcWarningState)),
                            const SizedBox(width: 8),
                            Expanded(child: _buildStructStatusButton('НИЗКОЕ НАПР. ЗПТ', _pcFaultState)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        _buildStructStatusButton('ПРЕВЫШЕНИЕ ТОКА', _pcWarningState),
                      ],
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    flex: 3,
                    child: _buildSectionBox(
                      title: 'ПЧ - ОХЛАЖДЕНИЕ',
                      children: [
                        _buildStructStatusButton('НЕИСПР. СИСТЕМЫ ОХЛ.', _pcWarningState),
                        const SizedBox(height: 8),
                        _buildStructStatusButton('ПРОТЕЧКА', _pcWarningState),
                        const SizedBox(height: 8),
                        _buildStructStatusButton('ПЕРЕГРЕВ ПЧ', _pcFaultState),
                        const SizedBox(height: 8),
                        _buildStructStatusButton('ПЕРЕГРЕВ СИЛ. МОДУЛЕЙ', _pcFaultState),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: _buildSectionBox(
                      title: 'ВРК - СОСТОЯНИЯ',
                      children: [
                        Row(
                          children: [
                            Expanded(child: _buildStructStatusButton('НЕИСПР. ВРК', _pcWarningState)),
                            const SizedBox(width: 8),
                            Expanded(child: _buildStructStatusButton('АВАРИЯ ВРК', _pcFaultState)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    flex: 5,
                    child: _buildSectionBox(
                      title: 'СЭС',
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _buildLampButton(
                                label: 'ГДГ1', 
                                state: _gdg1State, 
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildLampButton(
                                label: 'ГОТОВНОСТЬ СЭС К DP/IJ', 
                                state: _sesReadyState, 
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: _buildLampButton(
                                label: 'ГДГ2', 
                                state: _gdg2State, 
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildLampButton(
                                label: 'СЭС НЕ ГОТОВА К РАБОТЕ ГЭУ', 
                                state: _sesNotReadyState, 
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhaseCard(String phaseTitle, String value, int state) {
    final Color stateColor = CBStateWidget.getColor(state);
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: ColorManager.primaryBackground,
        border: Border.all(color: ColorManager.primary),
      ),
      child: Column(
        children: [
          Text(
            phaseTitle, 
            style: TextStyle(
              color: ColorManager.text,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            '$value°C',
            style: TextStyle(color: ColorManager.text, fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4),
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: stateColor,
              border: Border.all(color: stateColor),
            ),
            child: Text(
              _getTempStatusText(state),
              style: TextStyle(
                color: stateColor,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildSectionBox({required String title, required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ColorManager.primaryBackground,
        border: Border.all(color: ColorManager.primary),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(border: Border.all(color: ColorManager.primary)),
              child: Text(
                title,
                style: TextStyle(color: ColorManager.text, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 10),
          ...children
        ],
      ),
    );
  }


  Widget _buildStructStatusButton(String label, int state) {  //maybe delete later
    final Color baseColor = TransformerStateWidget.getColor(state);

    return InkWell(
      onTap: () {},
      child: Container(
        height: 45,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: baseColor,
          border: Border.all(color: baseColor),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: baseColor == ColorManager.text ? ColorManager.text : baseColor, 
            fontSize: 11, 
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }


  Widget _buildLampButton({required String label, required int state}) {
    return Container(
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: ColorManager.primaryBackground,
        border: Border.all(color: ColorManager.primary),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ColorManager.text,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 4),
          CustomLamp(
            state: state, 
            stateColors: GDGStateWidget.getColorList(),
            size: 20,
          )
        ],
      ),
    );
  }
}