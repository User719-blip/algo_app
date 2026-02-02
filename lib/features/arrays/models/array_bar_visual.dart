class ArrayBarVisual {
  final int value;
  final bool isCurrentIndex;
  final bool inCurrentRange;
  final bool inBestRange;

  const ArrayBarVisual({
    required this.value,
    this.isCurrentIndex = false,
    this.inCurrentRange = false,
    this.inBestRange = false,
  });
}
