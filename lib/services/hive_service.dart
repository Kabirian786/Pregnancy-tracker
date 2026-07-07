import 'package:hive_flutter/hive_flutter.dart';
import '../core/constants/app_constants.dart';

/// Hive بکس کھولنے اور ابتدائی سیٹ اپ کے لیے سروس۔
/// کوئی کوڈجن (build_runner) درکار نہیں - صرف پرائمیٹو/میپ ڈیٹا اسٹور ہوتا ہے۔
class HiveService {
  static Future<void> init() async {
    await Hive.initFlutter();
    await Future.wait([
      Hive.openBox(AppConstants.settingsBox),
      Hive.openBox(AppConstants.pregnancyBox),
      Hive.openBox(AppConstants.checklistBox),
      Hive.openBox(AppConstants.waterBox),
      Hive.openBox(AppConstants.medicineListBox),
      Hive.openBox(AppConstants.medicineLogBox),
      Hive.openBox(AppConstants.appointmentBox),
      Hive.openBox(AppConstants.weightBox),
      Hive.openBox(AppConstants.bpBox),
      Hive.openBox(AppConstants.notesBox),
    ]);
  }

  static Box box(String name) => Hive.box(name);
}
