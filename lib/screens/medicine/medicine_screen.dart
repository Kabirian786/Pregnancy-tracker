import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../controllers/medicine_provider.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/section_header.dart';

/// دوا کی یاد دہانی اسکرین - Neevo اور Superfort کے اوقات مقرر کریں
class MedicineScreen extends StatelessWidget {
  const MedicineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final medicine = context.watch<MedicineProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('دوا کی یاد دہانی')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SectionHeader(title: 'آج کی ادویات', icon: Icons.medication_rounded),
          ...medicine.medicines.map((med) {
            final taken = medicine.isTakenToday(med.id);
            return CustomCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: AppTheme.lightGreen,
                        child: Icon(Icons.medication_rounded, color: AppTheme.primaryGreen),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(med.name, style: Theme.of(context).textTheme.titleMedium),
                            Text('یاد دہانی: ${med.timeLabel}', style: Theme.of(context).textTheme.bodySmall),
                          ],
                        ),
                      ),
                      Switch(
                        value: med.reminderEnabled,
                        onChanged: (v) => medicine.toggleReminder(med.id, v),
                        activeColor: AppTheme.primaryGreen,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.access_time),
                          label: const Text('وقت مقرر کریں'),
                          onPressed: () => _pickTime(context, medicine, med),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: FilledButton.icon(
                          icon: Icon(taken ? Icons.check_circle : Icons.check_circle_outline),
                          label: Text(taken ? 'لی گئی' : 'لی گئی نشان زد کریں'),
                          style: FilledButton.styleFrom(
                            backgroundColor: taken ? Colors.grey : AppTheme.primaryGreen,
                          ),
                          onPressed: () {
                            if (taken) {
                              medicine.unmarkTaken(med.id);
                            } else {
                              medicine.markTaken(med.id, med.name);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 8),
          const SectionHeader(title: 'ادویات کی ہسٹری', icon: Icons.history_rounded),
          CustomCard(
            child: Builder(builder: (context) {
              final history = medicine.history();
              if (history.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(child: Text('ابھی کوئی ہسٹری موجود نہیں')),
                );
              }
              return Column(
                children: history
                    .map((h) => ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.check, color: AppTheme.primaryGreen),
                          title: Text(h['name']!),
                          subtitle: Text(h['date']!),
                        ))
                    .toList(),
              );
            }),
          ),
        ],
      ),
    );
  }

  Future<void> _pickTime(BuildContext context, MedicineProvider provider, MedicineModel med) async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: med.hour, minute: med.minute),
    );
    if (time != null) {
      await provider.setReminderTime(med.id, time.hour, time.minute);
    }
  }
}
