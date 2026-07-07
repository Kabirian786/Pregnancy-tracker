import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../core/constants/app_constants.dart';
import '../services/hive_service.dart';
import '../services/notification_service.dart';

class AppointmentModel {
  final String id;
  final String doctorName;
  final String hospital;
  final DateTime dateTime;
  final String notes;

  AppointmentModel({
    required this.id,
    required this.doctorName,
    required this.hospital,
    required this.dateTime,
    required this.notes,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'doctorName': doctorName,
        'hospital': hospital,
        'dateTime': dateTime.toIso8601String(),
        'notes': notes,
      };

  factory AppointmentModel.fromMap(Map map) => AppointmentModel(
        id: map['id'] as String,
        doctorName: map['doctorName'] as String,
        hospital: map['hospital'] as String,
        dateTime: DateTime.parse(map['dateTime'] as String),
        notes: map['notes'] as String? ?? '',
      );
}

/// ڈاکٹر اپائنٹمنٹ پرووائیڈر
class AppointmentProvider extends ChangeNotifier {
  Box get _box => HiveService.box(AppConstants.appointmentBox);

  List<AppointmentModel> get appointments {
    final raw = _box.get('list', defaultValue: []) as List;
    final list = raw.map((e) => AppointmentModel.fromMap(Map.from(e as Map))).toList();
    list.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    return list;
  }

  List<AppointmentModel> get upcoming =>
      appointments.where((a) => a.dateTime.isAfter(DateTime.now())).toList();

  void _save(List<AppointmentModel> list) {
    _box.put('list', list.map((e) => e.toMap()).toList());
    notifyListeners();
  }

  Future<void> addAppointment(AppointmentModel appointment) async {
    final list = appointments..add(appointment);
    _save(list);

    // ایک دن پہلے یاد دہانی
    final dayBefore = appointment.dateTime.subtract(const Duration(days: 1));
    await NotificationService.instance.scheduleOneTime(
      id: appointment.id.hashCode,
      title: 'اپائنٹمنٹ کی یاد دہانی',
      body: 'کل ${appointment.doctorName} کے ساتھ اپائنٹمنٹ ہے - ${appointment.hospital}',
      dateTime: dayBefore,
    );
    // خود دن پر یاد دہانی
    await NotificationService.instance.scheduleOneTime(
      id: appointment.id.hashCode + 1,
      title: 'آج اپائنٹمنٹ ہے',
      body: 'آج ${appointment.doctorName} کے ساتھ اپائنٹمنٹ ہے - ${appointment.hospital}',
      dateTime: appointment.dateTime.subtract(const Duration(hours: 2)),
    );
  }

  Future<void> deleteAppointment(String id) async {
    final list = appointments..removeWhere((a) => a.id == id);
    _save(list);
    await NotificationService.instance.cancel(id.hashCode);
    await NotificationService.instance.cancel(id.hashCode + 1);
  }
}
