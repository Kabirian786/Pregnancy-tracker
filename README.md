# نہید پریگننسی کیئر (Naheed Pregnancy Care)

مکمل اردو، آفلائن، Material Design 3 حاملہ خواتین کی نگہداشت کی ایپلیکیشن — Flutter میں تیار کی گئی۔

## اسکرین شامل ہیں / Features Implemented

1. ہوم ڈیش بورڈ (تاریخ، ہفتہ، پیش رفت، اسلامی پیغام، فوری رسائی)
2. روزانہ چیک لسٹ (صبح تا سونے سے پہلے، خودکار محفوظ)
3. پانی ٹریکر (پروگریس سرکل + ہفتہ وار بار چارٹ)
4. دوا کی یاد دہانی (Neevo/Superfort، لوکل نوٹیفیکیشن، ہسٹری)
5. حمل ہفتہ ٹریکر (LMP یا مینوئل، بچہ/ماں کی تبدیلیاں، خوراک)
6. خوراک کا مکمل منصوبہ
7. ڈاکٹر اپائنٹمنٹ (ایک دن پہلے + دن کی یاد دہانی)
8. وزن ٹریکر (لائن چارٹ)
9. بلڈ پریشر ٹریکر
10. ڈائری / نوٹس
11. ایمرجنسی سیکشن (وارننگ سائنز + کال بٹن)
12. رپورٹس (روزانہ/ہفتہ وار/ماہانہ + PDF ایکسپورٹ)
13. سیٹنگز (ڈارک/لائٹ موڈ، فونٹ سائز، بیک اپ/ریسٹور)

## آرکیٹیکچر / Architecture

```
lib/
  core/
    constants/     -> app-wide constants (checklist structure, emergency signs, etc.)
    theme/          -> Material 3 theme (light/dark, green accent)
    utils/          -> date helpers
  data/             -> static reference data (pregnancy week info, diet plan)
  models/           -> (data classes live alongside their providers in controllers/)
  services/         -> Hive init, local notifications, PDF generation
  controllers/      -> Provider ChangeNotifiers (one per feature/domain)
  screens/          -> one folder per feature screen
  widgets/          -> shared reusable UI components (cards, progress circle, drawer)
  main.dart         -> app entrypoint, MultiProvider + MaterialApp (RTL)
```

State management: **Provider** (`ChangeNotifier` per feature).
Storage: **Hive** — no code generation / `build_runner` required. All data is stored as
primitive types or `Map`s directly in Hive boxes, keyed by date (`yyyy-MM-dd`) where relevant.
This means `flutter pub get` is enough — there is no `.g.dart` codegen step.

## ⚠️ ضروری سیٹ اپ اسٹیپس / Required Setup Steps

اس پراجیکٹ میں صرف Dart/Flutter سورس کوڈ شامل ہے۔ Android native platform folder
(`android/`) خود بخود شامل نہیں کیا گیا کیونکہ یہ آپ کے مقامی Flutter SDK ورژن سے میچ
ہونا ضروری ہے۔ درج ذیل اسٹیپس مکمل کریں:

### 1. Flutter انسٹال کریں
Flutter 3.24 یا نیا ورژن (Dart 3.3+) انسٹال کریں: https://docs.flutter.dev/get-started/install

### 2. پراجیکٹ فولڈر میں native platforms بنائیں
پراجیکٹ کی روٹ ڈائریکٹری میں (جہاں `pubspec.yaml` ہے) یہ کمانڈ چلائیں:

```bash
flutter create . --platforms=android --org com.naheed --project-name naheed_pregnancy_care
```

یہ کمانڈ خودکار طور پر `android/` فولڈر (Gradle، MainActivity وغیرہ) بنا دے گی اور
موجودہ `lib/` اور `pubspec.yaml` کو محفوظ رکھے گی (یہ فائلیں overwrite نہیں ہوں گی، صرف
platform folders شامل ہوں گے)۔

> اگر آپ iOS بھی چاہتے ہیں تو `--platforms=android,ios` استعمال کریں (میک مشین ضروری ہے)۔

