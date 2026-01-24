import 'package:algorythm_app/presentation/models/visual_bar.dart';
import 'package:algorythm_app/presentation/widget/bar_widget.dart';
import 'package:flutter/material.dart';

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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: bars.map((visualBar) => Bar(visualBar)).toList(),
        ),
      ),
    );
  }
}
