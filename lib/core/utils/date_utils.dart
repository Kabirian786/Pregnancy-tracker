import 'package:intl/intl.dart';

/// تاریخ سے متعلقہ مدد گار فنکشنز
class AppDateUtils {
  AppDateUtils._();

  static String dateKey(DateTime date) => DateFormat('yyyy-MM-dd').format(date);

  static String urduDate(DateTime date) {
    const months = [
      'جنوری', 'فروری', 'مارچ', 'اپریل', 'مئی', 'جون',
      'جولائی', 'اگست', 'ستمبر', 'اکتوبر', 'نومبر', 'دسمبر'
    ];
    const weekdays = [
      'پیر', 'منگل', 'بدھ', 'جمعرات', 'جمعہ', 'ہفتہ', 'اتوار'
    ];
    final weekday = weekdays[date.weekday - 1];
    return '$weekday، ${date.day} ${months[date.month - 1]} ${date.year}';
  }

  static bool isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  static List<DateTime> lastNDays(int n) {
    final today = DateTime.now();
    return List.generate(n, (i) => DateTime(today.year, today.month, today.day - (n - 1 - i)));
  }
}
