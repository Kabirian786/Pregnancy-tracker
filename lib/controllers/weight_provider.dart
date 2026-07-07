import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../core/constants/app_constants.dart';
import '../services/hive_service.dart';

class WeightEntry {
  final String id;
  final double weight;
  final DateTime date;

  WeightEntry({required this.id, required this.weight, required this.date});

  Map<String, dynamic> toMap() => {'id': id, 'weight': weight, 'date': date.toIso8601String()};

  factory WeightEntry.fromMap(Map map) => WeightEntry(
        id: map['id'] as String,
        weight: (map['weight'] as num).toDouble(),
        date: DateTime.parse(map['date'] as String),
      );
}

/// وزن ٹریکر پرووائیڈر
class WeightProvider extends ChangeNotifier {
  Box get _box => HiveService.box(AppConstants.weightBox);

  List<WeightEntry> get entries {
    final raw = _box.get('list', defaultValue: []) as List;
    final list = raw.map((e) => WeightEntry.fromMap(Map.from(e as Map))).toList();
    list.sort((a, b) => a.date.compareTo(b.date));
    return list;
  }

  void addEntry(double weight, DateTime date) {
    final list = entries
      ..add(WeightEntry(id: DateTime.now().microsecondsSinceEpoch.toString(), weight: weight, date: date));
    _box.put('list', list.map((e) => e.toMap()).toList());
    notifyListeners();
  }

  void deleteEntry(String id) {
    final list = entries..removeWhere((e) => e.id == id);
    _box.put('list', list.map((e) => e.toMap()).toList());
    notifyListeners();
  }

  double? get latestWeight => entries.isEmpty ? null : entries.last.weight;

  double? get weeklyChange {
    final list = entries;
    if (list.length < 2) return null;
    final weekAgo = DateTime.now().subtract(const Duration(days: 7));
    final past = list.where((e) => e.date.isBefore(weekAgo)).toList();
    if (past.isEmpty) return null;
    return list.last.weight - past.last.weight;
  }
}
