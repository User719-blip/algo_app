class VisualTile {
  final int value;
  final TileState state;

  VisualTile(this.value, this.state);
}

enum TileState { normal, comparing, swapping, sorted }
