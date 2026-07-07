import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../core/constants/app_constants.dart';
import '../services/hive_service.dart';

/// حمل کے ہفتہ اور ماں کے متعلق بنیادی معلومات کا پرووائیڈر
class PregnancyProvider extends ChangeNotifier {
  Box get _box => HiveService.box(AppConstants.pregnancyBox);

  DateTime? get lmpDate {
    final v = _box.get(AppConstants.keyLmpDate);
    if (v == null) return null;
    return DateTime.tryParse(v as String);
  }

  String get motherName => _box.get(AppConstants.keyMotherName, defaultValue: '') as String;

  void setMotherName(String name) {
    _box.put(AppConstants.keyMotherName, name);
    notifyListeners();
  }

  /// اگر LMP سیٹ ہو تو اس سے ہفتہ نکالیں، ورنہ مینوئل ہفتہ استعمال کریں
  int get currentWeek {
    final lmp = lmpDate;
    if (lmp != null) {
      final days = DateTime.now().difference(lmp).inDays;
      final week = (days / 7).floor();
      return week.clamp(1, 42);
    }
    final manual = _box.get(AppConstants.keyPregnancyWeek, defaultValue: 1);
    return (manual as num).toInt().clamp(1, 42);
  }

  /// حمل کی مکمل تاریخ (280 دن / 40 ہفتے سے تخمینی زچگی کی تاریخ)
  DateTime? get estimatedDueDate {
    final lmp = lmpDate;
    if (lmp == null) return null;
    return lmp.add(const Duration(days: 280));
  }

  double get progressPercent => (currentWeek / 40 * 100).clamp(0, 100);

  void setLmpDate(DateTime date) {
    _box.put(AppConstants.keyLmpDate, date.toIso8601String());
    notifyListeners();
  }

  void setManualWeek(int week) {
    _box.delete(AppConstants.keyLmpDate); // manual week overrides LMP calc
    _box.put(AppConstants.keyPregnancyWeek, week);
    notifyListeners();
  }

  void clearLmp() {
    _box.delete(AppConstants.keyLmpDate);
    notifyListeners();
  }
}
