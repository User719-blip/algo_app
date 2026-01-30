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
        final labels = <int, String>{i: 'Key value', j: 'Compare left'};
        if (j + 1 == i) {
          labels[i] = 'Key value (shift target)';
        } else {
          labels[j + 1] = 'Shift target';
        }
        steps.add(
          AlgorithmStep(
            values: List<int>.from(arr),
            type: StepType.compare,
            indexA: j,
            indexB: j + 1,
            sortedIndices: sortedIndices,
            invariantLabels: labels,
          ),
        );

        arr[j + 1] = arr[j];
        labels[j] = 'Shifted left';
        steps.add(
          AlgorithmStep(
            values: List<int>.from(arr),
            type: StepType.swap,
            indexA: j,
            indexB: j + 1,
            sortedIndices: sortedIndices,
            invariantLabels: labels,
          ),
        );
        j--;
      }

      if (!compared && j >= 0) {
        final labels = <int, String>{i: 'Key value', j: 'Sorted left'};
        if (j + 1 == i) {
          labels[i] = 'Key value (already aligned)';
        } else {
          labels[j + 1] = 'Insertion point';
        }
        steps.add(
          AlgorithmStep(
            values: List<int>.from(arr),
            type: StepType.compare,
            indexA: j,
            indexB: j + 1,
            sortedIndices: sortedIndices,
            invariantLabels: labels,
          ),
        );
      }

      arr[j + 1] = key;
      final labels = <int, String>{
        i: j + 1 == i ? 'Key value (stays put)' : 'Key value',
      };
      if (j + 1 != i) {
        labels[j + 1] = 'Insert here';
      }
      steps.add(
        AlgorithmStep(
          values: List<int>.from(arr),
          type: StepType.swap,
          indexA: j + 1,
          indexB: i,
          sortedIndices: sortedIndices,
          invariantLabels: labels,
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
