import 'package:flutter/material.dart';

import '../models/visual_bar.dart';
import 'bar_widget.dart';

class BarSection extends StatelessWidget {
  final List<VisualBar> bars;

  const BarSection({required this.bars, super.key});

  @override
  Widget build(BuildContext context) {
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
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 36),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double availableWidth = constraints.maxWidth;
            final int count = bars.length;
            if (count == 0) {
              return const SizedBox.shrink();
            }

            final double gap = (availableWidth * 0.04).clamp(6, 20);
            final double barWidth =
                ((availableWidth - gap * (count - 1)) / count)
                    .clamp(24.0, 72.0)
                    .toDouble();

            final List<Widget> children = [];
            for (int i = 0; i < count; i++) {
              if (i > 0) {
                children.add(SizedBox(width: gap));
              }
              children.add(Bar(bars[i], width: barWidth));
            }

            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: children,
            );
          },
        ),
      ),
    );
  }
}
