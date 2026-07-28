import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';

import '../components/colorManager.dart';
import '../dataProvider.dart';
import '../popup_Pages/popupDatePicker.dart';
import '../popup_page_widgets/customPopupPage.dart';
import '../widgets/customButton.dart';
import '../widgets/customCheckbox.dart';
import '../widgets/customGraph.dart';

// ─── Sensor model ─────────────────────────────────────────────────────────────

class _SensorDef {
  final String id;
  final String dbName;
  final String shortLabel;
  final String displayName;

  const _SensorDef({
    required this.id,
    required this.dbName,
    required this.shortLabel,
    required this.displayName,
  });
}

class _SensorGroup {
  final String id;
  final String label;
  final List<_SensorDef> sensors;

  const _SensorGroup({
    required this.id,
    required this.label,
    required this.sensors,
  });
}

class _SensorSection {
  final String title;
  final List<_SensorGroup> groups;

  const _SensorSection({required this.title, required this.groups});
}

// ─── ADD / REMOVE sensors here ────────────────────────────────────────────────
// To add a sensor:  add a _SensorDef to the sensors list of the right group.
// To add a group:   add a _SensorGroup to the groups list of the right section.
// To add a section: add a _SensorSection to _kSections below.

const List<_SensorSection> _kSections = [
  _SensorSection(
    title: 'ГДГ',
    groups: [
      _SensorGroup(
        id: 'gdg1',
        label: 'ГДГ1',
        sensors: [
          _SensorDef(
            id: 'gdg1_ap',
            dbName: 'SES1_SG1_KaskadM_ActivePower',
            shortLabel: 'Акт. Мощность',
            displayName: 'Акт. Мощность ГДГ1',
          ),
          _SensorDef(
            id: 'gdg1_rp',
            dbName: 'SES1_SG1_ReservPower',
            shortLabel: 'Резерв мощности',
            displayName: 'Резерв мощности ГДГ1',
          ),
          _SensorDef(
            id: 'gdg1_ia',
            dbName: 'SES1_SG1_KaskadM_EACurrentPhaseA',
            shortLabel: 'Ток U',
            displayName: 'Ток U ГДГ1',
          ),
          _SensorDef(
            id: 'gdg1_ib',
            dbName: 'SES1_SG1_KaskadM_EACurrentPhaseB',
            shortLabel: 'Ток V',
            displayName: 'Ток V ГДГ1',
          ),
          _SensorDef(
            id: 'gdg1_ic',
            dbName: 'SES1_SG1_KaskadM_EACurrentPhaseC',
            shortLabel: 'Ток W',
            displayName: 'Ток W ГДГ1',
          ),
          _SensorDef(
            id: 'gdg1_v',
            dbName: 'SES1_SG1_KaskadM_MainsVoltage',
            shortLabel: 'Напряжение',
            displayName: 'Напряжение ГДГ1',
          ),
          _SensorDef(
            id: 'gdg1_f',
            dbName: 'SES1_SG1_KaskadM_MainsFrequency',
            shortLabel: 'Частота',
            displayName: 'Частота ГДГ1',
          ),
          _SensorDef(
            id: 'gdg1_pf',
            dbName: 'SES1_SG1_PF',
            shortLabel: 'PF',
            displayName: 'PF ГДГ1',
          ),
          _SensorDef(
            id: 'gdg1_qp',
            dbName: 'SES1_SG1_KaskadM_ReactivePower',
            shortLabel: 'Реакт. Мощность',
            displayName: 'Реакт. Мощность ГДГ1',
          ),
          _SensorDef(
            id: 'gdg1_fp',
            dbName: 'SES1_SG1_KaskadM_FullPower',
            shortLabel: 'Полная Мощность',
            displayName: 'Полная Мощность ГДГ1',
          ),
        ],
      ),
      _SensorGroup(
        id: 'gdg2',
        label: 'ГДГ2',
        sensors: [
          _SensorDef(
            id: 'gdg2_ap',
            dbName: 'SES1_SG2_KaskadM_ActivePower',
            shortLabel: 'Акт. Мощность',
            displayName: 'Акт. Мощность ГДГ2',
          ),
          _SensorDef(
            id: 'gdg2_rp',
            dbName: 'SES1_SG2_ReservPower',
            shortLabel: 'Резерв мощности',
            displayName: 'Резерв мощности ГДГ2',
          ),
          _SensorDef(
            id: 'gdg2_ia',
            dbName: 'SES1_SG2_KaskadM_EACurrentPhaseA',
            shortLabel: 'Ток U',
            displayName: 'Ток U ГДГ2',
          ),
          _SensorDef(
            id: 'gdg2_ib',
            dbName: 'SES1_SG2_KaskadM_EACurrentPhaseB',
            shortLabel: 'Ток V',
            displayName: 'Ток V ГДГ2',
          ),
          _SensorDef(
            id: 'gdg2_ic',
            dbName: 'SES1_SG2_KaskadM_EACurrentPhaseC',
            shortLabel: 'Ток W',
            displayName: 'Ток W ГДГ2',
          ),
          _SensorDef(
            id: 'gdg2_v',
            dbName: 'SES1_SG2_KaskadM_MainsVoltage',
            shortLabel: 'Напряжение',
            displayName: 'Напряжение ГДГ2',
          ),
          _SensorDef(
            id: 'gdg2_f',
            dbName: 'SES1_SG2_KaskadM_MainsFrequency',
            shortLabel: 'Частота',
            displayName: 'Частота ГДГ2',
          ),
          _SensorDef(
            id: 'gdg2_pf',
            dbName: 'SES1_SG2_PF',
            shortLabel: 'PF',
            displayName: 'PF ГДГ2',
          ),
          _SensorDef(
            id: 'gdg2_qp',
            dbName: 'SES1_SG2_KaskadM_ReactivePower',
            shortLabel: 'Реакт. Мощность',
            displayName: 'Реакт. Мощность ГДГ2',
          ),
          _SensorDef(
            id: 'gdg2_fp',
            dbName: 'SES1_SG2_KaskadM_FullPower',
            shortLabel: 'Полная Мощность',
            displayName: 'Полная Мощность ГДГ2',
          ),
        ],
      ),
      _SensorGroup(
        id: 'gdg3',
        label: 'ГДГ3',
        sensors: [
          _SensorDef(
            id: 'gdg3_ap',
            dbName: 'SES2_SG3_KaskadM_ActivePower',
            shortLabel: 'Акт. Мощность',
            displayName: 'Акт. Мощность ГДГ3',
          ),
          _SensorDef(
            id: 'gdg3_rp',
            dbName: 'SES2_SG3_ReservPower',
            shortLabel: 'Резерв мощности',
            displayName: 'Резерв мощности ГДГ3',
          ),
          _SensorDef(
            id: 'gdg3_ia',
            dbName: 'SES2_SG3_KaskadM_EACurrentPhaseA',
            shortLabel: 'Ток U',
            displayName: 'Ток U ГДГ3',
          ),
          _SensorDef(
            id: 'gdg3_ib',
            dbName: 'SES2_SG3_KaskadM_EACurrentPhaseB',
            shortLabel: 'Ток V',
            displayName: 'Ток V ГДГ3',
          ),
          _SensorDef(
            id: 'gdg3_ic',
            dbName: 'SES2_SG3_KaskadM_EACurrentPhaseC',
            shortLabel: 'Ток W',
            displayName: 'Ток W ГДГ3',
          ),
          _SensorDef(
            id: 'gdg3_v',
            dbName: 'SES2_SG3_KaskadM_MainsVoltage',
            shortLabel: 'Напряжение',
            displayName: 'Напряжение ГДГ3',
          ),
          _SensorDef(
            id: 'gdg3_f',
            dbName: 'SES2_SG3_KaskadM_MainsFrequency',
            shortLabel: 'Частота',
            displayName: 'Частота ГДГ3',
          ),
          _SensorDef(
            id: 'gdg3_pf',
            dbName: 'SES2_SG3_PF',
            shortLabel: 'PF',
            displayName: 'PF ГДГ3',
          ),
          _SensorDef(
            id: 'gdg3_qp',
            dbName: 'SES2_SG3_KaskadM_ReactivePower',
            shortLabel: 'Реакт. Мощность',
            displayName: 'Реакт. Мощность ГДГ3',
          ),
          _SensorDef(
            id: 'gdg3_fp',
            dbName: 'SES2_SG3_KaskadM_FullPower',
            shortLabel: 'Полная Мощность',
            displayName: 'Полная Мощность ГДГ3',
          ),
        ],
      ),
      _SensorGroup(
        id: 'gdg4',
        label: 'ГДГ4',
        sensors: [
          _SensorDef(
            id: 'gdg4_ap',
            dbName: 'SES2_SG4_KaskadM_ActivePower',
            shortLabel: 'Акт. Мощность',
            displayName: 'Акт. Мощность ГДГ4',
          ),
          _SensorDef(
            id: 'gdg4_rp',
            dbName: 'SES2_SG4_ReservPower',
            shortLabel: 'Резерв мощности',
            displayName: 'Резерв мощности ГДГ4',
          ),
          _SensorDef(
            id: 'gdg4_ia',
            dbName: 'SES2_SG4_KaskadM_EACurrentPhaseA',
            shortLabel: 'Ток U',
            displayName: 'Ток U ГДГ4',
          ),
          _SensorDef(
            id: 'gdg4_ib',
            dbName: 'SES2_SG4_KaskadM_EACurrentPhaseB',
            shortLabel: 'Ток V',
            displayName: 'Ток V ГДГ4',
          ),
          _SensorDef(
            id: 'gdg4_ic',
            dbName: 'SES2_SG4_KaskadM_EACurrentPhaseC',
            shortLabel: 'Ток W',
            displayName: 'Ток W ГДГ4',
          ),
          _SensorDef(
            id: 'gdg4_v',
            dbName: 'SES2_SG4_KaskadM_MainsVoltage',
            shortLabel: 'Напряжение',
            displayName: 'Напряжение ГДГ4',
          ),
          _SensorDef(
            id: 'gdg4_f',
            dbName: 'SES2_SG4_KaskadM_MainsFrequency',
            shortLabel: 'Частота',
            displayName: 'Частота ГДГ4',
          ),
          _SensorDef(
            id: 'gdg4_pf',
            dbName: 'SES2_SG4_PF',
            shortLabel: 'PF',
            displayName: 'PF ГДГ4',
          ),
          _SensorDef(
            id: 'gdg4_qp',
            dbName: 'SES2_SG4_KaskadM_ReactivePower',
            shortLabel: 'Реакт. Мощность',
            displayName: 'Реакт. Мощность ГДГ4',
          ),
          _SensorDef(
            id: 'gdg4_fp',
            dbName: 'SES2_SG4_KaskadM_FullPower',
            shortLabel: 'Полная Мощность',
            displayName: 'Полная Мощность ГДГ4',
          ),
        ],
      ),
    ],
  ),
  _SensorSection(
    title: 'Нагрузка',
    groups: [
      _SensorGroup(
        id: 'lb',
        label: 'ЛБ',
        sensors: [
          _SensorDef(
            id: 'lb_t1',
            dbName: 'SES1_TSN1_S_Power',
            shortLabel: 'T1',
            displayName: 'Трансф. 1',
          ),
          _SensorDef(
            id: 'lb_ged1',
            dbName: 'SES1_FC1_ActivePower',
            shortLabel: 'ГЭД1',
            displayName: 'ГЭД 1',
          ),
          _SensorDef(
            id: 'lb_t7',
            dbName: 'SES1_TSN7_S_Power',
            shortLabel: 'T7',
            displayName: 'Трансф. 7',
          ),
          _SensorDef(
            id: 'lb_npu1',
            dbName: 'SES1_NPU1_ActivePower',
            shortLabel: 'НПУ1',
            displayName: 'НПУ 1',
          ),
        ],
      ),
      _SensorGroup(
        id: 'pb',
        label: 'ПБ',
        sensors: [
          _SensorDef(
            id: 'pb_t2',
            dbName: 'SES2_TSN2_S_Power',
            shortLabel: 'T2',
            displayName: 'Трансф. 2',
          ),
          _SensorDef(
            id: 'pb_ged2',
            dbName: 'SES2_FC2_ActivePower',
            shortLabel: 'ГЭД2',
            displayName: 'ГЭД 2',
          ),
          _SensorDef(
            id: 'pb_t8',
            dbName: 'SES2_TSN8_S_Power',
            shortLabel: 'T8',
            displayName: 'Трансф. 8',
          ),
          _SensorDef(
            id: 'pb_npu2',
            dbName: 'SES2_NPU2_ActivePower',
            shortLabel: 'НПУ2',
            displayName: 'НПУ 2',
          ),
        ],
      ),
    ],
  ),
];

