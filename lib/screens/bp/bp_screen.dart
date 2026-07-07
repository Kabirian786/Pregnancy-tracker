import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/date_utils.dart';
import '../../controllers/bp_provider.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/section_header.dart';

/// بلڈ پریشر ٹریکر اسکرین
class BpScreen extends StatelessWidget {
  const BpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BpProvider>();
    final entries = provider.entries.reversed.toList();
    final latest = provider.latest;

    return Scaffold(
      appBar: AppBar(title: const Text('بلڈ پریشر ٹریکر')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context, provider),
        child: const Icon(Icons.add),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (latest != null)
            CustomCard(
              color: latest.isHigh ? Colors.red.shade50 : AppTheme.lightGreen,
              child: Row(
                children: [
                  Icon(Icons.favorite_rounded, color: latest.isHigh ? AppTheme.warningRed : AppTheme.primaryGreen, size: 36),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${latest.systolic}/${latest.diastolic} mmHg',
                            style: Theme.of(context).textTheme.titleLarge),
                        Text('پلس: ${latest.pulse} bpm', style: Theme.of(context).textTheme.bodyMedium),
                        if (latest.isHigh)
                          Text('توجہ: بلڈ پریشر زیادہ ہے، ڈاکٹر سے رابطہ کریں',
                              style: TextStyle(color: AppTheme.warningRed, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          const SectionHeader(title: 'ہسٹری', icon: Icons.history_rounded),
          if (entries.isEmpty) const CustomCard(child: Center(child: Text('کوئی ریکارڈ موجود نہیں'))),
          ...entries.map((e) => CustomCard(
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.favorite, color: e.isHigh ? AppTheme.warningRed : AppTheme.primaryGreen),
                  title: Text('${e.systolic}/${e.diastolic} mmHg - پلس ${e.pulse}'),
                  subtitle: Text(AppDateUtils.urduDate(e.date)),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: AppTheme.warningRed),
                    onPressed: () => provider.deleteEntry(e.id),
                  ),
                ),
              )),
        ],
      ),
    );
  }

  void _showAddDialog(BuildContext context, BpProvider provider) {
    final sysController = TextEditingController();
    final diaController = TextEditingController();
    final pulseController = TextEditingController();
    DateTime date = DateTime.now();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('بلڈ پریشر ریکارڈ کریں'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  controller: sysController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'سسٹولک (Systolic)')),
              const SizedBox(height: 8),
              TextField(
                  controller: diaController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'ڈایاسٹولک (Diastolic)')),
              const SizedBox(height: 8),
              TextField(
                  controller: pulseController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'پلس (Pulse)')),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: date,
                    firstDate: DateTime.now().subtract(const Duration(days: 300)),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) setState(() => date = picked);
                },
                child: Text(AppDateUtils.dateKey(date)),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('منسوخ')),
            ElevatedButton(
              onPressed: () {
                final sys = int.tryParse(sysController.text);
                final dia = int.tryParse(diaController.text);
                final pulse = int.tryParse(pulseController.text);
                if (sys != null && dia != null && pulse != null) {
                  provider.addEntry(systolic: sys, diastolic: dia, pulse: pulse, date: date);
                  Navigator.pop(context);
                }
              },
              child: const Text('محفوظ کریں'),
            ),
          ],
        ),
      ),
    );
  }
}
