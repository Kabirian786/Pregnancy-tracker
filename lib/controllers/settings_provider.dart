import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import '../core/constants/app_constants.dart';
import '../services/hive_service.dart';

/// سیٹنگز پرووائیڈر - تھیم، فونٹ سائز، بیک اپ/ریسٹور
class SettingsProvider extends ChangeNotifier {
  Box get _box => HiveService.box(AppConstants.settingsBox);

  ThemeMode get themeMode {
    final v = _box.get(AppConstants.keyThemeMode, defaultValue: 'light');
    return v == 'dark' ? ThemeMode.dark : ThemeMode.light;
  }

  double get fontScale => (_box.get(AppConstants.keyFontScale, defaultValue: 1.0) as num).toDouble();

  void setDarkMode(bool isDark) {
    _box.put(AppConstants.keyThemeMode, isDark ? 'dark' : 'light');
    notifyListeners();
  }

  void setFontScale(double scale) {
    _box.put(AppConstants.keyFontScale, scale);
    notifyListeners();
  }

  /// تمام باکسز کا ڈیٹا ایک JSON فائل میں ایکسپورٹ کریں
  Future<File> backupToFile() async {
    final data = <String, dynamic>{};
    for (final boxName in [
      AppConstants.settingsBox,
      AppConstants.pregnancyBox,
      AppConstants.checklistBox,
      AppConstants.waterBox,
      AppConstants.medicineListBox,
      AppConstants.medicineLogBox,
      AppConstants.appointmentBox,
      AppConstants.weightBox,
      AppConstants.bpBox,
      AppConstants.notesBox,
    ]) {
      final box = HiveService.box(boxName);
      data[boxName] = box.toMap().map((k, v) => MapEntry(k.toString(), v));
    }
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/naheed_backup_${DateTime.now().millisecondsSinceEpoch}.json');
    await file.writeAsString(jsonEncode(data));
    return file;
  }

  /// بیک اپ فائل سے ڈیٹا واپس لائیں
  Future<void> restoreFromFile(File file) async {
    final content = await file.readAsString();
    final Map<String, dynamic> data = jsonDecode(content);
    for (final entry in data.entries) {
      final box = HiveService.box(entry.key);
      await box.clear();
      final Map<String, dynamic> boxData = Map<String, dynamic>.from(entry.value as Map);
      await box.putAll(boxData);
    }
    notifyListeners();
  }
}
