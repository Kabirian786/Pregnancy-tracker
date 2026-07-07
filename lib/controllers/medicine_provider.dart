import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../core/constants/app_constants.dart';
import '../core/utils/date_utils.dart';
import '../services/hive_service.dart';
import '../services/notification_service.dart';

/// ایک دوا کا ماڈل - نام اور یاد دہانی کا وقت
class MedicineModel {
  final String id;
  final String name;
  final int hour;
  final int minute;
  final bool reminderEnabled;

  MedicineModel({
    required this.id,
    required this.name,
    required this.hour,
    required this.minute,
    this.reminderEnabled = true,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'hour': hour,
        'minute': minute,
        'reminderEnabled': reminderEnabled,
      };

  factory MedicineModel.fromMap(Map map) => MedicineModel(
        id: map['id'] as String,
        name: map['name'] as String,
        hour: (map['hour'] as num).toInt(),
        minute: (map['minute'] as num).toInt(),
        reminderEnabled: map['reminderEnabled'] as bool? ?? true,
      );

  String get timeLabel {
    final h = hour % 12 == 0 ? 12 : hour % 12;
    final period = hour >= 12 ? 'شام' : 'صبح';
    return '$h:${minute.toString().padLeft(2, '0')} $period';
  }
}

/// دوا کی یاد دہانی پرووائیڈر
class MedicineProvider extends ChangeNotifier {
  Box get _listBox => HiveService.box(AppConstants.medicineListBox);
  Box get _logBox => HiveService.box(AppConstants.medicineLogBox);

  static const List<String> defaultMedicines = ['Neevo', 'Superfort'];

  List<MedicineModel> get medicines {
    final raw = _listBox.get('list');
    if (raw == null) {
      // پہلی بار دونوں ڈیفالٹ ادویات بنائیں
      final defaults = [
        MedicineModel(id: 'neevo', name: 'Neevo', hour: 8, minute: 0),
        MedicineModel(id: 'superfort', name: 'Superfort', hour: 21, minute: 0),
      ];
      _listBox.put('list', defaults.map((e) => e.toMap()).toList());
      return defaults;
    }
    final list = (raw as List).map((e) => MedicineModel.fromMap(Map.from(e as Map))).toList();
    return list;
  }

  void _saveList(List<MedicineModel> list) {
    _listBox.put('list', list.map((e) => e.toMap()).toList());
    notifyListeners();
  }

  Future<void> setReminderTime(String medicineId, int hour, int minute) async {
    final list = medicines;
    final idx = list.indexWhere((m) => m.id == medicineId);
    if (idx == -1) return;
    final updated = MedicineModel(
      id: list[idx].id,
      name: list[idx].name,
      hour: hour,
      minute: minute,
      reminderEnabled: list[idx].reminderEnabled,
    );
    list[idx] = updated;
    _saveList(list);
    await NotificationService.instance.scheduleDaily(
      id: medicineId.hashCode,
      title: 'دوا کی یاد دہانی',
      body: '${updated.name} دوا لینے کا وقت ہو گیا ہے',
      hour: hour,
      minute: minute,
    );
  }

  Future<void> toggleReminder(String medicineId, bool enabled) async {
    final list = medicines;
    final idx = list.indexWhere((m) => m.id == medicineId);
    if (idx == -1) return;
    final m = list[idx];
    list[idx] = MedicineModel(id: m.id, name: m.name, hour: m.hour, minute: m.minute, reminderEnabled: enabled);
    _saveList(list);
    if (enabled) {
      await NotificationService.instance.scheduleDaily(
        id: medicineId.hashCode,
        title: 'دوا کی یاد دہانی',
        body: '${m.name} دوا لینے کا وقت ہو گیا ہے',
        hour: m.hour,
        minute: m.minute,
      );
    } else {
      await NotificationService.instance.cancel(medicineId.hashCode);
    }
  }

  // --------- Log / History ---------
  List<Map> _dayLog(DateTime date) {
    final key = AppDateUtils.dateKey(date);
    final raw = _logBox.get(key);
    if (raw == null) return [];
    return List<Map>.from((raw as List).map((e) => Map.from(e as Map)));
  }

  bool isTakenToday(String medicineId) {
    final log = _dayLog(DateTime.now());
    return log.any((e) => e['medicineId'] == medicineId);
  }

  void markTaken(String medicineId, String medicineName) {
    final key = AppDateUtils.dateKey(DateTime.now());
    final log = _dayLog(DateTime.now());
    if (log.any((e) => e['medicineId'] == medicineId)) return;
    log.add({
      'medicineId': medicineId,
      'medicineName': medicineName,
      'time': DateTime.now().toIso8601String(),
    });
    _logBox.put(key, log);
    notifyListeners();
  }

  void unmarkTaken(String medicineId) {
    final key = AppDateUtils.dateKey(DateTime.now());
    final log = _dayLog(DateTime.now());
    log.removeWhere((e) => e['medicineId'] == medicineId);
    _logBox.put(key, log);
    notifyListeners();
  }

  /// پچھلے 14 دن کی ہسٹری بطور فہرست (تاریخ، دوا کا نام، وقت)
  List<Map<String, String>> history({int days = 14}) {
    final result = <Map<String, String>>[];
    for (final d in AppDateUtils.lastNDays(days).reversed) {
      final log = _dayLog(d);
      for (final entry in log) {
        result.add({
          'date': AppDateUtils.urduDate(d),
          'name': entry['medicineName'] as String,
          'time': DateTime.parse(entry['time'] as String).toString(),
        });
      }
    }
    return result;
  }
}
