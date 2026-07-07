import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/date_utils.dart';
import '../../controllers/checklist_provider.dart';
import '../../controllers/water_provider.dart';
import '../../controllers/weight_provider.dart';
import '../../controllers/bp_provider.dart';
import '../../services/pdf_service.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/section_header.dart';

enum ReportRange { daily, weekly, monthly }

/// رپورٹس اسکرین - روزانہ، ہفتہ وار، ماہانہ خلاصہ اور PDF ایکسپورٹ
class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  ReportRange _range = ReportRange.daily;
  bool _generating = false;

  int get _days {
    switch (_range) {
      case ReportRange.daily:
        return 1;
      case ReportRange.weekly:
        return 7;
      case ReportRange.monthly:
        return 30;
    }
  }

  String get _rangeLabel {
    switch (_range) {
      case ReportRange.daily:
        return 'روزانہ رپورٹ';
      case ReportRange.weekly:
        return 'ہفتہ وار رپورٹ';
      case ReportRange.monthly:
        return 'ماہانہ رپورٹ';
    }
  }

  @override
  Widget build(BuildContext context) {
    final checklist = context.watch<ChecklistProvider>();
    final water = context.watch<WaterProvider>();
    final weight = context.watch<WeightProvider>();
    final bp = context.watch<BpProvider>();

    final days = AppDateUtils.lastNDays(_days);
    final avgChecklist = days.map((d) => checklist.progressPercent(d)).reduce((a, b) => a + b) / days.length;
    final totalWater = days.map((d) => water.glassesFor(d)).reduce((a, b) => a + b);
    final avgWater = totalWater / days.length;
    final latestWeight = weight.latestWeight;
    final latestBp = bp.latest;

    return Scaffold(
      appBar: AppBar(title: const Text('رپورٹس')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SegmentedButton<ReportRange>(
            segments: const [
              ButtonSegment(value: ReportRange.daily, label: Text('روزانہ')),
              ButtonSegment(value: ReportRange.weekly, label: Text('ہفتہ وار')),
              ButtonSegment(value: ReportRange.monthly, label: Text('ماہانہ')),
            ],
            selected: {_range},
            onSelectionChanged: (s) => setState(() => _range = s.first),
          ),
          const SizedBox(height: 12),
          const SectionHeader(title: 'خلاصہ', icon: Icons.summarize_rounded),
          CustomCard(
            child: Column(
              children: [
                _reportRow(context, 'اوسط چیک لسٹ مکمل', '${avgChecklist.round()}%'),
                _reportRow(context, 'اوسط پانی', '${avgWater.toStringAsFixed(1)} گلاس / دن'),
                _reportRow(context, 'موجودہ وزن', latestWeight != null ? '$latestWeight کلوگرام' : '—'),
                _reportRow(
                  context,
                  'موجودہ بلڈ پریشر',
                  latestBp != null ? '${latestBp.systolic}/${latestBp.diastolic} mmHg' : '—',
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _generating
                  ? null
                  : () => _exportPdf(context, avgChecklist, avgWater, latestWeight, latestBp),
              icon: _generating
                  ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.picture_as_pdf_rounded),
              label: Text(_generating ? 'رپورٹ تیار ہو رہی ہے...' : 'PDF کے طور پر ایکسپورٹ کریں'),
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _reportRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyLarge),
          Text(value, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppTheme.primaryGreen)),
        ],
      ),
    );
  }

  Future<void> _exportPdf(
    BuildContext context,
    double avgChecklist,
    double avgWater,
    double? latestWeight,
    dynamic latestBp,
  ) async {
    setState(() => _generating = true);
    try {
      await PdfService.generateAndShareReport(
        title: _rangeLabel,
        rows: [
          MapEntry('اوسط چیک لسٹ مکمل', '${avgChecklist.round()}%'),
          MapEntry('اوسط پانی', '${avgWater.toStringAsFixed(1)} گلاس فی دن'),
          MapEntry('موجودہ وزن', latestWeight != null ? '$latestWeight کلوگرام' : '—'),
          MapEntry(
            'موجودہ بلڈ پریشر',
            latestBp != null ? '${latestBp.systolic}/${latestBp.diastolic} mmHg' : '—',
          ),
          MapEntry('تاریخ', AppDateUtils.urduDate(DateTime.now())),
        ],
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('رپورٹ بنانے میں مسئلہ ہوا: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _generating = false);
    }
  }
}
