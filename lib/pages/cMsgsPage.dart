import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:template_proj/components/colorManager.dart';
import 'package:template_proj/widgets/customDropdownMenu.dart';
import 'package:template_proj/widgets/customTable.dart';
import '../dataProvider.dart';

class CMsgsPage extends StatefulWidget {
  const CMsgsPage({super.key});

  @override
  State<CMsgsPage> createState() => _CMsgsPageState();
}

class _CMsgsPageState extends State<CMsgsPage> {
  List<Map<String, dynamic>> data = [];
  Timer? _timer;
  int rowCount = 20;
  int typeSelected = 0;

  final List<String> columns = ["Имя", "Текст", "Время"];
  final List<String> modeOptions = [
    "Все",
    "Аварии",
    "Предупреждения",
    "Блокировки",
  ];
  final List<String> modeOptionsForQuery = [
    "SELECT * FROM uniset.main_messages_aps",
    "SELECT * FROM uniset.main_messages_alarm",
    "SELECT * FROM uniset.main_messages_warning",
    "SELECT * FROM uniset.main_messages_blocking",
  ];

  @override
  void initState() {
    super.initState();
    fetchData();
    _timer = Timer.periodic(
      const Duration(milliseconds: 1000),
      (_) => fetchData(),
    );
  }

  Future<void> fetchData() async {
    try {
      final queryUrl =
          "${DataProvider.getMsgsUrl()}${modeOptionsForQuery[typeSelected]} ORDER BY timestamp DESC LIMIT $rowCount FORMAT JSON";
      final response = await http.get(Uri.parse(queryUrl));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
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
    final List<Map<String, String>> tableData = data.map((item) {
      return {
        "Имя": item['name']?.toString() ?? "-",
        "Текст": item['message']?.toString() ?? "-",
        "Время": item['timestamp'] != null
            ? DateFormat('dd.MM HH:mm:ss').format(
                DateTime.parse(
                  item['timestamp'],
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Текущие сообщения',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                CustomDropdown<int>(
                  width: 200,
                  height: 50,
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
              ],
            ),
            const SizedBox(height: 16),

            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: ColorManager.primaryBackground,
                  border: Border.all(color: ColorManager.text, width: 2.0),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: CustomTable(data: tableData, columns: columns),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
