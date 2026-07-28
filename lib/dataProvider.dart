import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class DataProvider {
  static Timer _timer = Timer.periodic(
    const Duration(milliseconds: 500),
    (_) => {},
  );

  static String baseGetUrl = '';
  static String baseSetUrl = '';
  static String baseMsgsUrl = '';
  static String domain = 'SES1'; // домен
  static String port = '8081'; // порт
  static String supplier = ''; // суплаер
  static final Map<String, dynamic> _data = {};
  static bool connectionFlag = false;

  static final StreamController<Map<String, dynamic>> _streamController =
      StreamController.broadcast();
  static Stream<Map<String, dynamic>> get stream => _streamController.stream;

  static Future<void> init() async {
    // ссылка на запрос датчиков
    baseGetUrl =
        'http://$domain:$port/api/v2/SharedMemory/get?supplier=$supplier&';
    // ссылка на изменение датчиков
    baseSetUrl =
        'http://$domain:$port/api/v2/SharedMemory/set?supplier=$supplier&';
    // ссылка на сообщения
    baseMsgsUrl = 'http://$domain:$port/?user=dbadmin&password=dbadmin&query=';

    // запись значений датчиков при старте имитатора
    await initSensorValues();

    _updateAllData();
    _timer = Timer.periodic(
      // частота опроса 500мс
      const Duration(milliseconds: 500),
      (_) => _updateAllData(),
    );
  }

  static void dispose() {
    _timer.cancel();
    _streamController.close();
  }

  static Future<void> initSensorValues() async {
    // здесь записывать значения датчиков при старте имитатора
    // await sendData('название датчика на сервере', 'значение');
    // (можно подвязать на кнопку для перезагрузки изначальных значений датчиков)
  }

  static Future<void> _updateAllData() async {
    try {
      final Map<String, dynamic> newData = {};

      // здесь вносить опрашиваемые датчики
      // ===== GDG_1 =====
      newData['GDG_1_power_active'] = await fetchData('');
      newData['GDG_1_power_full'] = await fetchData('');
      newData['GDG_1_power_reactive'] = await fetchData('');
      newData['GDG_1_freq'] = await fetchData('');
      newData['GDG_1_current_U'] = await fetchData('');
      newData['GDG_1_current_V'] = await fetchData('');
      newData['GDG_1_current_W'] = await fetchData('');
      newData['GDG_1_voltage'] = await fetchData('');
      newData['GDG_1_PF'] = await fetchData('');
      newData['GDG_1_power_reserve'] = await fetchData('');
      newData['GDG_1_state'] = await fetchData('');
      newData['GDG_1_isLocal'] = await fetchData('');
      newData['GDG_1_priority'] = await fetchData('');
      newData['GDG_1_current_power_limit'] = await fetchData('');
      newData['GDG_1_set_power_limit'] = await fetchData('');
      newData['GDG_1_auto'] = await fetchData('');
      newData['GDG_1_power_active_max'] = await fetchData('');
      newData['GDG_1_power_full_max'] = await fetchData('');
      newData['GDG_1_power_reactive_max'] = await fetchData('');
      newData['GDG_1_freq_max'] = await fetchData('');
      newData['GDG_1_current_U_max'] = await fetchData('');
      newData['GDG_1_current_V_max'] = await fetchData('');
      newData['GDG_1_current_W_max'] = await fetchData('');
      newData['GDG_1_voltage_max'] = await fetchData('');
      newData['GDG_1_power_reserve_min'] = await fetchData('');
      newData['GDG_1_power_reserve_max'] = await fetchData('');

      // ===== GDG_2 =====
      newData['GDG_2_power_active'] = await fetchData('');
      newData['GDG_2_power_full'] = await fetchData('');
      newData['GDG_2_power_reactive'] = await fetchData('');
      newData['GDG_2_freq'] = await fetchData('');
      newData['GDG_2_current_U'] = await fetchData('');
      newData['GDG_2_current_V'] = await fetchData('');
      newData['GDG_2_current_W'] = await fetchData('');
      newData['GDG_2_voltage'] = await fetchData('');
      newData['GDG_2_PF'] = await fetchData('');
      newData['GDG_2_power_reserve'] = await fetchData('');
      newData['GDG_2_state'] = await fetchData('');
      newData['GDG_2_isLocal'] = await fetchData('');
      newData['GDG_2_priority'] = await fetchData('');
      newData['GDG_2_current_power_limit'] = await fetchData('');
      newData['GDG_2_set_power_limit'] = await fetchData('');
      newData['GDG_2_auto'] = await fetchData('');
      newData['GDG_2_power_active_max'] = await fetchData('');
      newData['GDG_2_power_full_max'] = await fetchData('');
      newData['GDG_2_power_reactive_max'] = await fetchData('');
      newData['GDG_2_freq_max'] = await fetchData('');
      newData['GDG_2_current_U_max'] = await fetchData('');
      newData['GDG_2_current_V_max'] = await fetchData('');
      newData['GDG_2_current_W_max'] = await fetchData('');
      newData['GDG_2_voltage_max'] = await fetchData('');
      newData['GDG_2_power_reserve_min'] = await fetchData('');
      newData['GDG_2_power_reserve_max'] = await fetchData('');

      // ===== GDG_3 =====
      newData['GDG_3_power_active'] = await fetchData('');
      newData['GDG_3_power_full'] = await fetchData('');
      newData['GDG_3_power_reactive'] = await fetchData('');
      newData['GDG_3_freq'] = await fetchData('');
      newData['GDG_3_current_U'] = await fetchData('');
      newData['GDG_3_current_V'] = await fetchData('');
      newData['GDG_3_current_W'] = await fetchData('');
      newData['GDG_3_voltage'] = await fetchData('');
      newData['GDG_3_PF'] = await fetchData('');
      newData['GDG_3_power_reserve'] = await fetchData('');
      newData['GDG_3_state'] = await fetchData('');
      newData['GDG_3_isLocal'] = await fetchData('');
      newData['GDG_3_priority'] = await fetchData('');
      newData['GDG_3_current_power_limit'] = await fetchData('');
      newData['GDG_3_set_power_limit'] = await fetchData('');
      newData['GDG_3_auto'] = await fetchData('');
      newData['GDG_3_power_active_max'] = await fetchData('');
      newData['GDG_3_power_full_max'] = await fetchData('');
      newData['GDG_3_power_reactive_max'] = await fetchData('');
      newData['GDG_3_freq_max'] = await fetchData('');
      newData['GDG_3_current_U_max'] = await fetchData('');
      newData['GDG_3_current_V_max'] = await fetchData('');
      newData['GDG_3_current_W_max'] = await fetchData('');
      newData['GDG_3_voltage_max'] = await fetchData('');
      newData['GDG_3_power_reserve_min'] = await fetchData('');
      newData['GDG_3_power_reserve_max'] = await fetchData('');

      // ===== GDG_4 =====
      newData['GDG_4_power_active'] = await fetchData('');
      newData['GDG_4_power_full'] = await fetchData('');
      newData['GDG_4_power_reactive'] = await fetchData('');
      newData['GDG_4_freq'] = await fetchData('');
      newData['GDG_4_current_U'] = await fetchData('');
      newData['GDG_4_current_V'] = await fetchData('');
      newData['GDG_4_current_W'] = await fetchData('');
      newData['GDG_4_voltage'] = await fetchData('');
      newData['GDG_4_PF'] = await fetchData('');
      newData['GDG_4_power_reserve'] = await fetchData('');
      newData['GDG_4_state'] = await fetchData('');
      newData['GDG_4_isLocal'] = await fetchData('');
      newData['GDG_4_priority'] = await fetchData('');
      newData['GDG_4_current_power_limit'] = await fetchData('');
      newData['GDG_4_set_power_limit'] = await fetchData('');
      newData['GDG_4_auto'] = await fetchData('');
      newData['GDG_4_power_active_max'] = await fetchData('');
      newData['GDG_4_power_full_max'] = await fetchData('');
      newData['GDG_4_power_reactive_max'] = await fetchData('');
      newData['GDG_4_freq_max'] = await fetchData('');
      newData['GDG_4_current_U_max'] = await fetchData('');
      newData['GDG_4_current_V_max'] = await fetchData('');
      newData['GDG_4_current_W_max'] = await fetchData('');
      newData['GDG_4_voltage_max'] = await fetchData('');
      newData['GDG_4_power_reserve_min'] = await fetchData('');
      newData['GDG_4_power_reserve_max'] = await fetchData('');

      // ===== CB1 =====
      newData['CB1_state'] = await fetchData('');
      newData['CB1_isLocal'] = await fetchData('');

      // ===== T1 =====
      newData['T1_state'] = await fetchData('');
      newData['T1_power_active'] = await fetchData('');
      newData['T1_power_full'] = await fetchData('');

      // ===== T2 =====
      newData['T2_state'] = await fetchData('');
      newData['T2_power_active'] = await fetchData('');
      newData['T2_power_full'] = await fetchData('');

      // ===== T7 =====
      newData['T7_state'] = await fetchData('');
      newData['T7_power_active'] = await fetchData('');
      newData['T7_power_full'] = await fetchData('');

      // ===== T8 =====
      newData['T8_state'] = await fetchData('');
      newData['T8_power_active'] = await fetchData('');
      newData['T8_power_full'] = await fetchData('');

      // ===== GRSH690 =====
      newData['GRSH690_state'] = await fetchData('');
      newData['GRSH690_power'] = await fetchData('');
      newData['GRSH690_reserv'] = await fetchData('');

      // ===== FC1 =====
      newData['FC1_state'] = await fetchData('');
      newData['FC1_power'] = await fetchData('');
      newData['FC1_power_limitation'] = await fetchData('');

      // ===== FC2 =====
      newData['FC2_state'] = await fetchData('');
      newData['FC2_power'] = await fetchData('');
      newData['FC2_power_limitation'] = await fetchData('');

      // ===== PU1 =====
      newData['PU1_state'] = await fetchData('');
      newData['PU1_power'] = await fetchData('');
      newData['PU1_power_limitation'] = await fetchData('');

      // ===== PU2 =====
      newData['PU2_state'] = await fetchData('');
      newData['PU2_power'] = await fetchData('');
      newData['PU2_power_limitation'] = await fetchData('');

      // ===== SES =====
      newData['SES_mode_state'] = await fetchData('');
      newData['SES_mode_parking_ready'] = await fetchData('');
      newData['SES_mode_seagoing_ready'] = await fetchData('');
      newData['SES_mode_maneuver_ready'] = await fetchData('');
      newData['SES_mode_dynpos_ready'] = await fetchData('');
      newData['SES_min_gdg'] = await fetchData('');

      // ===== MSG =====
      newData['MSG_avarii_number'] = await fetchData('');
      newData['MSG_warning_number'] = await fetchData('');
      newData['MSG_block_number'] = await fetchData('');

      // ===== Power_max_limit_gdg / Time_wait =====
      newData['Power_max_limit_gdg_1'] = await fetchData('');
      newData['Time_wait_for_start_gdg_1'] = await fetchData('');
      newData['Time_wait_to_stop_gdg_1'] = await fetchData('');

      newData['Power_max_limit_gdg_2'] = await fetchData('');
      newData['Time_wait_for_start_gdg_2'] = await fetchData('');
      newData['Time_wait_to_stop_gdg_2'] = await fetchData('');

      newData['Power_max_limit_gdg_3'] = await fetchData('');
      newData['Time_wait_for_start_gdg_3'] = await fetchData('');
      newData['Time_wait_to_stop_gdg_3'] = await fetchData('');

      newData['Power_max_limit_gdg_4'] = await fetchData('');
      newData['Time_wait_for_start_gdg_4'] = await fetchData('');
      newData['Time_wait_to_stop_gdg_4'] = await fetchData('');

      _data.addAll(newData);

      // выполнить логику на основе полученных значений
      await applyLogic();

      _streamController.add(_data);
    } catch (e) {
      print('Error updating data: $e');
    }
  }

  static Future<void> applyLogic() async {
    // здесь вносить логику после изначального опроса
    // if (_data['название датчика'] == 1 && _data['название датчика'] == 0) {
    //   await sendData('название датчика', 'значение в строку');

    //   пример вычислений
    //   _data.addAll({
    //     'название датчика':
    //         (_data['название датчика'] + _data['название датчика']),
    //   });
    // }
  }

  static Future<dynamic> fetchData(String sensorName) async {
    try {
      final url = '$baseGetUrl$sensorName';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonMap = jsonDecode(response.body);

        if (jsonMap['ecode'] == 500) {
          print('sensor not found: $sensorName');
          return 0;
        }

        final sensors = jsonMap['sensors'] as List?;
        if (sensors == null || sensors.isEmpty) {
          throw Exception('No sensors data found for $sensorName');
        }

        final firstSensor = sensors[0] as Map<String, dynamic>;
        final calibration = firstSensor['calibration'] as Map<String, dynamic>?;
        final precision = calibration?['precision'] as int? ?? 0;
        final value = firstSensor['value'] as num? ?? 0;
        final result = value / pow(10, precision);

        connectionFlag = true;
        return result;
      } else {
        throw Exception('Failed to load $sensorName');
      }
    } on Exception catch (e) {
      print('Failed to load shared: $e');
      connectionFlag = false;
      return 0;
    }
  }

  static Future<void> sendData(String sensorName, String value) async {
    final url = '$baseSetUrl$sensorName';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
    } else {
      throw Exception('Failed to set $sensorName to $value');
    }
  }

  static String getSensorUrl() {
    return baseGetUrl;
  }

  static String getMsgsUrl() {
    return baseMsgsUrl;
  }

  static dynamic getSensorValue(String sensorName) {
    // -1 если датчика не существует
    return _data[sensorName] ?? 40;
  }

  // Типизированные геттеры: приводят значение к нужному типу при чтении.
  // Значения датчиков хранятся «сырыми» (num), тип решается здесь.

  // -1.0 если датчика не существует
  static double getDouble(String sensorName) =>
      (_data[sensorName] as num? ?? -1).toDouble();

  // -1 если датчика не существует
  static int getInt(String sensorName) =>
      (_data[sensorName] as num? ?? -1).toInt();

  // false если датчика не существует
  static bool getBool(String sensorName) =>
      (_data[sensorName] as num? ?? 0) != 0;

  // если флаг false значит сервер не доступен
  static bool isAppConnected() {
    return connectionFlag;
  }
}
