import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/date_utils.dart';
import '../../controllers/weight_provider.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/section_header.dart';

/// وزن ٹریکر اسکرین
class WeightScreen extends StatelessWidget {
  const WeightScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WeightProvider>();
    final entries = provider.entries;

    return Scaffold(
      appBar: AppBar(title: const Text('وزن ٹریکر')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context, provider),
        child: const Icon(Icons.add),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          CustomCard(
            color: AppTheme.lightGreen,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('موجودہ وزن', style: Theme.of(context).textTheme.bodyMedium),
                      Text(
                        provider.latestWeight != null ? '${provider.latestWeight} کلوگرام' : '—',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppTheme.primaryGreen),
                      ),
                    ],
                  ),
                ),
                if (provider.weeklyChange != null)
                  Column(
                    children: [
                      Text('ہفتہ وار تبدیلی', style: Theme.of(context).textTheme.bodySmall),
                      Text(
                        '${provider.weeklyChange!.toStringAsFixed(1)} کلوگرام',
                        style: TextStyle(
                          color: provider.weeklyChange! >= 0 ? AppTheme.primaryGreen : AppTheme.warningRed,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          const SectionHeader(title: 'وزن کا گراف', icon: Icons.show_chart_rounded),
          if (entries.length >= 2)
            CustomCard(
              child: SizedBox(
                height: 220,
                child: LineChart(
                  LineChartData(
                    gridData: const FlGridData(show: true),
                    borderData: FlBorderData(show: false),
                    titlesData: const FlTitlesData(
                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 32)),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: entries
                            .asMap()
                            .entries
                            .map((e) => FlSpot(e.key.toDouble(), e.value.weight))
                            .toList(),
                        isCurved: true,
                        color: AppTheme.primaryGreen,
                        barWidth: 3,
                        dotData: const FlDotData(show: true),
                        belowBarData: BarAreaData(show: true, color: AppTheme.lightGreen),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            const CustomCard(child: Center(child: Text('کم از کم دو اندراجات درکار ہیں گراف کے لیے'))),
          const SectionHeader(title: 'وزن کی ہسٹری', icon: Icons.history_rounded),
          ...entries.reversed.map((e) => CustomCard(
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.monitor_weight_rounded, color: AppTheme.primaryGreen),
                  title: Text('${e.weight} کلوگرام'),
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

  void _showAddDialog(BuildContext context, WeightProvider provider) {
    final controller = TextEditingController();
    DateTime date = DateTime.now();
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('وزن شامل کریں'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'وزن (کلوگرام)'),
              ),
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
                final weight = double.tryParse(controller.text);
                if (weight != null) {
                  provider.addEntry(weight, date);
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