### 3. Dependencies حاصل کریں

```bash
flutter pub get
```

### 4. اردو فونٹ فائلیں شامل کریں (آفلائن رینڈرنگ کے لیے ضروری)

`assets/fonts/` فولڈر میں دو فائلیں رکھیں:
- `NotoNastaliqUrdu-Regular.ttf`
- `NotoNastaliqUrdu-Bold.ttf`

ڈاؤن لوڈ لنک: https://fonts.google.com/noto/specimen/Noto+Nastaliq+Urdu
("Download family" پر کلک کریں، ZIP میں سے دونوں `.ttf` فائلیں نکال کر رکھیں)

مکمل تفصیل `assets/fonts/PLACE_FONT_FILES_HERE.txt` میں موجود ہے۔ یہ فونٹ pubspec.yaml
میں پہلے سے رجسٹرڈ ہے، صرف فائلیں رکھنی ہیں۔

### 5. Android permissions شامل کریں

`flutter create` سے بننے والی فائل `android/app/src/main/AndroidManifest.xml` کھولیں
اور `<manifest>` ٹیگ کے اندر، `<application>` ٹیگ سے پہلے یہ لائنیں شامل کریں:

```xml
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM"/>
<uses-permission android:name="android.permission.USE_EXACT_ALARM"/>
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
<uses-permission android:name="android.permission.CALL_PHONE"/>
<uses-permission android:name="android.permission.INTERNET"/>
```

(`INTERNET` صرف بیک اپ شیئرنگ/فائل شیئر ڈائیلاگ کے کچھ اینڈرائیڈ ورژنز کے لیے احتیاطاً؛
ایپ کا بنیادی فنکشن مکمل طور پر آف لائن کام کرتا ہے۔)

`minSdkVersion` کو `android/app/build.gradle` میں کم از کم **21** رکھیں (flutter_local_notifications
اور Material 3 کے لیے تجویز کردہ)۔

### 6. ایپ چلائیں

```bash
flutter run
```

### 7. ریلیز APK بنائیں

```bash
flutter build apk --release
```

APK یہاں ملے گی: `build/app/outputs/flutter-apk/app-release.apk`

## نوٹس / Notes

- تمام متن اردو اور دائیں سے بائیں (RTL) ہے — `main.dart` میں `Directionality` گلوبل طور پر سیٹ ہے۔
- کوئی انٹرنیٹ کنکشن درکار نہیں — تمام ڈیٹا Hive (مقامی ڈیٹابیس) میں محفوظ ہوتا ہے۔
- PDF ایکسپورٹ کے لیے مقامی فونٹ فائل ضروری ہے (اوپر دیکھیں)۔
- ہر چیک لسٹ آئٹم تبدیل ہوتے ہی خودکار طور پر محفوظ ہو جاتا ہے (کوئی "Save" بٹن درکار نہیں)۔
- پانی ٹریکر تاریخ کی بنیاد پر کام کرتا ہے، اس لیے آدھی رات کے بعد نئی تاریخ پر خودکار طور پر 0 سے شروع ہوتا ہے۔

## اگر کوئی مسئلہ آئے / Troubleshooting

- **"CardThemeData not found" یا اسی طرح کی تھیم ایرر**: پرانا Flutter ورژن استعمال نہ کریں،
  Flutter 3.24+ استعمال کریں۔
- **نوٹیفیکیشن نہیں آ رہی**: یقینی بنائیں کہ Android سیٹنگز میں ایپ کو نوٹیفیکیشن اور
  "Exact Alarm" کی اجازت دی گئی ہے (Android 12+ پر یہ اجازت مانگی جاتی ہے، ایپ خود بخود
  پرمپٹ دکھائے گی)۔
- **اردو فونٹ نظر نہیں آ رہا / خالی ڈبے دکھ رہے ہیں**: `assets/fonts/` میں فونٹ فائلیں
  درست نام کے ساتھ موجود ہونی چاہئیں، پھر `flutter clean && flutter pub get` چلائیں۔
