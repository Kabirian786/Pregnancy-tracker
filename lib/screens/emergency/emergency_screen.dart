import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../widgets/custom_card.dart';

/// ایمرجنسی اسکرین - خطرے کی علامات اور فوری کال بٹن
class EmergencyScreen extends StatelessWidget {
  const EmergencyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ایمرجنسی'),
        backgroundColor: AppTheme.warningRed,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          CustomCard(
            color: Colors.red.shade50,
            child: Column(
              children: [
                const Icon(Icons.warning_amber_rounded, color: AppTheme.warningRed, size: 48),
                const SizedBox(height: 8),
                Text(
                  'اگر آپ کو درج ذیل میں سے کوئی علامت محسوس ہو تو فوری طور پر ڈاکٹر یا ہسپتال سے رابطہ کریں',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppTheme.warningRed),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          ...AppConstants.emergencySigns.map((sign) => CustomCard(
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: AppTheme.warningRed),
                    const SizedBox(width: 12),
                    Expanded(child: Text(sign, style: Theme.of(context).textTheme.titleMedium)),
                  ],
                ),
              )),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _callEmergency(context),
              icon: const Icon(Icons.call, size: 28),
              label: const Text('ایمرجنسی کال کریں', style: TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.warningRed,
                padding: const EdgeInsets.symmetric(vertical: 18),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text('ایمرجنسی نمبر: ${AppConstants.emergencyNumber}',
                style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }

  Future<void> _callEmergency(BuildContext context) async {
    final uri = Uri(scheme: 'tel', path: AppConstants.emergencyNumber);
    if (!await launchUrl(uri)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('کال کرنے میں مسئلہ ہوا، براہ کرم دستی طور پر کال کریں')),
        );
      }
    }
  }
}
