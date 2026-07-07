import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../core/constants/app_constants.dart';
import '../core/utils/date_utils.dart';
import '../services/hive_service.dart';

/// پانی ٹریکر پرووائیڈر - روزانہ گلاسز شمار، آدھی رات کو خودکار ری سیٹ (تاریخ کی بنیاد پر)
class WaterProvider extends ChangeNotifier {
  Box get _box => HiveService.box(AppConstants.waterBox);

  int glassesFor(DateTime date) {
    final key = AppDateUtils.dateKey(date);
    return (_box.get(key, defaultValue: 0) as num).toInt();
  }

  int get todayGlasses => glassesFor(DateTime.now());

  void addGlass() {
    final key = AppDateUtils.dateKey(DateTime.now());
    final current = (_box.get(key, defaultValue: 0) as num).toInt();
    _box.put(key, current + 1);
    notifyListeners();
  }

  void removeGlass() {
    final key = AppDateUtils.dateKey(DateTime.now());
    final current = (_box.get(key, defaultValue: 0) as num).toInt();
    if (current > 0) {
      _box.put(key, current - 1);
      notifyListeners();
    }
  }

  double get todayProgress => (todayGlasses / AppConstants.waterDailyTarget).clamp(0, 1).toDouble();

  /// پچھلے 7 دنوں کا اعدادوشمار (تاریخ -> گلاسز)
  Map<DateTime, int> weeklyStats() {
    final days = AppDateUtils.lastNDays(7);
    return {for (final d in days) d: glassesFor(d)};
  }
}
