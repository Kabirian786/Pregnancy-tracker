import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/date_utils.dart';
import '../../controllers/pregnancy_provider.dart';
import '../../controllers/checklist_provider.dart';
import '../../controllers/water_provider.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/progress_circle.dart';
import '../../widgets/app_drawer.dart';
import '../checklist/checklist_screen.dart';
import '../water/water_screen.dart';
import '../medicine/medicine_screen.dart';
import '../pregnancy_tracker/pregnancy_tracker_screen.dart';
import '../diet/diet_screen.dart';
import '../appointment/appointment_screen.dart';
import '../weight/weight_screen.dart';
import '../bp/bp_screen.dart';
import '../notes/notes_screen.dart';
import '../emergency/emergency_screen.dart';
import '../reports/reports_screen.dart';
import '../settings/settings_screen.dart';

/// مرکزی ہوم ڈیش بورڈ اسکرین
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pregnancy = context.watch<PregnancyProvider>();
    final checklist = context.watch<ChecklistProvider>();
    final water = context.watch<WaterProvider>();
    final today = DateTime.now();
    final message = AppConstants.motivationalMessages[Random(today.day + today.month).nextInt(
      AppConstants.motivationalMessages.length,
    )];

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(title: const Text('نہید پریگننسی کیئر')),
      body: RefreshIndicator(
        onRefresh: () async {},
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // -------- تاریخ اور ہفتہ --------
            CustomCard(
              color: AppTheme.lightGreen,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppDateUtils.urduDate(today), style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ProgressCircle(
                          percent: pregnancy.progressPercent / 100,
                          centerText: 'ہفتہ ${pregnancy.currentWeek}',
                          subText: 'حمل کی پیش رفت',
                          color: AppTheme.primaryGreen,
                          size: 120,
                        ),
                      ),
                      Expanded(
                        child: ProgressCircle(
                          percent: checklist.progressPercent(today) / 100,
                          centerText: '${checklist.progressPercent(today).round()}%',
                          subText: 'آج کی چیک لسٹ',
                          color: AppTheme.accentPink,
                          size: 120,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: TextButton.icon(
                      onPressed: () => _showEditWeekDialog(context, pregnancy),
                      icon: const Icon(Icons.edit, size: 18),
                      label: const Text('ہفتہ ترمیم کریں'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // -------- اسلامی پیغام --------
            CustomCard(
              color: Colors.white,
              child: Row(
                children: [
                  const Icon(Icons.auto_awesome, color: AppTheme.primaryGreen),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      message,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontStyle: FontStyle.italic),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // -------- پانی کا مختصر خلاصہ --------
            CustomCard(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const WaterScreen())),
              child: Row(
                children: [
                  Icon(Icons.water_drop_rounded, color: Colors.blue.shade400, size: 32),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('پانی: ${water.todayGlasses} / ${AppConstants.waterDailyTarget} گلاس',
                            style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: water.todayProgress,
                            minHeight: 8,
                            backgroundColor: Colors.blue.shade50,
                            color: Colors.blue.shade400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_left),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Text('فوری رسائی', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.9,
              children: [
                QuickAccessButton(
                    icon: Icons.checklist_rounded,
                    label: 'چیک لسٹ',
                    color: AppTheme.primaryGreen,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ChecklistScreen()))),
                QuickAccessButton(
                    icon: Icons.medication_rounded,
                    label: 'دوا',
                    color: Colors.deepPurple,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MedicineScreen()))),
                QuickAccessButton(
                    icon: Icons.pregnant_woman_rounded,
                    label: 'حمل ہفتہ',
                    color: AppTheme.accentPink,
                    onTap: () => Navigator.push(
                        context, MaterialPageRoute(builder: (_) => const PregnancyTrackerScreen()))),
                QuickAccessButton(
                    icon: Icons.restaurant_menu_rounded,
                    label: 'خوراک',
                    color: Colors.orange,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DietScreen()))),
                QuickAccessButton(
                    icon: Icons.calendar_month_rounded,
                    label: 'اپائنٹمنٹ',
                    color: Colors.blue,
                    onTap: () =>
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const AppointmentScreen()))),
                QuickAccessButton(
                    icon: Icons.monitor_weight_rounded,
                    label: 'وزن',
                    color: Colors.brown,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const WeightScreen()))),
                QuickAccessButton(
                    icon: Icons.favorite_rounded,
                    label: 'بلڈ پریشر',
                    color: Colors.red,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BpScreen()))),
                QuickAccessButton(
                    icon: Icons.edit_note_rounded,
                    label: 'نوٹس',
                    color: Colors.teal,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotesScreen()))),
                QuickAccessButton(
                    icon: Icons.warning_amber_rounded,
                    label: 'ایمرجنسی',
                    color: AppTheme.warningRed,
                    onTap: () =>
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const EmergencyScreen()))),
                QuickAccessButton(
                    icon: Icons.picture_as_pdf_rounded,
                    label: 'رپورٹس',
                    color: Colors.indigo,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ReportsScreen()))),
                QuickAccessButton(
                    icon: Icons.settings_rounded,
                    label: 'سیٹنگز',
                    color: Colors.grey.shade700,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()))),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showEditWeekDialog(BuildContext context, PregnancyProvider pregnancy) {
    final controller = TextEditingController(text: pregnancy.currentWeek.toString());
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حمل کا ہفتہ ترمیم کریں'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'ہفتہ نمبر (1-42)'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('منسوخ')),
          ElevatedButton(
            onPressed: () {
              final week = int.tryParse(controller.text);
              if (week != null && week >= 1 && week <= 42) {
                pregnancy.setManualWeek(week);
              }
              Navigator.pop(context);
            },
            child: const Text('محفوظ کریں'),
          ),
        ],
      ),
    );
  }
}
