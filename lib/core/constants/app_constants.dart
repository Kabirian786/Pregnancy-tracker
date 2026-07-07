/// مرکزی کانسٹنٹس - بکس کے نام، ڈیفالٹ ویلیوز وغیرہ
class AppConstants {
  AppConstants._();

  // ---------------- Hive Box Names ----------------
  static const String settingsBox = 'settings_box';
  static const String pregnancyBox = 'pregnancy_box';
  static const String checklistBox = 'checklist_box'; // key: yyyy-MM-dd -> Map<taskId,bool>
  static const String waterBox = 'water_box'; // key: yyyy-MM-dd -> int glasses
  static const String medicineListBox = 'medicine_list_box'; // list of medicine maps
  static const String medicineLogBox = 'medicine_log_box'; // key yyyy-MM-dd -> list of logs
  static const String appointmentBox = 'appointment_box'; // list of appointment maps
  static const String weightBox = 'weight_box'; // list of weight entries
  static const String bpBox = 'bp_box'; // list of bp entries
  static const String notesBox = 'notes_box'; // list of notes

  // ---------------- Settings Keys ----------------
  static const String keyThemeMode = 'theme_mode'; // 'light' | 'dark'
  static const String keyFontScale = 'font_scale'; // double
  static const String keyLmpDate = 'lmp_date';
  static const String keyPregnancyWeek = 'pregnancy_week';
  static const String keyMotherName = 'mother_name';

  static const int waterDailyTarget = 10;

  // ---------------- Daily Checklist Structure ----------------
  // ہر سیکشن کے اندر ٹاسک آئی ڈی اور عنوان
  static const Map<String, List<Map<String, String>>> checklistSections = {
    'صبح': [
      {'id': 'fajr', 'title': 'فجر کی نماز'},
      {'id': 'water_morning', 'title': '1 سے 2 گلاس پانی'},
      {'id': 'breakfast', 'title': 'صحت مند ناشتہ'},
      {'id': 'neevo', 'title': 'Neevo دوا'},
    ],
    'وسط صبح': [
      {'id': 'fruit_morning', 'title': 'ایک پھل'},
      {'id': 'water_mid_morning', 'title': 'پانی'},
    ],
    'دوپہر کا کھانا': [
      {'id': 'lunch', 'title': 'دوپہر کا کھانا'},
      {'id': 'salad', 'title': 'سلاد'},
      {'id': 'water_lunch', 'title': 'پانی'},
    ],
    'شام': [
      {'id': 'walk', 'title': '20 تا 30 منٹ واک'},
      {'id': 'snack_evening', 'title': 'ہلکا سنیک'},
      {'id': 'water_evening', 'title': 'پانی'},
    ],
    'رات کا کھانا': [
      {'id': 'dinner', 'title': 'رات کا کھانا'},
      {'id': 'superfort', 'title': 'Superfort دوا'},
    ],
    'سونے سے پہلے': [
      {'id': 'milk', 'title': 'ایک گلاس دودھ'},
      {'id': 'sleep_time', 'title': 'بروقت سونا'},
    ],
    'روزانہ اہداف': [
      {'id': 'target_water', 'title': '8 تا 10 گلاس پانی'},
      {'id': 'target_fruit', 'title': 'کم از کم دو پھل'},
      {'id': 'target_veg', 'title': 'سبزی'},
      {'id': 'target_sleep', 'title': '7 تا 9 گھنٹے نیند'},
      {'id': 'no_heavy_lift', 'title': 'بھاری وزن نہ اٹھائیں'},
      {'id': 'no_long_stand', 'title': 'زیادہ دیر مسلسل کھڑے نہ رہیں'},
    ],
  };

  static const List<String> emergencySigns = [
    'خون آنا',
    'شدید درد',
    'پانی آنا',
    'تیز بخار',
    'شدید الٹیاں',
    'بچے کی حرکت کم ہونا',
  ];

  static const String emergencyNumber = '1122';

  static const List<String> motivationalMessages = [
    'اے اللہ! میری اور میرے بچے کی حفاظت فرما۔ (آمین)',
    'صبر اور دعا کے ساتھ ہر مشکل آسان ہو جاتی ہے۔',
    'نبی کریمﷺ نے فرمایا: ماں کی تکلیف اللہ کے نزدیک بہت بڑی نیکی ہے۔',
    'اللہ تعالیٰ نے فرمایا: "بے شک ہم نے انسان کو مشکل میں پیدا کیا" — آپ کی ہمت قابلِ تعریف ہے۔',
    'ہر سانس کے ساتھ اپنے بچے کے لیے دعا کریں، اللہ سننے والا ہے۔',
    'آپ کا صبر اور محبت آپ کے بچے کی سب سے بڑی نعمت ہے۔',
    'اللہ پر بھروسہ رکھیں، وہ بہترین منصوبہ ساز ہے۔',
  ];
}
