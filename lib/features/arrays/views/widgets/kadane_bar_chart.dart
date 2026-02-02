import 'dart:math' as math;

import 'package:algorythm_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

import '../../models/array_bar_visual.dart';
import 'array_bar_widget.dart';

class KadaneBarChart extends StatelessWidget {
  final List<ArrayBarVisual> bars;
  final int currentStart;
  final int currentEnd;
  final int bestStart;
  final int bestEnd;

  const KadaneBarChart({
    required this.bars,
    required this.currentStart,
    required this.currentEnd,
    required this.bestStart,
    required this.bestEnd,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (bars.isEmpty) {
      return const SizedBox.shrink();
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 24,
            offset: Offset(0, 18),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 38),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final int count = bars.length;
            final double maxWidth = constraints.maxWidth;
            final double gap = (maxWidth * 0.04).clamp(6, 20);
            final double rawWidth = (maxWidth - gap * (count - 1)) / count;
            final double barWidth = rawWidth.clamp(24.0, 68.0);
            final double chartWidth =
                count * barWidth + math.max(0, count - 1) * gap;
            final double horizontalInset = math.max(
              0,
              (maxWidth - chartWidth) / 2,
            );

            final double maxMagnitude = bars
                .map((bar) => bar.value.abs())
                .fold<double>(
                  1,
                  (prev, value) => math.max(prev, value.toDouble()),
                );
            const double maxBarHeight = 180;
            const double pointerSpace = 86;
            final double stackHeight = maxBarHeight + pointerSpace;

            final List<Widget> stackChildren = [];

            double rangeWidth(int start, int end) {
              final int length = math.max(1, end - start + 1);
              return length * barWidth + math.max(0, length - 1) * gap;
            }

            double rangeLeft(int start) {
              return horizontalInset + start * (barWidth + gap);
            }

            final double currentLeft = rangeLeft(currentStart);
            final double currentWidth = rangeWidth(currentStart, currentEnd);
            stackChildren.add(
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                left: currentLeft,
                bottom: 16,
                width: currentWidth,
                height: maxBarHeight + 12,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.compare.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
            );

            final double bestLeft = rangeLeft(bestStart);
            final double bestWidth = rangeWidth(bestStart, bestEnd);
            stackChildren.add(
              AnimatedPositioned(
                duration: const Duration(milliseconds: 340),
                curve: Curves.easeOutBack,
                left: bestLeft,
                top: 12,
                width: bestWidth,
                height: 34,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.sorted.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: AppColors.sorted.withValues(alpha: 0.45),
                      width: 1.4,
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'Best range',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            );

            final int currentIndex = bars.indexWhere(
              (bar) => bar.isCurrentIndex,
            );
            if (currentIndex >= 0) {
              final double pointerLeft =
                  rangeLeft(currentIndex) + barWidth / 2 - 16;
              stackChildren.add(
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 260),
                  curve: Curves.easeOutCubic,
                  left: pointerLeft,
                  top: -4,
                  child: _IndexPointer(),
                ),
              );
            }

            final List<Widget> barWidgets = [];
            for (int i = 0; i < count; i++) {
              final ArrayBarVisual bar = bars[i];
              final double magnitude = bar.value.abs().toDouble();
              final double normalized =
                  maxBarHeight * math.max(0.12, magnitude / maxMagnitude);
              if (i > 0) {
                barWidgets.add(SizedBox(width: gap));
              }
              barWidgets.add(
                ArrayBar(visual: bar, width: barWidth, height: normalized + 28),
              );
            }

            stackChildren.add(
              Positioned(
                bottom: 0,
                left: horizontalInset,
                width: chartWidth,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: barWidgets,
                ),
              ),
            );

            return SizedBox(
              height: stackHeight,
              width: maxWidth,
              child: Stack(clipBehavior: Clip.none, children: stackChildren),
            );
          },
        ),
      ),
    );
  }
}

class _IndexPointer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.compare.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
          ),
          child: const Text(
            'Now',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(height: 4),
        Icon(
          Icons.arrow_drop_down,
          size: 32,
          color: AppColors.compare.withValues(alpha: 0.9),
        ),
      ],
    );
  }
}
