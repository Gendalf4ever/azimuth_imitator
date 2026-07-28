import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../components/colorManager.dart';
import '../dataProvider.dart';
import '../popup_Pages/popupDatePicker.dart';
import '../widgets/customButton.dart';
import '../widgets/customDropdownMenu.dart';
import '../widgets/customNumberPicker.dart';
import '../widgets/customTable.dart';


class MsgsPage extends StatefulWidget {
  const MsgsPage({super.key});

  @override
  State<MsgsPage> createState() => _MsgsPageState();
}

class _MsgsPageState extends State<MsgsPage>
    with AutomaticKeepAliveClientMixin {
  List<Map<String, dynamic>> data = [];
  int rowCount = 50;
  bool timeSort = true;
  int typeSelected = 0;

  final List<String> columns = ["№", "Имя", "Текст", "Время"];
  final List<String> timeSortOptions = [
    'Время по возрастанию',
    'Время по убыванию',
  ];
  final List<String> modeOptions = [
    "Все",
    "Аварии",
    "Предупреждения",
    "Блокировки",
  ];
  final List<String> modeOptionsForQuery = [
    "",
    "AND mtype = 'Alarm'",
    "AND mtype = 'Warning'",
    "AND mtype = 'Blocking'",
  ];

  List<DateTime?> rangeDatePickerWithValue = [
    DateTime.now().subtract(const Duration(days: 1)),
    DateTime.now(),
  ];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    DateTime startDate = rangeDatePickerWithValue[0]!;
    DateTime endDate = rangeDatePickerWithValue[1]!;
    String timeSortStr = timeSort ? 'DESC' : 'ASC';

    String startDateStr = startDate
        .subtract(DateTime.now().timeZoneOffset)
        .toIso8601String()
        .split('.')[0];
    String endDateStr = endDate
        .subtract(DateTime.now().timeZoneOffset)
        .toIso8601String()
        .split('.')[0];

    try {
      final queryUrl =
          "${DataProvider.getMsgsUrl()}SELECT * FROM uniset.main_messages_src WHERE timestamp >= '$startDateStr' AND timestamp <= '$endDateStr' ${modeOptionsForQuery[typeSelected]} ORDER BY timestamp $timeSortStr LIMIT $rowCount FORMAT JSON";
      final response = await http.get(Uri.parse(queryUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse.containsKey("data")) {
          setState(() {
            data = List<Map<String, dynamic>>.from(jsonResponse["data"]);
          });
        }
      }
    } catch (e) {
      debugPrint("Fetch Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final List<Map<String, String>> tableData = data.asMap().entries.map((
      entry,
    ) {
      final int index = entry.key;
      final row = entry.value;
      return {
        "№": (index + 1).toString(),
        "Имя": row['name']?.toString() ?? "-",
        "Текст": row['message']?.toString() ?? "-",
        "Время": row['timestamp'] != null
            ? DateFormat('dd.MM.yyyy HH:mm:ss').format(
                DateTime.parse(
                  row['timestamp'],
                ).add(DateTime.now().timeZoneOffset),
              )
            : "-",
      };
    }).toList();

    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Панель управления виджетами
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomButton(
                  height: 50,
                  onPressed: () {
                    showDialog<({DateTime begin, DateTime end})>(
                      context: context,
                      builder: (_) => PopupDatePicker(
                        initialBegin: rangeDatePickerWithValue[0],
                        initialEnd: rangeDatePickerWithValue[1],
                      ),
                    ).then((result) {
                      if (result != null) {
                        setState(() {
                          rangeDatePickerWithValue = [result.begin, result.end];
                        });
                        fetchData();
                      }
                    });
                  },
                  label: 'Календарь',
                ),

                // 1. Сортировка времени переведена на CustomDropdown
                CustomDropdown<int>(
                  width: 240,
                  height: 50,
                  //color: ColorManager.primary,
                  //backgroundColor: const Color(0xFF303F46),
                  value: timeSort ? 1 : 0,
                  items: List.generate(2, (index) {
                    return DropdownMenuItem<int>(
                      value: index,
                      child: Text(
                        timeSortOptions[index],
                        style: TextStyle(
                          color: ColorManager.text,
                          fontSize: 16,
                        ),
                      ),
                    );
                  }),
                  onChanged: (value) {
                    setState(() {
                      timeSort = (value == 1);
                      fetchData();
                    });
                  },
                ),

                CustomDropdown<int>(
                  width: 180,
                  height: 50,
                  //color: ColorManager.primary,
                  //backgroundColor: ColorManager.primaryBackground,
                  value: typeSelected,
                  items: List.generate(modeOptions.length, (index) {
                    return DropdownMenuItem<int>(
                      value: index,
                      child: Text(
                        modeOptions[index],
                        style: TextStyle(
                          color: ColorManager.text,
                          fontSize: 16,
                        ),
                      ),
                    );
                  }),
                  onChanged: (value) {
                    setState(() {
                      typeSelected = value!;
                      fetchData();
                    });
                  },
                ),
                Row(
                  children: [
                    Text(
                      'Строк:  ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: ColorManager.text,
                        fontSize: 20,
                      ),
                    ),
                    CustomNumberPicker(
                      height: 50,
                      initialValue: rowCount,
                      min: 10,
                      max: 1000,
                      step: 10,
                      onChanged: (newValue) {
                        setState(() => rowCount = newValue);
                        fetchData();
                      },
                    ),
                  ],
                ),
                CustomButton(
                  icon: Icon(Icons.refresh, color: ColorManager.text),
                  width: 50,
                  height: 50,
                  onPressed: () {
                    setState(() {
                      fetchData;
                    });
                  },
                ),
                /*IconButton(
                  iconSize: 36,
                  icon: Icon(Icons.refresh, color: ColorManager.text),
                  onPressed: fetchData,
                ),*/
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: ColorManager.primaryBackground,
                  border: Border.all(color: ColorManager.primary, width: 2.0),
                ),
                child: InteractiveViewer(
                  scaleEnabled: false,
                  panAxis: PanAxis.vertical,
                  constrained: false,
                  child: SizedBox(
                    width: 1250,
                    child: SingleChildScrollView(
                      child: CustomTable(data: tableData, columns: columns),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
