import 'package:flutter/material.dart';

import '../models/visual_tile.dart';
import '../theme/app_colors.dart';

class SquareTile extends StatelessWidget {
  final VisualTile tile;

  const SquareTile(this.tile, {super.key});

  Color _resolveColor() {
    switch (tile.state) {
      case TileState.comparing:
        return AppColors.compareTile;
      case TileState.swapping:
        return AppColors.swapTile;
      case TileState.sorted:
        return AppColors.sorted;
      case TileState.normal:
        return AppColors.neutralTile;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color baseColor = _resolveColor();
    final TextStyle labelStyle =
        Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ) ??
        const TextStyle(color: Colors.white, fontWeight: FontWeight.w600);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
      width: 60,
      height: 60,
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
      alignment: Alignment.center,
      child: Text('${tile.value}', style: labelStyle),
    );
  }
}
