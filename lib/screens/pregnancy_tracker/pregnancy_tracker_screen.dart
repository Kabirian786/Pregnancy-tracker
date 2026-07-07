import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/date_utils.dart';
import '../../controllers/pregnancy_provider.dart';
import '../../data/pregnancy_week_data.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/section_header.dart';

/// حمل کے ہفتہ کا ٹریکر - LMP یا مینوئل ہفتہ درج کریں
class PregnancyTrackerScreen extends StatelessWidget {
  const PregnancyTrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pregnancy = context.watch<PregnancyProvider>();
    final weekInfo = PregnancyWeekData.getWeekInfo(pregnancy.currentWeek);

    return Scaffold(
      appBar: AppBar(title: const Text('حمل ہفتہ ٹریکر')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          CustomCard(
            color: AppTheme.lightGreen,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('موجودہ ہفتہ: ${pregnancy.currentWeek}', style: Theme.of(context).textTheme.titleLarge),
                if (pregnancy.estimatedDueDate != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      'متوقع تاریخ پیدائش: ${AppDateUtils.urduDate(pregnancy.estimatedDueDate!)}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.calendar_today),
                        label: const Text('آخری ماہواری کی تاریخ (LMP)'),
                        onPressed: () => _pickLmp(context, pregnancy),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.edit),
                        label: const Text('مینوئل ہفتہ درج کریں'),
                        onPressed: () => _pickManualWeek(context, pregnancy),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const SectionHeader(title: 'بچے کی نشوونما', icon: Icons.child_care_rounded),
          CustomCard(child: Text(weekInfo.babyDevelopment, style: Theme.of(context).textTheme.bodyLarge)),

          const SectionHeader(title: 'ماں کے جسم میں تبدیلیاں', icon: Icons.favorite_rounded),
          CustomCard(child: Text(weekInfo.motherChanges, style: Theme.of(context).textTheme.bodyLarge)),

          const SectionHeader(title: 'مفید مشورے', icon: Icons.tips_and_updates_rounded),
          CustomCard(child: Text(weekInfo.tips, style: Theme.of(context).textTheme.bodyLarge)),

          const SectionHeader(title: 'کھانے کی اجازت والی اشیاء', icon: Icons.check_circle_rounded),
          CustomCard(
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: weekInfo.foodsToEat
                  .map((f) => Chip(
                        label: Text(f),
                        backgroundColor: AppTheme.lightGreen,
                        avatar: const Icon(Icons.check, size: 16, color: AppTheme.primaryGreen),
                      ))
                  .toList(),
            ),
          ),

          const SectionHeader(title: 'پرہیز کی جانے والی اشیاء', icon: Icons.block_rounded),
          CustomCard(
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: weekInfo.foodsToAvoid
                  .map((f) => Chip(
                        label: Text(f),
                        backgroundColor: Colors.red.shade50,
                        avatar: const Icon(Icons.close, size: 16, color: AppTheme.warningRed),
                      ))
                  .toList(),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Future<void> _pickLmp(BuildContext context, PregnancyProvider pregnancy) async {
    final date = await showDatePicker(
      context: context,
      initialDate: pregnancy.lmpDate ?? DateTime.now().subtract(const Duration(days: 60)),
      firstDate: DateTime.now().subtract(const Duration(days: 300)),
      lastDate: DateTime.now(),
    );
    if (date != null) pregnancy.setLmpDate(date);
  }

  Future<void> _pickManualWeek(BuildContext context, PregnancyProvider pregnancy) async {
    final controller = TextEditingController(text: pregnancy.currentWeek.toString());
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حمل کا ہفتہ درج کریں'),
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
