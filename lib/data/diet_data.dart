/// خوراک کے منصوبے کا ایک سیکشن
class DietSection {
  final String title;
  final String icon; // emoji icon for simplicity
  final List<String> suggestions;

  const DietSection({required this.title, required this.icon, required this.suggestions});
}

class DietData {
  DietData._();

  static const List<DietSection> plan = [
    DietSection(
      title: 'صبح کا ناشتہ',
      icon: '🌅',
      suggestions: [
        'انڈے اور دو روٹی',
        'دلیہ (اوٹس) دودھ کے ساتھ',
        'پراٹھا کم گھی میں + دہی',
        'سویاں یا حلیم (ہلکی مقدار میں)',
      ],
    ),
    DietSection(
      title: 'وسط صبح - پھل',
      icon: '🍎',
      suggestions: ['سیب', 'کیلا', 'انار', 'مالٹا', 'خشک میوہ جات کی مٹھی بھر مقدار'],
    ),
    DietSection(
      title: 'دوپہر کا کھانا',
      icon: '🍛',
      suggestions: [
        'روٹی کے ساتھ دال یا سبزی',
        'چکن یا مچھلی (اچھی طرح پکی ہوئی)',
        'سادہ چاول اور رائتہ',
        'تازہ سلاد ہر کھانے کے ساتھ',
      ],
    ),
    DietSection(
      title: 'شام کا ہلکا سنیک',
      icon: '☕',
      suggestions: ['بھنے ہوئے چنے', 'دہی بھلے (ہلکا مصالحہ)', 'میوہ جات', 'گرین ٹی یا سادہ چائے (کم مقدار)'],
    ),
    DietSection(
      title: 'رات کا کھانا',
      icon: '🌙',
      suggestions: ['ہلکی سبزی/دال کے ساتھ روٹی', 'سوپ', 'گرلڈ چکن + سبزیاں', 'زیادہ تیل مصالحہ سے پرہیز'],
    ),
    DietSection(
      title: 'سونے سے پہلے',
      icon: '🥛',
      suggestions: ['ایک گلاس گرم دودھ', 'دودھ میں تھوڑی ہلدی یا بادام'],
    ),
  ];

  static const List<String> allowedFoods = [
    'دودھ، دہی، پنیر',
    'انڈے اور اچھی طرح پکا گوشت',
    'تازہ سبزیاں اور پھل',
    'دالیں اور اجناس',
    'خشک میوہ جات',
    'وافر مقدار میں پانی',
  ];

  static const List<String> avoidFoods = [
    'کچا یا کم پکا گوشت اور انڈے',
    'زیادہ کیفین والی چائے/کافی',
    'زیادہ مصالحہ دار و تیل والی غذا',
    'بازاری جوس، کولڈ ڈرنکس',
    'غیر پاسچرائزڈ دودھ اور پنیر',
    'زیادہ نمک اور پراسیسڈ فوڈ',
  ];

  static const List<String> hydrationTips = [
    'روزانہ 8 سے 10 گلاس پانی پئیں',
    'ناریل پانی اور تازہ لسی مفید ہیں',
    'ایک ہی وقت میں زیادہ پانی پینے کے بجائے تھوڑا تھوڑا پورا دن پئیں',
    'کھانے سے پہلے زیادہ پانی پینے سے گریز کریں',
  ];
}
