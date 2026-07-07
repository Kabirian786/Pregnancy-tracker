import 'package:flutter/material.dart';

/// ایپ کی تھیم - سفید بیک گراؤنڈ، سبز ایکسنٹ، بڑے پڑھنے کے قابل اردو فونٹس
/// نوٹ: اردو فونٹ (NotoNastaliqUrdu) assets/fonts میں مقامی طور پر بنڈل ہے - انٹرنیٹ درکار نہیں
class AppTheme {
  AppTheme._();

  static const String fontFamily = 'NotoNastaliqUrdu';

  static const Color primaryGreen = Color(0xFF1E8E5A);
  static const Color lightGreen = Color(0xFFE6F4EC);
  static const Color darkGreen = Color(0xFF0F5C38);
  static const Color accentPink = Color(0xFFEF7C8E);
  static const Color warningRed = Color(0xFFD64545);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF121A16);

  static TextTheme _urduTextTheme(TextTheme base, double scale) {
    final font = base.apply(fontFamily: fontFamily);
    return font.copyWith(
      displayLarge: font.displayLarge?.copyWith(fontSize: 32 * scale, fontWeight: FontWeight.bold),
      headlineMedium: font.headlineMedium?.copyWith(fontSize: 24 * scale, fontWeight: FontWeight.bold),
      titleLarge: font.titleLarge?.copyWith(fontSize: 20 * scale, fontWeight: FontWeight.w600),
      titleMedium: font.titleMedium?.copyWith(fontSize: 18 * scale, fontWeight: FontWeight.w600),
      bodyLarge: font.bodyLarge?.copyWith(fontSize: 18 * scale),
      bodyMedium: font.bodyMedium?.copyWith(fontSize: 16 * scale),
      bodySmall: font.bodySmall?.copyWith(fontSize: 14 * scale),
      labelLarge: font.labelLarge?.copyWith(fontSize: 16 * scale, fontWeight: FontWeight.w600),
    );
  }

  static ThemeData light(double fontScale) {
    final base = ThemeData.light(useMaterial3: true);
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primaryGreen,
      brightness: Brightness.light,
    );
    return base.copyWith(
      colorScheme: colorScheme.copyWith(primary: primaryGreen, surface: surfaceLight),
      scaffoldBackgroundColor: surfaceLight,
      primaryColor: primaryGreen,
      fontFamily: fontFamily,
      textTheme: _urduTextTheme(base.textTheme, fontScale),
      appBarTheme: AppBarTheme(
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
            fontFamily: fontFamily, fontSize: 20 * fontScale, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 2,
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGreen,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: TextStyle(fontFamily: fontFamily, fontSize: 16 * fontScale, fontWeight: FontWeight.w600),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(backgroundColor: primaryGreen),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightGreen.withOpacity(0.4),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return primaryGreen;
          return Colors.grey.shade300;
        }),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: primaryGreen,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  static ThemeData dark(double fontScale) {
    final base = ThemeData.dark(useMaterial3: true);
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primaryGreen,
      brightness: Brightness.dark,
    );
    return base.copyWith(
      colorScheme: colorScheme.copyWith(primary: primaryGreen, surface: surfaceDark),
      scaffoldBackgroundColor: surfaceDark,
      fontFamily: fontFamily,
      textTheme: _urduTextTheme(base.textTheme, fontScale).apply(bodyColor: Colors.white, displayColor: Colors.white),
      appBarTheme: AppBarTheme(
        backgroundColor: darkGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
            fontFamily: fontFamily, fontSize: 20 * fontScale, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF1B2620),
        elevation: 1,
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGreen,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: TextStyle(fontFamily: fontFamily, fontSize: 16 * fontScale, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
