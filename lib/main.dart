import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'controllers/settings_provider.dart';
import 'controllers/pregnancy_provider.dart';
import 'controllers/checklist_provider.dart';
import 'controllers/water_provider.dart';
import 'controllers/medicine_provider.dart';
import 'controllers/appointment_provider.dart';
import 'controllers/weight_provider.dart';
import 'controllers/bp_provider.dart';
import 'controllers/notes_provider.dart';
import 'services/hive_service.dart';
import 'services/notification_service.dart';
import 'screens/home/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.init();
  await NotificationService.instance.init();
  runApp(const NaheedApp());
}

class NaheedApp extends StatelessWidget {
  const NaheedApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => PregnancyProvider()),
        ChangeNotifierProvider(create: (_) => ChecklistProvider()),
        ChangeNotifierProvider(create: (_) => WaterProvider()),
        ChangeNotifierProvider(create: (_) => MedicineProvider()),
        ChangeNotifierProvider(create: (_) => AppointmentProvider()),
        ChangeNotifierProvider(create: (_) => WeightProvider()),
        ChangeNotifierProvider(create: (_) => BpProvider()),
        ChangeNotifierProvider(create: (_) => NotesProvider()),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settings, _) {
          return MaterialApp(
            title: 'نہید پریگننسی کیئر',
            debugShowCheckedModeBanner: false,
            locale: const Locale('ur', 'PK'),
            supportedLocales: const [Locale('ur', 'PK'), Locale('en', 'US')],
            localizationsDelegates: const [
              DefaultMaterialLocalizations.delegate,
              DefaultWidgetsLocalizations.delegate,
              DefaultCupertinoLocalizations.delegate,
            ],
            theme: AppTheme.light(settings.fontScale),
            darkTheme: AppTheme.dark(settings.fontScale),
            themeMode: settings.themeMode,
            builder: (context, child) {
              return Directionality(
                textDirection: TextDirection.rtl,
                child: child ?? const SizedBox.shrink(),
              );
            },
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
