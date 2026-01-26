import 'package:algorythm_app/algorithms/base_algorithm.dart';
import 'package:algorythm_app/domain/algorithm_step.dart';
import 'package:algorythm_app/domain/step_type.dart';

class InsertionSort implements Algorithm {
  @override
  List<AlgorithmStep> generateSteps(List<int> input) {
    if (input.isEmpty) {
      return const [];
    }

    final steps = <AlgorithmStep>[];
    final arr = List<int>.from(input);
    final sortedIndices = <int>{};

    if (arr.length == 1) {
      sortedIndices.add(0);
      steps.add(
        AlgorithmStep(
          values: List<int>.from(arr),
          type: StepType.sorted,
          indexA: 0,
          indexB: null,
          sortedIndices: sortedIndices,
        ),
      );
      return steps;
    }

    for (int i = 1; i < arr.length; i++) {
      final int key = arr[i];
      int j = i - 1;
      bool compared = false;

      while (j >= 0 && arr[j] > key) {
        compared = true;
        steps.add(
          AlgorithmStep(
            values: List<int>.from(arr),
            type: StepType.compare,
            indexA: j,
            indexB: j + 1,
            sortedIndices: sortedIndices,
          ),
        );

        arr[j + 1] = arr[j];
        steps.add(
          AlgorithmStep(
            values: List<int>.from(arr),
            type: StepType.swap,
            indexA: j,
            indexB: j + 1,
            sortedIndices: sortedIndices,
          ),
        );
        j--;
      }

      if (!compared && j >= 0) {
        steps.add(
          AlgorithmStep(
            values: List<int>.from(arr),
            type: StepType.compare,
            indexA: j,
            indexB: j + 1,
            sortedIndices: sortedIndices,
          ),
        );
      }

      arr[j + 1] = key;
      steps.add(
        AlgorithmStep(
          values: List<int>.from(arr),
          type: StepType.swap,
          indexA: j + 1,
          indexB: i,
          sortedIndices: sortedIndices,
        ),
      );

      for (int k = 0; k <= i; k++) {
        sortedIndices.add(k);
      }

      steps.add(
        AlgorithmStep(
          values: List<int>.from(arr),
          type: StepType.sorted,
          indexA: j + 1,
          indexB: null,
          sortedIndices: sortedIndices,
        ),
      );
    }

    return steps;
  }
}
