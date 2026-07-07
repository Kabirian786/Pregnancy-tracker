import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/constants/app_constants.dart';
import '../../controllers/water_provider.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/progress_circle.dart';
import '../../widgets/section_header.dart';

const List<String> _urduWeekdaysShort = ['پیر', 'منگل', 'بدھ', 'جمعرات', 'جمعہ', 'ہفتہ', 'اتوار'];

String _urduWeekdayShort(DateTime date) => _urduWeekdaysShort[date.weekday - 1];

/// پانی ٹریکر اسکرین - ٹیپ کر کے گلاس شامل کریں، ہفتہ وار اعدادوشمار
class WaterScreen extends StatelessWidget {
  const WaterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final water = context.watch<WaterProvider>();
    final stats = water.weeklyStats();

    return Scaffold(
      appBar: AppBar(title: const Text('پانی ٹریکر')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          CustomCard(
            child: Column(
              children: [
                ProgressCircle(
                  percent: water.todayProgress,
                  centerText: '${water.todayGlasses}',
                  subText: 'گلاس / ${AppConstants.waterDailyTarget}',
                  color: Colors.blue.shade400,
                  size: 180,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton.filled(
                      onPressed: water.removeGlass,
                      icon: const Icon(Icons.remove),
                      style: IconButton.styleFrom(backgroundColor: Colors.grey.shade300),
                    ),
                    const SizedBox(width: 24),
                    FilledButton.icon(
                      onPressed: water.addGlass,
                      icon: const Icon(Icons.add),
                      label: const Text('ایک گلاس شامل کریں'),
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.blue.shade400,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const SectionHeader(title: 'ہفتہ وار اعدادوشمار', icon: Icons.bar_chart_rounded),
          CustomCard(
            child: SizedBox(
              height: 220,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 12,
                  gridData: const FlGridData(show: true, horizontalInterval: 2),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 24)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final days = stats.keys.toList();
                          final idx = value.toInt();
                          if (idx < 0 || idx >= days.length) return const SizedBox.shrink();
                          return Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(_urduWeekdayShort(days[idx]), style: const TextStyle(fontSize: 10)),
                          );
                        },
                      ),
                    ),
                  ),
                  barGroups: stats.values.toList().asMap().entries.map((e) {
                    return BarChartGroupData(
                      x: e.key,
                      barRods: [
                        BarChartRodData(
                          toY: e.value.toDouble(),
                          color: Colors.blue.shade400,
                          width: 18,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
