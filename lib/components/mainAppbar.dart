import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import '../popup_Pages/popupCMsgsPage.dart';
import '../structures.dart';
import '../widgets/customToggleSwitch.dart';
import '../widgets/customButton.dart';
import '../components/colorManager.dart';
import '../popup_pages/sesSetup.dart';

class MAppBar extends StatefulWidget {
  final bool enableMYDYchangeButton;
  final bool enableButtonAvarii;
  final bool enableButtonBlock;
  final bool enableButtonWarnings;
  final bool enableButtonSesSetup;
  final bool enableButtonPLCprotectionReset;
  final bool enableButtonSettings;

  const MAppBar({
    super.key,
    this.enableMYDYchangeButton = false,
    this.enableButtonAvarii = true,
    this.enableButtonBlock = true,
    this.enableButtonWarnings = true,
    this.enableButtonSesSetup = true,
    this.enableButtonPLCprotectionReset = false,
    this.enableButtonSettings = false,
  });

  @override
  State<MAppBar> createState() => _MAppBar();
}

class _MAppBar extends State<MAppBar> {
  String _currentDateTime = '';

  int avariiNumber = -1;
  int blokirovkiNumber = -1;
  int warningNumber = -1;

  bool blinkFlagAvarii = false;
  bool blinkFlagBlock = false;
  bool blinkFlagWarning = false;

  bool colorFlagAvarii = false;
  bool colorFlagBlock = false;
  bool colorFlagWarning = false;

  @override
  void initState() {
    super.initState();
    _startPeriodicUpdate();
  }

