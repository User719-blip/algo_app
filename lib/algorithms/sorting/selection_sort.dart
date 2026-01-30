import 'package:algorythm_app/algorithms/base_algorithm.dart';
import 'package:algorythm_app/domain/algorithm_step.dart';
import 'package:algorythm_app/domain/step_type.dart';

class SelectionSort implements Algorithm {
  @override
  List<AlgorithmStep> generateSteps(List<int> input) {
    if (input.isEmpty) {
      return const [];
    }

    final steps = <AlgorithmStep>[];
    final arr = List<int>.from(input);
    final sortedIndices = <int>{};

    for (int i = 0; i < arr.length - 1; i++) {
      int minIndex = i;

      for (int j = i + 1; j < arr.length; j++) {
        final labels = <int, String>{i: 'Sorted boundary'};
        if (minIndex != i) {
          labels[minIndex] = 'Min candidate';
        }
        if (j != i && j != minIndex) {
          labels[j] = 'Scanning';
        }
        steps.add(
          AlgorithmStep(
            values: List<int>.from(arr),
            indexA: minIndex,
            indexB: j,
            type: StepType.compare,
            sortedIndices: sortedIndices,
            invariantLabels: labels,
          ),
        );

        if (arr[j] < arr[minIndex]) {
          minIndex = j;
        }
      }

      if (minIndex != i) {
        final labels = <int, String>{
          i: 'Sorted boundary',
          minIndex: 'Min candidate',
        };
        final temp = arr[i];
        arr[i] = arr[minIndex];
        arr[minIndex] = temp;
        steps.add(
          AlgorithmStep(
            values: List<int>.from(arr),
            indexA: i,
            indexB: minIndex,
            type: StepType.swap,
            sortedIndices: sortedIndices,
            invariantLabels: labels,
          ),
        );
      }

      sortedIndices.add(i);
      steps.add(
        AlgorithmStep(
          values: List<int>.from(arr),
          indexA: i,
          indexB: null,
          type: StepType.sorted,
          sortedIndices: sortedIndices,
        ),
      );
    }

    sortedIndices.add(arr.length - 1);
    steps.add(
      AlgorithmStep(
        values: List<int>.from(arr),
        indexA: arr.length - 1,
        indexB: null,
        type: StepType.sorted,
        sortedIndices: sortedIndices,
      ),
    );

    return steps;
  }
}
