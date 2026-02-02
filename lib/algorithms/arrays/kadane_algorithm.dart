import 'package:algorythm_app/algorithms/arrays/array_algorithm.dart';
import 'package:algorythm_app/domain/array_frame.dart';

class KadaneAlgorithm extends ArrayAlgorithm {
  const KadaneAlgorithm();

  @override
  List<ArrayFrame> generateFrames(List<int> input) {
    if (input.isEmpty) {
      return const [];
    }

    final values = List<int>.from(input);
    final frames = <ArrayFrame>[];

    int currentStart = 0;
    int currentSum = values.first;

    int bestStart = 0;
    int bestEnd = 0;
    int bestSum = values.first;

    frames.add(
      ArrayFrame(
        values: List<int>.from(values),
        index: 0,
        currentRange: const ArrayRange(start: 0, end: 0),
        bestRange: const ArrayRange(start: 0, end: 0),
        currentSum: currentSum,
        bestSum: bestSum,
        caption: 'Initialize both current and best sums with the first value.',
      ),
    );

    for (int i = 1; i < values.length; i++) {
      final int value = values[i];
      final int extended = currentSum + value;
      String caption;

      if (extended >= value) {
        currentSum = extended;
        caption = 'Extend current window to include index $i (Δ = $value).';
      } else {
        currentStart = i;
        currentSum = value;
        caption =
            'Restart window at index $i because $value outperforms extending.';
      }

      final int currentEnd = i;

      if (currentSum > bestSum) {
        bestSum = currentSum;
        bestStart = currentStart;
        bestEnd = currentEnd;
        caption +=
            ' Update best sum to $bestSum spanning [$bestStart, $bestEnd].';
      } else {
        caption +=
            ' Best sum remains $bestSum spanning [$bestStart, $bestEnd].';
      }

      frames.add(
        ArrayFrame(
          values: List<int>.from(values),
          index: i,
          currentRange: ArrayRange(start: currentStart, end: currentEnd),
          bestRange: ArrayRange(start: bestStart, end: bestEnd),
          currentSum: currentSum,
          bestSum: bestSum,
          caption: caption,
        ),
      );
    }

    return frames;
  }
}
