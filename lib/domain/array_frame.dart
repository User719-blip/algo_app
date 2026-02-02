class ArrayRange {
  final int start;
  final int end;

  const ArrayRange({required this.start, required this.end})
    : assert(start >= 0),
      assert(end >= start);

  int get length => end - start + 1;
}

class ArrayFrame {
  final List<int> values;
  final int index;
  final ArrayRange currentRange;
  final ArrayRange bestRange;
  final int currentSum;
  final int bestSum;
  final String caption;

  const ArrayFrame({
    required this.values,
    required this.index,
    required this.currentRange,
    required this.bestRange,
    required this.currentSum,
    required this.bestSum,
    required this.caption,
  });
}
