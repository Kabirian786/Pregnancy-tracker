import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../controllers/checklist_provider.dart';
import '../../widgets/custom_card.dart';

/// روزانہ چیک لسٹ اسکرین - ہر سیکشن اور ٹاسک کے ساتھ خودکار محفوظ ہونے والے چیک باکسز
class ChecklistScreen extends StatelessWidget {
  const ChecklistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final checklist = context.watch<ChecklistProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('روزانہ چیک لسٹ'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'آج کی چیک لسٹ صاف کریں',
            onPressed: () => _confirmReset(context, checklist, today),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          CustomCard(
            color: AppTheme.lightGreen,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'آج کی پیش رفت: ${checklist.completedCount(today)} / ${checklist.totalTaskCount}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Text('${checklist.progressPercent(today).round()}%',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: AppTheme.primaryGreen, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          ...AppConstants.checklistSections.entries.map((section) {
            return CustomCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(section.key,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(color: AppTheme.primaryGreen, fontWeight: FontWeight.bold)),
                  const Divider(),
                  ...section.value.map((task) {
                    final checked = checklist.isChecked(today, task['id']!);
                    return CheckboxListTile(
                      value: checked,
                      title: Text(task['title']!),
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                      onChanged: (value) {
                        checklist.toggleTask(today, task['id']!, value ?? false);
                      },
                    );
                  }),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  void _confirmReset(BuildContext context, ChecklistProvider checklist, DateTime today) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('چیک لسٹ صاف کریں؟'),
        content: const Text('آج کی تمام چیک لسٹ صاف ہو جائے گی۔ کیا آپ یقینی ہیں؟'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('منسوخ')),
          ElevatedButton(
            onPressed: () {
              checklist.resetDay(today);
              Navigator.pop(context);
            },
            child: const Text('ہاں، صاف کریں'),
          ),
        ],
      ),
    );
  }
}
