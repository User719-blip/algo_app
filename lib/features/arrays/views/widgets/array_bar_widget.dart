import 'package:algorythm_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

import '../../models/array_bar_visual.dart';

class ArrayBar extends StatelessWidget {
  final ArrayBarVisual visual;
  final double width;
  final double height;

  const ArrayBar({
    required this.visual,
    required this.width,
    required this.height,
    super.key,
  });

  Color _resolveFill() {
    if (visual.inCurrentRange && visual.inBestRange) {
      return AppColors.swap;
    }
    if (visual.inCurrentRange) {
      return AppColors.compare;
    }
    if (visual.inBestRange) {
      return AppColors.sorted;
    }
    return visual.value >= 0
        ? AppColors.neutral
        : AppColors.neutral.withValues(alpha: 0.65);
  }

  @override
  Widget build(BuildContext context) {
    final Color fill = _resolveFill();
    final TextStyle labelStyle =
        Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ) ??
        const TextStyle(color: Colors.white, fontWeight: FontWeight.w600);

    final BoxShadow glow = BoxShadow(
      color: fill.withValues(alpha: visual.isCurrentIndex ? 0.6 : 0.32),
      blurRadius: visual.isCurrentIndex ? 18 : 8,
      offset: const Offset(0, 8),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('${visual.value}', style: labelStyle),
        const SizedBox(height: 8),
        AnimatedContainer(
          duration: const Duration(milliseconds: 320),
          curve: Curves.easeOutCubic,
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [fill, fill.withValues(alpha: 0.7)],
            ),
            border: Border.all(
              color: visual.isCurrentIndex
                  ? Colors.white.withValues(alpha: 0.65)
                  : Colors.white.withValues(alpha: 0.15),
              width: visual.isCurrentIndex ? 1.6 : 1.0,
            ),
            boxShadow: [glow],
          ),
        ),
      ],
    );
  }
}
