import 'package:flutter/material.dart';

import '../models/visual_tile.dart';
import 'square_tile.dart';

class TileSection extends StatelessWidget {
  final List<VisualTile> tiles;

  const TileSection({required this.tiles, super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final int count = tiles.length;
        if (count == 0) {
          return const SizedBox.shrink();
        }

        final double maxWidth = constraints.maxWidth;
        final double spacing = (maxWidth * 0.03).clamp(12, 24);
        final double rawSize = (maxWidth - spacing * (count - 1)) / count;
        final double tileSize = rawSize.clamp(48.0, 86.0).toDouble();

        return Wrap(
          alignment: WrapAlignment.center,
          spacing: spacing,
          runSpacing: spacing,
          children: tiles
              .map((visualTile) => SquareTile(visualTile, size: tileSize))
              .toList(),
        );
      },
    );
  }
}
