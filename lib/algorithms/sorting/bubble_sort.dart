import 'package:algorythm_app/algorithms/base_algorithm.dart';
import 'package:algorythm_app/domain/algorithm_step.dart';
import 'package:algorythm_app/domain/step_type.dart';

class BubbleSort implements Algorithm {
  @override
  List<AlgorithmStep> generateSteps(List<int> input) {
    final steps = <AlgorithmStep>[];
    final arr = List<int>.from(input);
    final int n = arr.length;
    final sortedIndices = <int>{};

    for (int i = 0; i < n - 1; i++) {
      for (int j = 0; j < n - i - 1; j++) {
        steps.add(
          AlgorithmStep(
            values: List.from(arr),
            indexA: j,
            indexB: j + 1,
            type: StepType.compare,
            sortedIndices: sortedIndices,
          ),
        );
        if (arr[j] > arr[j + 1]) {
          final temp = arr[j];
          arr[j] = arr[j + 1];
          arr[j + 1] = temp;
          steps.add(
            AlgorithmStep(
              values: List.from(arr),
              indexA: j,
              indexB: j + 1,
              type: StepType.swap,
              sortedIndices: sortedIndices,
            ),
          );
        }
      }
      sortedIndices.add(n - i - 1);
      steps.add(
        AlgorithmStep(
          values: List.from(arr),
          indexA: n - i - 1,
          indexB: null,
          type: StepType.sorted,
          sortedIndices: sortedIndices,
        ),
      );
    }
    if (n > 0 && !sortedIndices.contains(0)) {
      sortedIndices.add(0);
      steps.add(
        AlgorithmStep(
          values: List.from(arr),
          indexA: 0,
          indexB: null,
          type: StepType.sorted,
          sortedIndices: sortedIndices,
        ),
      );
    }
    return steps;
  }
}
