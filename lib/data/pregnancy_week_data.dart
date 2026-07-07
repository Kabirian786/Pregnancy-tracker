/// حمل کے ہفتہ وار معلومات کا ماڈل
class WeekInfo {
  final int week;
  final String babyDevelopment;
  final String motherChanges;
  final String tips;
  final List<String> foodsToEat;
  final List<String> foodsToAvoid;

  const WeekInfo({
    required this.week,
    required this.babyDevelopment,
    required this.motherChanges,
    required this.tips,
    required this.foodsToEat,
    required this.foodsToAvoid,
  });
}

/// عمومی خوراک کی ہدایات جو ہر ہفتے لاگو ہوتی ہیں
class PregnancyWeekData {
  PregnancyWeekData._();

  static const List<String> generalFoodsToEat = [
    'دودھ اور دودھ سے بنی اشیاء',
    'انڈے',
    'دالیں اور سبزیاں',
    'تازہ پھل',
    'خشک میوہ جات',
    'گوشت (اچھی طرح پکا ہوا)',
    'پانی کی وافر مقدار',
  ];

  static const List<String> generalFoodsToAvoid = [
    'کچا یا نیم پکا گوشت',
    'کچے انڈے',
    'زیادہ کیفین (چائے، کافی)',
    'زیادہ مصالحہ دار اور تیل والا کھانا',
    'غیر پاسچرائزڈ دودھ',
    'بازاری جوس اور کولڈ ڈرنکس',
    'زیادہ نمک والی اشیاء',
  ];

  /// ہفتہ نمبر کی بنیاد پر معلومات - ٹرائیمسٹر کے حساب سے گروپ بندی
  static WeekInfo getWeekInfo(int week) {
    final w = week.clamp(1, 42);
    if (w <= 12) {
      return _firstTrimester(w);
    } else if (w <= 27) {
      return _secondTrimester(w);
    } else {
      return _thirdTrimester(w);
    }
  }

  static WeekInfo _firstTrimester(int w) {
    return WeekInfo(
      week: w,
      babyDevelopment: 'ہفتہ $w: بچے کے بنیادی اعضاء اور دماغ بننا شروع ہو رہے ہیں۔ دل کی دھڑکن اس مرحلے میں شروع ہو جاتی ہے اور بچہ تیزی سے نشوونما پا رہا ہے۔',
      motherChanges: 'ہفتہ $w: تھکاوٹ، متلی، الٹی اور موڈ میں تبدیلی محسوس ہو سکتی ہے۔ ہارمونز میں تیز تبدیلی آتی ہے، سینے میں بھاری پن ہو سکتا ہے۔',
      tips: 'زیادہ آرام کریں، تھوڑا تھوڑا کھانا کھائیں، فولک ایسڈ کا استعمال جاری رکھیں اور فکر کے بجائے دعا اور اطمینان اپنائیں۔',
      foodsToEat: generalFoodsToEat,
      foodsToAvoid: generalFoodsToAvoid,
    );
  }

  static WeekInfo _secondTrimester(int w) {
    return WeekInfo(
      week: w,
      babyDevelopment: 'ہفتہ $w: بچے کی حرکت محسوس ہونا شروع ہو سکتی ہے، ہڈیاں مضبوط ہو رہی ہیں اور بچے کے چہرے کے خدوخال واضح ہو رہے ہیں۔',
      motherChanges: 'ہفتہ $w: پیٹ نمایاں ہونا شروع ہو جاتا ہے، توانائی میں بہتری آتی ہے مگر کمر درد اور بھوک میں اضافہ ہو سکتا ہے۔',
      tips: 'متوازن غذا، ہلکی واک، کیلشیم اور آئرن سے بھرپور غذا لیں۔ ڈاکٹر سے باقاعدہ چیک اپ کروائیں۔',
      foodsToEat: generalFoodsToEat,
      foodsToAvoid: generalFoodsToAvoid,
    );
  }

  static WeekInfo _thirdTrimester(int w) {
    return WeekInfo(
      week: w,
      babyDevelopment: 'ہفتہ $w: بچے کا وزن تیزی سے بڑھ رہا ہے، پھیپھڑے مکمل ہو رہے ہیں اور بچہ پیدائش کی پوزیشن میں آنے کی تیاری کر رہا ہے۔',
      motherChanges: 'ہفتہ $w: سانس لینے میں دشواری، ٹانگوں میں سوجن اور نیند میں خلل ممکن ہے۔ جسم پیدائش کی تیاری کر رہا ہے۔',
      tips: 'زیادہ بھاری کام نہ کریں، بار بار آرام کریں، ہسپتال بیگ تیار رکھیں اور ڈاکٹر کی ہدایات پر عمل کریں۔ کسی بھی غیر معمولی علامت پر فوری رابطہ کریں۔',
      foodsToEat: generalFoodsToEat,
      foodsToAvoid: generalFoodsToAvoid,
    );
  }
}
