import 'package:algorythm_app/algorithms/base_algorithm.dart';
import 'package:algorythm_app/domain/algorithm_step.dart';
import 'package:algorythm_app/domain/step_type.dart';

class QuickSort implements Algorithm {
  @override
  List<AlgorithmStep> generateSteps(List<int> input) {
    final steps = <AlgorithmStep>[];
    if (input.isEmpty) {
      return steps;
    }

    final arr = List<int>.from(input);
    final sortedIndices = <int>{};

    void markSorted(int index, {String? label}) {
      if (index < 0 || index >= arr.length) {
        return;
      }
      if (sortedIndices.add(index)) {
        steps.add(
          AlgorithmStep(
            values: List<int>.from(arr),
            indexA: index,
            indexB: null,
            type: StepType.sorted,
            sortedIndices: sortedIndices,
            invariantLabels: label == null ? null : <int, String>{index: label},
          ),
        );
      }
    }

    int partition(int low, int high) {
      final pivotValue = arr[high];
      int storeIndex = low;

      for (int j = low; j < high; j++) {
        final labels = <int, String>{
          high: 'Pivot',
          storeIndex: 'Partition boundary',
        };
        if (j != storeIndex && j != high) {
          labels[j] = 'Scanner';
        }
        steps.add(
          AlgorithmStep(
            values: List<int>.from(arr),
            indexA: j,
            indexB: high,
            type: StepType.compare,
            sortedIndices: sortedIndices,
            invariantLabels: labels,
          ),
        );

        if (arr[j] <= pivotValue) {
          if (storeIndex != j) {
            final temp = arr[storeIndex];
            arr[storeIndex] = arr[j];
            arr[j] = temp;
            final swapLabels = <int, String>{
              high: 'Pivot',
              storeIndex: 'Partition boundary',
            };
            if (j != storeIndex && j != high) {
              swapLabels[j] = 'Scanner';
            }
            steps.add(
              AlgorithmStep(
                values: List<int>.from(arr),
                indexA: storeIndex,
                indexB: j,
                type: StepType.swap,
                sortedIndices: sortedIndices,
                invariantLabels: swapLabels,
              ),
            );
          }
          storeIndex++;
        }
      }

      if (storeIndex != high) {
        final temp = arr[storeIndex];
        arr[storeIndex] = arr[high];
        arr[high] = temp;
        final labels = <int, String>{
          storeIndex: 'Pivot destination',
          high: 'Pivot',
        };
        steps.add(
          AlgorithmStep(
            values: List<int>.from(arr),
            indexA: storeIndex,
            indexB: high,
            type: StepType.swap,
            sortedIndices: sortedIndices,
            invariantLabels: labels,
          ),
        );
      }

      return storeIndex;
    }

    void quickSort(int low, int high) {
      if (low >= high) {
        if (low == high) {
          markSorted(low);
        }
        return;
      }

      final pivotIndex = partition(low, high);
      markSorted(pivotIndex, label: 'Pivot fixed');
      quickSort(low, pivotIndex - 1);
      quickSort(pivotIndex + 1, high);
    }

    quickSort(0, arr.length - 1);

    if (sortedIndices.length != arr.length) {
      for (int idx = 0; idx < arr.length; idx++) {
        markSorted(idx);
      }
    }

    return steps;
  }
}
