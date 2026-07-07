import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../data/diet_data.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/section_header.dart';

/// خوراک کے منصوبے کی اسکرین
class DietScreen extends StatelessWidget {
  const DietScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('خوراک کا منصوبہ')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ...DietData.plan.map((section) => CustomCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(section.icon, style: const TextStyle(fontSize: 22)),
                        const SizedBox(width: 8),
                        Text(section.title,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold, color: AppTheme.primaryGreen)),
                      ],
                    ),
                    const Divider(),
                    ...section.suggestions.map((s) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.circle, size: 8, color: AppTheme.primaryGreen),
                              const SizedBox(width: 8),
                              Expanded(child: Text(s)),
                            ],
                          ),
                        )),
                  ],
                ),
              )),
          const SectionHeader(title: 'اجازت والی غذائیں', icon: Icons.check_circle_rounded),
          CustomCard(
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: DietData.allowedFoods
                  .map((f) => Chip(label: Text(f), backgroundColor: AppTheme.lightGreen))
                  .toList(),
            ),
          ),
          const SectionHeader(title: 'پرہیز والی غذائیں', icon: Icons.block_rounded),
          CustomCard(
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: DietData.avoidFoods
                  .map((f) => Chip(label: Text(f), backgroundColor: Colors.red.shade50))
                  .toList(),
            ),
          ),
          const SectionHeader(title: 'پانی پینے کے مشورے', icon: Icons.water_drop_rounded),
          CustomCard(
            child: Column(
              children: DietData.hydrationTips
                  .map((t) => ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.opacity, color: Colors.blue),
                        title: Text(t),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
