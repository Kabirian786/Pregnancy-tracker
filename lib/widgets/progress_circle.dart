import 'package:flutter/material.dart';

/// دائروی پروگریس انڈیکیٹر - فیصد اور مرکز میں کیپشن کے ساتھ
class ProgressCircle extends StatelessWidget {
  final double percent; // 0..1
  final String centerText;
  final String? subText;
  final Color color;
  final double size;

  const ProgressCircle({
    super.key,
    required this.percent,
    required this.centerText,
    this.subText,
    required this.color,
    this.size = 140,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: percent.clamp(0, 1)),
            duration: const Duration(milliseconds: 600),
            builder: (context, value, _) => SizedBox(
              width: size,
              height: size,
              child: CircularProgressIndicator(
                value: value,
                strokeWidth: 12,
                backgroundColor: color.withOpacity(0.15),
                valueColor: AlwaysStoppedAnimation(color),
                strokeCap: StrokeCap.round,
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(centerText, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: color)),
              if (subText != null)
                Text(subText!, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ],
      ),
    );
  }
}
