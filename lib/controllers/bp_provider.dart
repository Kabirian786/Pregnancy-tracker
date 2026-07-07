import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../core/constants/app_constants.dart';
import '../services/hive_service.dart';

class BpEntry {
  final String id;
  final int systolic;
  final int diastolic;
  final int pulse;
  final DateTime date;

  BpEntry({
    required this.id,
    required this.systolic,
    required this.diastolic,
    required this.pulse,
    required this.date,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'systolic': systolic,
        'diastolic': diastolic,
        'pulse': pulse,
        'date': date.toIso8601String(),
      };

  factory BpEntry.fromMap(Map map) => BpEntry(
        id: map['id'] as String,
        systolic: (map['systolic'] as num).toInt(),
        diastolic: (map['diastolic'] as num).toInt(),
        pulse: (map['pulse'] as num).toInt(),
        date: DateTime.parse(map['date'] as String),
      );

  bool get isHigh => systolic >= 140 || diastolic >= 90;
}

/// بلڈ پریشر ٹریکر پرووائیڈر
class BpProvider extends ChangeNotifier {
  Box get _box => HiveService.box(AppConstants.bpBox);

  List<BpEntry> get entries {
    final raw = _box.get('list', defaultValue: []) as List;
    final list = raw.map((e) => BpEntry.fromMap(Map.from(e as Map))).toList();
    list.sort((a, b) => a.date.compareTo(b.date));
    return list;
  }

  void addEntry({required int systolic, required int diastolic, required int pulse, required DateTime date}) {
    final list = entries
      ..add(BpEntry(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        systolic: systolic,
        diastolic: diastolic,
        pulse: pulse,
        date: date,
      ));
    _box.put('list', list.map((e) => e.toMap()).toList());
    notifyListeners();
  }

  void deleteEntry(String id) {
    final list = entries..removeWhere((e) => e.id == id);
    _box.put('list', list.map((e) => e.toMap()).toList());
    notifyListeners();
  }

  BpEntry? get latest => entries.isEmpty ? null : entries.last;
}
