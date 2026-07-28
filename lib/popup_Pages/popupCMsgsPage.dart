import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../dataProvider.dart';
import '../popup_page_widgets/customPopupPage.dart';
import '../popup_page_widgets/popupPageBlock.dart';
import '../widgets/customTable.dart';

enum QueryType { all, avarii, warning, block }

class PopupCMsgsPage extends StatefulWidget {
  final QueryType queryType;
  const PopupCMsgsPage({super.key, required this.queryType});

  @override
  State<PopupCMsgsPage> createState() => _PopupCMsgsPageState();
}

class _PopupCMsgsPageState extends State<PopupCMsgsPage> {
  List<Map<String, dynamic>> data = [];
  late Timer _timer;

  final List<String> modeOptionsForQuery = [
    "SELECT * FROM (SELECT * FROM uniset.main_messages_alarm UNION ALL SELECT * FROM uniset.main_messages_warning UNION ALL SELECT * FROM uniset.main_messages_blocking) AS combined_messages",
    "SELECT * FROM uniset.main_messages_alarm",
    "SELECT * FROM uniset.main_messages_warning",
    "SELECT * FROM uniset.main_messages_blocking",
  ];

  final List<String> columns = ["Имя", "Сообщение", "Время"];

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(
      const Duration(milliseconds: 1000),
      (_) => fetchData(),
    );

    fetchData();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(
        Uri.parse(
          "${DataProvider.baseMsgsUrl}${modeOptionsForQuery[widget.queryType.index]} ORDER BY timestamp DESC FORMAT JSON",
        ),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse.containsKey("data") && mounted) {
          setState(
            () => data = List<Map<String, dynamic>>.from(jsonResponse["data"]),
          );
        }
      }
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  String titlePckr() {
    switch (widget.queryType) {
      case QueryType.avarii:
        return 'Аварии';
      case QueryType.warning:
        return 'Предупреждения';
      case QueryType.block:
        return 'Блокировки';
      case QueryType.all:
        return 'Сообщения';
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> tableData = data.map((item) {
      return {
        "Имя": item['name']?.toString() ?? "-",
        "Сообщение": item['message']?.toString() ?? "-",
        "Время": item['timestamp'] != null
            ? DateFormat('dd.MM HH:mm:ss').format(
                DateTime.parse(item['timestamp']).add(DateTime.now().timeZoneOffset),
              )
            : "-",
      };
    }).toList();

    return CustomPopupPage(
      title: titlePckr(),
      widgetStack: [
        PopupPageBlock(
          widgetStack: [
            CustomTable(
              data: tableData,
              columns: columns, 
            ),
          ],
        ),
      ],
    );
  }
}