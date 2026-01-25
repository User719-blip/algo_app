import 'package:flutter/material.dart';

import '../models/visual_tile.dart';
import 'square_tile.dart';

class TileSection extends StatelessWidget {
  final List<VisualTile> tiles;

  const TileSection({required this.tiles, super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 16,
      runSpacing: 16,
      children: tiles.map((visualTile) => SquareTile(visualTile)).toList(),
    );
  }
}
