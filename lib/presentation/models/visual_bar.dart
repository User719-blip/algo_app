class VisualBar {
  final int value;
  final BarState state;

  VisualBar(this.value, this.state);
}

enum BarState { normal, comparing, swapping, sorted }