  void _startPeriodicUpdate() {
    Timer.periodic(const Duration(milliseconds: 1000), (Timer timer) async {
      setState(() {
        _updateDateTime();
      });

      int tempAvariiNumber = -1; // Replace with actual value
      if (tempAvariiNumber != avariiNumber) {
        setState(() {
          if (tempAvariiNumber > avariiNumber && tempAvariiNumber > 0) {
            blinkFlagAvarii = true;
          } else {
            blinkFlagAvarii = false;
          }
          avariiNumber = tempAvariiNumber;
        });
      }

      int tempBlokirovkiNumber = -1; // Replace with actual value
      if (tempBlokirovkiNumber != blokirovkiNumber) {
        setState(() {
          if (tempBlokirovkiNumber > blokirovkiNumber &&
              tempBlokirovkiNumber > 0) {
            blinkFlagBlock = true;
          } else {
            blinkFlagBlock = false;
          }
          blokirovkiNumber = tempBlokirovkiNumber;
        });
      }

      int tempWarningNumber = -1; // Replace with actual value
      if (tempWarningNumber != warningNumber) {
        setState(() {
          if (tempWarningNumber > warningNumber && tempWarningNumber > 0) {
            colorFlagWarning = true;
          } else {
            colorFlagWarning = false;
          }
          warningNumber = tempWarningNumber;
        });
      }

      setState(() {
        if (blinkFlagAvarii) {
          colorFlagAvarii = !colorFlagAvarii;
        } else if (avariiNumber != 0) {
          colorFlagAvarii = true;
        } else {
          colorFlagAvarii = false;
        }

        if (blinkFlagBlock) {
          colorFlagBlock = !colorFlagBlock;
        } else if (blokirovkiNumber != 0) {
          colorFlagBlock = true;
        } else {
          colorFlagBlock = false;
        }

        if (blinkFlagWarning) {
          colorFlagWarning = !colorFlagWarning;
        } else if (warningNumber != 0) {
          colorFlagWarning = true;
        } else {
          colorFlagWarning = false;
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _updateDateTime() {
    setState(() {
      _currentDateTime = DateFormat(
        'dd.MM.yyyy\nHH:mm:ss',
      ).format(DateTime.now());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(width: 5),
                Text(
                  'Plc name', //replace later
                  style: TextStyle(color: ColorManager.text, fontSize: 22),
                ),
                if (widget.enableMYDYchangeButton) const SizedBox(width: 20),
                if (widget.enableMYDYchangeButton)
                  CustomToggleSwitch(onToggle: (value) {}), //change later
                const SizedBox(width: 10),
                Text(
                  PanelIsLocalWidget.get(0), //change later
                  style: TextStyle(color: ColorManager.text, fontSize: 22),
                ),
                const SizedBox(width: 10),
                Text(
                  '(${ControlPostWidget.get(0)})', //change later
                  style: TextStyle(color: ColorManager.text, fontSize: 22),
                ),
                const SizedBox(width: 20),
                Text(
                  SesModeStateWidget.get(0), //change later
                  style: TextStyle(color: ColorManager.text, fontSize: 22),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  _currentDateTime,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: ColorManager.text,
                    fontSize: 20,
                    height: 1.2,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (widget.enableButtonPLCprotectionReset)
                  CustomButton(
                    label: 'Сброс защит',
                    onPressed: () => {},
                    width: 170,
                    height: 50,
                  ),
                if (widget.enableButtonAvarii) const SizedBox(width: 10.0),
                if (widget.enableButtonAvarii)
                  CustomButton(
                    label: avariiNumber.toString(),
                    onPressed: () => {
                      if (avariiNumber > 0)
                        {
                          blinkFlagAvarii = false,
                          showDialog(
                            context: context,
                            builder: (_) =>
                                PopupCMsgsPage(queryType: QueryType.avarii),
                          ),
                        }, //open avarii page
                    },
                    borderColor: colorFlagAvarii
                        ? Color.fromARGB(255, 255, 0, 0)
                        : Colors.transparent,
                    borderWidth: 4,
                    width: 50,
                    height: 50,
                  ),
                if (widget.enableButtonWarnings) const SizedBox(width: 10.0),
                if (widget.enableButtonWarnings)
                  CustomButton(
                    label: warningNumber.toString(),
                    onPressed: () => {
                      if (warningNumber > 0)
                        {
                          blinkFlagWarning = false,
                          showDialog(
                            context: context,
                            builder: (_) =>
                                PopupCMsgsPage(queryType: QueryType.warning),
                          ),
                        },
                    },
                    borderColor: colorFlagWarning
                        ? Color.fromARGB(255, 255, 127, 0)
                        : Colors.transparent,
                    borderWidth: 4,
                    width: 50,
                    height: 50,
                  ),
                if (widget.enableButtonBlock) const SizedBox(width: 10.0),
                if (widget.enableButtonBlock)
                  CustomButton(
                    label: blokirovkiNumber.toString(),
                    onPressed: () => {
                      if (blokirovkiNumber > 0)
                        {
                          blinkFlagBlock = false,
                          showDialog(
                            context: context,
                            builder: (_) =>
                                PopupCMsgsPage(queryType: QueryType.block),
                          ),
                        }, //open block page
                    },
                    borderColor: colorFlagBlock
                        ? ColorManager.primary
                        : Colors.transparent,
                    borderWidth: 4,
                    width: 50,
                    height: 50,
                  ),
                if (widget.enableButtonSesSetup) const SizedBox(width: 10.0),
                if (widget.enableButtonSesSetup)
                  CustomButton(
                    height: 50,
                    width: 120,
                    label: 'Упр. СЭС',
                    onPressed: () => {
                      showDialog(
                        barrierDismissible: true,
                        context: context,
                        builder: (_) => SesSetupPage(),
                      ),
                    },
                  ),
                if (widget.enableButtonSettings) const SizedBox(width: 10.0),
                if (widget.enableButtonSettings)
                  CustomButton(
                    icon: Icon(
                      Icons.settings,
                      size: 40,
                      color: ColorManager.text,
                    ),
                    onPressed: () => {}, //settings page
                    width: 50,
                    height: 50,
                  ),
                const SizedBox(width: 5),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
