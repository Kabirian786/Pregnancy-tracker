import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../screens/home/home_screen.dart';
import '../screens/checklist/checklist_screen.dart';
import '../screens/water/water_screen.dart';
import '../screens/medicine/medicine_screen.dart';
import '../screens/pregnancy_tracker/pregnancy_tracker_screen.dart';
import '../screens/diet/diet_screen.dart';
import '../screens/appointment/appointment_screen.dart';
import '../screens/weight/weight_screen.dart';
import '../screens/bp/bp_screen.dart';
import '../screens/notes/notes_screen.dart';
import '../screens/emergency/emergency_screen.dart';
import '../screens/reports/reports_screen.dart';
import '../screens/settings/settings_screen.dart';

class _NavItem {
  final IconData icon;
  final String label;
  final Widget Function() builder;
  const _NavItem(this.icon, this.label, this.builder);
}

/// مکمل ایپ نیویگیشن ڈرار - تمام 13 سیکشنز تک رسائی
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  static final List<_NavItem> _items = [
    _NavItem(Icons.home_rounded, 'ہوم', () => const HomeScreen()),
    _NavItem(Icons.checklist_rounded, 'روزانہ چیک لسٹ', () => const ChecklistScreen()),
    _NavItem(Icons.water_drop_rounded, 'پانی ٹریکر', () => const WaterScreen()),
    _NavItem(Icons.medication_rounded, 'دوا کی یاد دہانی', () => const MedicineScreen()),
    _NavItem(Icons.pregnant_woman_rounded, 'حمل ہفتہ ٹریکر', () => const PregnancyTrackerScreen()),
    _NavItem(Icons.restaurant_menu_rounded, 'خوراک کا منصوبہ', () => const DietScreen()),
    _NavItem(Icons.calendar_month_rounded, 'ڈاکٹر اپائنٹمنٹ', () => const AppointmentScreen()),
    _NavItem(Icons.monitor_weight_rounded, 'وزن ٹریکر', () => const WeightScreen()),
    _NavItem(Icons.favorite_rounded, 'بلڈ پریشر ٹریکر', () => const BpScreen()),
    _NavItem(Icons.edit_note_rounded, 'ڈائری / نوٹس', () => const NotesScreen()),
    _NavItem(Icons.warning_amber_rounded, 'ایمرجنسی', () => const EmergencyScreen()),
    _NavItem(Icons.picture_as_pdf_rounded, 'رپورٹس', () => const ReportsScreen()),
    _NavItem(Icons.settings_rounded, 'سیٹنگز', () => const SettingsScreen()),
  ];

  @override
  Widget build(BuildContext context) {
    final currentTitle = ModalRoute.of(context)?.settings.name;
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.primaryGreen, AppTheme.darkGreen],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
              ),
              child: Column(
                children: const [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.pregnant_woman_rounded, size: 36, color: AppTheme.primaryGreen),
                  ),
                  SizedBox(height: 10),
                  Text('نہید پریگننسی کیئر',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text('آپ اور آپ کے بچے کا ساتھی',
                      style: TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  final item = _items[index];
                  final selected = item.label == currentTitle;
                  return ListTile(
                    leading: Icon(item.icon, color: selected ? AppTheme.primaryGreen : Colors.grey.shade600),
                    title: Text(item.label,
                        style: TextStyle(
                            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                            color: selected ? AppTheme.primaryGreen : null)),
                    selected: selected,
                    selectedTileColor: AppTheme.lightGreen,
                    onTap: () {
                      Navigator.pop(context);
                      if (!selected) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            settings: RouteSettings(name: item.label),
                            builder: (_) => item.builder(),
                          ),
                        );
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
