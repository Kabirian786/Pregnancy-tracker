import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../core/constants/app_constants.dart';
import '../core/utils/date_utils.dart';
import '../services/hive_service.dart';

/// روزانہ چیک لسٹ پرووائیڈر - ہر ٹاسک تاریخ کے حساب سے محفوظ ہوتا ہے اور خودکار save ہوتا ہے
class ChecklistProvider extends ChangeNotifier {
  Box get _box => HiveService.box(AppConstants.checklistBox);

  int get totalTaskCount {
    int count = 0;
    for (final section in AppConstants.checklistSections.values) {
      count += section.length;
    }
    return count;
  }

  Map<String, bool> _dayMap(String dateKey) {
    final raw = _box.get(dateKey);
    if (raw == null) return {};
    return Map<String, bool>.from(raw as Map);
  }

  bool isChecked(DateTime date, String taskId) {
    final map = _dayMap(AppDateUtils.dateKey(date));
    return map[taskId] ?? false;
  }

  void toggleTask(DateTime date, String taskId, bool value) {
    final key = AppDateUtils.dateKey(date);
    final map = _dayMap(key);
    map[taskId] = value;
    _box.put(key, map);
    notifyListeners();
  }

  int completedCount(DateTime date) {
    final map = _dayMap(AppDateUtils.dateKey(date));
    return map.values.where((v) => v == true).length;
  }

  double progressPercent(DateTime date) {
    if (totalTaskCount == 0) return 0;
    return (completedCount(date) / totalTaskCount) * 100;
  }

  /// ایک تاریخ کی تمام چیک لسٹ صاف کریں
  void resetDay(DateTime date) {
    _box.delete(AppDateUtils.dateKey(date));
    notifyListeners();
  }
}
