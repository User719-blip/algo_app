import 'package:flutter/material.dart';

import '../models/visual_bar.dart';
import '../theme/app_colors.dart';

class Bar extends StatelessWidget {
  final VisualBar bar;
  final double width;

  const Bar(this.bar, {super.key, this.width = 34});

  Color _resolveColor() {
    switch (bar.state) {
      case BarState.comparing:
        return AppColors.compare;
      case BarState.swapping:
        return AppColors.swap;
      case BarState.sorted:
        return AppColors.sorted;
      case BarState.normal:
        return AppColors.neutral;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color baseColor = _resolveColor();
    final double barHeight = bar.value * 18.0 + 24;
    final TextStyle labelStyle =
        Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ) ??
        const TextStyle(color: Colors.white, fontWeight: FontWeight.w600);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('${bar.value}', style: labelStyle),
        const SizedBox(height: 8),
        AnimatedContainer(
          duration: const Duration(milliseconds: 320),
          curve: Curves.easeOutCubic,
          width: width,
          height: barHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [baseColor, baseColor.withValues(alpha: 0.65)],
            ),
            boxShadow: [
              BoxShadow(
                color: baseColor.withValues(alpha: 0.42),
                blurRadius: 16,
                offset: const Offset(0, 12),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