// ─── GraphsPage ───────────────────────────────────────────────────────────────

class GraphsPage extends StatefulWidget {
  const GraphsPage({super.key});

  @override
  State<GraphsPage> createState() => _GraphsPageState();
}

class _GraphsPageState extends State<GraphsPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late StreamSubscription<Map<String, dynamic>> _sub;

  DateTime _startDate = DateTime.now().subtract(const Duration(days: 1));
  DateTime _endDate = DateTime.now();

  final Map<String, bool> _checked = {
    for (final sec in _kSections)
      for (final grp in sec.groups)
        for (final s in grp.sensors) s.id: false,
  };

  final Map<String, List<FlSpot>> _rawData = {};
  Map<String, List<FlSpot>> _graphData = {};

  @override
  void initState() {
    super.initState();
    _sub = DataProvider.stream.listen((_) => setState(() {}));
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  _SensorDef _findSensor(String id) {
    for (final sec in _kSections) {
      for (final grp in sec.groups) {
        for (final s in grp.sensors) {
          if (s.id == id) return s;
        }
      }
    }
    throw StateError('sensor $id not found');
  }

  // ── Sensor toggle (called from dialog) ────────────────────────────────────

  void _onSensorToggle(String sensorId, bool value) {
    setState(() => _checked[sensorId] = value);
    final s = _findSensor(sensorId);
    if (value) {
      _fetchSensor(s);
    } else {
      setState(() {
        _rawData.remove(s.displayName);
        _rebuildGraph();
      });
    }
  }

  // ── Data fetching ──────────────────────────────────────────────────────────

  Future<void> _fetchSensor(_SensorDef s) async {
    try {
      final tz = DateTime.now().timeZoneOffset;
      final start = _startDate.subtract(tz).toIso8601String().split('.')[0];
      final end = _endDate.subtract(tz).toIso8601String().split('.')[0];

      final url =
          "${DataProvider.getMsgsUrl()}SELECT timestamp, value FROM uniset.main_history WHERE name = '${s.dbName}' AND timestamp BETWEEN toDateTime64('$start', 6, 'UTC') AND toDateTime64('$end', 6, 'UTC') ORDER BY timestamp FORMAT JSON";
      final resp = await http.get(Uri.parse(url));

      if (resp.statusCode != 200) return;

      final json = jsonDecode(resp.body) as Map<String, dynamic>;
      final rows = json['data'] as List?;
      if (rows == null || rows.isEmpty) return;

      final tz2 = DateTime.now().timeZoneOffset;
      final spots = rows.map((r) {
        final ts = DateTime.parse(
          r['timestamp'] as String,
        ).add(tz2).millisecondsSinceEpoch.toDouble();
        return FlSpot(ts, (r['value'] as num).toDouble());
      }).toList();

      if (!mounted) return;
      setState(() {
        _rawData[s.displayName] = spots;
        _rebuildGraph();
      });
    } catch (e) {
      debugPrint('Graph fetch [${s.id}]: $e');
    }
  }

  Future<void> _refreshAll() async {
    setState(() {
      _rawData.clear();
      _graphData.clear();
    });
    for (final sec in _kSections) {
      for (final grp in sec.groups) {
        for (final s in grp.sensors) {
          if (_checked[s.id] == true) await _fetchSensor(s);
        }
      }
    }
  }

  void _rebuildGraph() {
    const target = 500;
    _graphData = {
      for (final e in _rawData.entries) e.key: _downsample(e.value, target),
    };
  }

  List<FlSpot> _downsample(List<FlSpot> pts, int target) {
    if (pts.length <= target) return pts;
    final step = (pts.length / target).ceil();
    final out = <FlSpot>[];
    for (int i = 0; i < pts.length; i += step) {
      out.add(pts[i]);
    }
    if (out.last.x != pts.last.x) out.add(pts.last);
    return out;
  }

  // ── Dialog launchers ───────────────────────────────────────────────────────

  void _openDatePicker() {
    showDialog<({DateTime begin, DateTime end})>(
      context: context,
      barrierDismissible: true,
      builder: (_) =>
          PopupDatePicker(initialBegin: _startDate, initialEnd: _endDate),
    ).then((result) {
      if (result != null) {
        setState(() {
          _startDate = result.begin;
          _endDate = result.end;
        });
        _refreshAll();
      }
    });
  }

  void _openSensorSelection() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => _SensorSelectionDialog(
        checked: Map.from(_checked),
        onToggle: _onSensorToggle,
      ),
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final startDt = _startDate.isBefore(_endDate)
        ? _startDate
        : _endDate.subtract(const Duration(hours: 1));

    return Scaffold(
      backgroundColor: ColorManager.primaryBackground,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CustomButton(
                  label: 'Выборка',
                  width: 400,
                  height: 50,
                  onPressed: _openSensorSelection,
                ),
                CustomButton(
                  label: 'Календарь',
                  width: 400,
                  height: 50,
                  onPressed: _openDatePicker,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _graphData.isEmpty
                  ? Center(
                      child: Text(
                        'Выберите датчики для отображения',
                        style: TextStyle(
                          color: ColorManager.text,
                          fontSize: 18,
                        ),
                      ),
                    )
                  : CustomGraph(
                      data: _graphData,
                      startTimestamp: startDt,
                      endTimestamp: _endDate,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Sensor selection dialog ──────────────────────────────────────────────────

class _SensorSelectionDialog extends StatefulWidget {
  final Map<String, bool> checked;
  final void Function(String sensorId, bool value) onToggle;

  const _SensorSelectionDialog({required this.checked, required this.onToggle});

  @override
  State<_SensorSelectionDialog> createState() => _SensorSelectionDialogState();
}

class _SensorSelectionDialogState extends State<_SensorSelectionDialog> {
  late final Map<String, bool> _checked = Map.from(widget.checked);

  static const int _maxLines = 10;

  int get _activeCount => _checked.values.where((v) => v).length;

  _SensorGroup _findGroup(String groupId) {
    for (final sec in _kSections) {
      for (final grp in sec.groups) {
        if (grp.id == groupId) return grp;
      }
    }
    throw StateError('group $groupId not found');
  }

  void _toggleSensor(String sensorId, bool value) {
    if (value && _activeCount >= _maxLines) return;
    setState(() => _checked[sensorId] = value);
    widget.onToggle(sensorId, value);
  }

  void _toggleGroup(String groupId, bool value) {
    final grp = _findGroup(groupId);
    if (value) {
      final alreadyActive = grp.sensors
          .where((s) => _checked[s.id] == true)
          .length;
      final toAdd = grp.sensors.length - alreadyActive;
      if (_activeCount + toAdd > _maxLines) return;
    }
    final toChange = value
        ? grp.sensors.where((s) => _checked[s.id] != true).toList()
        : grp.sensors.where((s) => _checked[s.id] == true).toList();

    setState(() {
      for (final s in grp.sensors) {
        _checked[s.id] = value;
      }
    });
    for (final s in toChange) {
      widget.onToggle(s.id, value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomPopupPage(
      title: 'Выборка датчиков',
      widgetStack: [
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            'Линий: $_activeCount / $_maxLines',
            style: TextStyle(color: ColorManager.text, fontSize: 14),
          ),
        ),
        const SizedBox(height: 12),
        for (final sec in _kSections) ...[
          _buildSection(sec),
          const SizedBox(height: 20),
        ],
      ],
    );
  }

  Widget _buildSection(_SensorSection sec) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (sec.title.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              sec.title,
              style: TextStyle(
                color: ColorManager.text,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: sec.groups.map(_buildGroupColumn).toList(),
        ),
      ],
    );
  }

  Widget _buildGroupColumn(_SensorGroup grp) {
    final allChecked = grp.sensors.every((s) => _checked[s.id] == true);
    return SizedBox(
      width: 230,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _checkRow(
            key: ValueKey('grp_${grp.id}_$allChecked'),
            label: grp.label,
            value: allChecked,
            isChild: false,
            isBlocked: false,
            onChanged: (v) => _toggleGroup(grp.id, v),
          ),
          ...grp.sensors.map((s) {
            final val = _checked[s.id] ?? false;
            return _checkRow(
              key: ValueKey('sensor_${s.id}_$val'),
              label: s.shortLabel,
              value: val,
              isChild: true,
              isBlocked: !val && _activeCount >= _maxLines,
              onChanged: (v) => _toggleSensor(s.id, v),
            );
          }),
        ],
      ),
    );
  }

  Widget _checkRow({
    required Key key,
    required String label,
    required bool value,
    required bool isChild,
    required bool isBlocked,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: EdgeInsets.only(left: isChild ? 30.0 : 0.0),
      child: Row(
        children: [
          CustomCheckbox(
            key: key,
            initialValue: value,
            isBlocked: isBlocked,
            size: isChild ? 28 : 36,
            onChanged: onChanged,
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              fontSize: isChild ? 18.0 : 21.0,
              fontWeight: isChild ? FontWeight.normal : FontWeight.bold,
              color: ColorManager.text,
            ),
          ),
        ],
      ),
    );
  }
}
