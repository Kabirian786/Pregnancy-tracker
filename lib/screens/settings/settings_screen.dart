import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/theme/app_theme.dart';
import '../../controllers/settings_provider.dart';
import '../../controllers/pregnancy_provider.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/section_header.dart';

/// سیٹنگز اسکرین
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final pregnancy = context.watch<PregnancyProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('سیٹنگز')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SectionHeader(title: 'ظہور', icon: Icons.palette_rounded),
          CustomCard(
            child: Column(
              children: [
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('ڈارک موڈ'),
                  subtitle: const Text('رات کے وقت آنکھوں کے لیے آرام دہ'),
                  value: settings.themeMode == ThemeMode.dark,
                  activeColor: AppTheme.primaryGreen,
                  onChanged: settings.setDarkMode,
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('فونٹ سائز'),
                      Slider(
                        value: settings.fontScale,
                        min: 0.8,
                        max: 1.6,
                        divisions: 8,
                        activeColor: AppTheme.primaryGreen,
                        label: '${(settings.fontScale * 100).round()}%',
                        onChanged: settings.setFontScale,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SectionHeader(title: 'ذاتی معلومات', icon: Icons.person_rounded),
          CustomCard(
            child: TextFormField(
              initialValue: pregnancy.motherName,
              decoration: const InputDecoration(labelText: 'ماں کا نام'),
              onFieldSubmitted: pregnancy.setMotherName,
            ),
          ),
          const SectionHeader(title: 'زبان', icon: Icons.language_rounded),
          const CustomCard(
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.check_circle, color: AppTheme.primaryGreen),
              title: Text('اردو (Urdu)'),
              subtitle: Text('فی الحال صرف اردو زبان دستیاب ہے'),
            ),
          ),
          const SectionHeader(title: 'ڈیٹا کا بیک اپ', icon: Icons.backup_rounded),
          CustomCard(
            child: Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.upload_rounded, color: AppTheme.primaryGreen),
                  title: const Text('بیک اپ بنائیں'),
                  subtitle: const Text('اپنا تمام ڈیٹا محفوظ فائل میں ایکسپورٹ کریں'),
                  onTap: () => _backup(context, settings),
                ),
                const Divider(),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.download_rounded, color: AppTheme.primaryGreen),
                  title: const Text('بیک اپ بحال کریں'),
                  subtitle: const Text('محفوظ فائل سے ڈیٹا واپس لائیں'),
                  onTap: () => _restore(context, settings),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _backup(BuildContext context, SettingsProvider settings) async {
    try {
      final file = await settings.backupToFile();
      await Share.shareXFiles([XFile(file.path)], text: 'نہید پریگننسی کیئر - بیک اپ فائل');
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('بیک اپ بنانے میں مسئلہ: $e')));
      }
    }
  }

  Future<void> _restore(BuildContext context, SettingsProvider settings) async {
    try {
      final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['json']);
      if (result == null || result.files.single.path == null) return;
      await settings.restoreFromFile(File(result.files.single.path!));
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('ڈیٹا کامیابی سے بحال ہو گیا۔ ایپ دوبارہ کھولیں۔')));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('بحال کرنے میں مسئلہ: $e')));
      }
    }
  }
}
