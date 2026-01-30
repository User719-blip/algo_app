import 'package:algorythm_app/algorithms/base_algorithm.dart';
import 'package:algorythm_app/domain/algorithm_step.dart';
import 'package:algorythm_app/domain/step_type.dart';

class MergeSort implements Algorithm {
  @override
  List<AlgorithmStep> generateSteps(List<int> input) {
    final steps = <AlgorithmStep>[];
    final arr = List<int>.from(input);
    if (arr.isEmpty) {
      return steps;
    }

    final sortedIndices = <int>{};

    void merge(int low, int mid, int high) {
      final left = arr.sublist(low, mid + 1);
      final right = arr.sublist(mid + 1, high + 1);

      int i = 0;
      int j = 0;
      int k = low;

      while (i < left.length && j < right.length) {
        final leftIndex = low + i;
        final rightIndex = mid + 1 + j;
        final compareLabels = <int, String>{
          leftIndex: 'Left pointer',
          rightIndex: 'Right pointer',
          k: 'Merge slot',
        };

        steps.add(
          AlgorithmStep(
            values: List<int>.from(arr),
            indexA: leftIndex,
            indexB: rightIndex,
            type: StepType.compare,
            sortedIndices: sortedIndices,
            invariantLabels: compareLabels,
          ),
        );

        if (left[i] <= right[j]) {
          arr[k] = left[i];
          final labels = <int, String>{
            leftIndex: 'Left pointer',
            k: 'Merged from left',
          };
          steps.add(
            AlgorithmStep(
              values: List<int>.from(arr),
              indexA: k,
              indexB: leftIndex,
              type: StepType.swap,
              sortedIndices: sortedIndices,
              invariantLabels: labels,
            ),
          );
          i++;
        } else {
          arr[k] = right[j];
          final labels = <int, String>{
            rightIndex: 'Right pointer',
            k: 'Merged from right',
          };
          steps.add(
            AlgorithmStep(
              values: List<int>.from(arr),
              indexA: k,
              indexB: rightIndex,
              type: StepType.swap,
              sortedIndices: sortedIndices,
              invariantLabels: labels,
            ),
          );
          j++;
        }
        k++;
      }

      while (i < left.length) {
        final sourceIndex = low + i;
        arr[k] = left[i];
        final labels = <int, String>{
          sourceIndex: 'Left remainder',
          k: 'Merged from left',
        };
        steps.add(
          AlgorithmStep(
            values: List<int>.from(arr),
            indexA: k,
            indexB: sourceIndex,
            type: StepType.swap,
            sortedIndices: sortedIndices,
            invariantLabels: labels,
          ),
        );
        i++;
        k++;
      }

      while (j < right.length) {
        final sourceIndex = mid + 1 + j;
        arr[k] = right[j];
        final labels = <int, String>{
          sourceIndex: 'Right remainder',
          k: 'Merged from right',
        };
        steps.add(
          AlgorithmStep(
            values: List<int>.from(arr),
            indexA: k,
            indexB: sourceIndex,
            type: StepType.swap,
            sortedIndices: sortedIndices,
            invariantLabels: labels,
          ),
        );
        j++;
        k++;
      }

      if (low == 0 && high == arr.length - 1) {
        for (int idx = low; idx <= high; idx++) {
          sortedIndices.add(idx);
          steps.add(
            AlgorithmStep(
              values: List<int>.from(arr),
              indexA: idx,
              indexB: null,
              type: StepType.sorted,
              sortedIndices: sortedIndices,
            ),
          );
        }
      }
    }

    void mergeSort(int low, int high) {
      if (low >= high) {
        return;
      }
      final mid = (low + high) ~/ 2;
      mergeSort(low, mid);
      mergeSort(mid + 1, high);
      merge(low, mid, high);
    }

    mergeSort(0, arr.length - 1);

    if (sortedIndices.length != arr.length) {
      for (int idx = 0; idx < arr.length; idx++) {
        sortedIndices.add(idx);
        steps.add(
          AlgorithmStep(
            values: List<int>.from(arr),
            indexA: idx,
            indexB: null,
            type: StepType.sorted,
            sortedIndices: sortedIndices,
          ),
        );
      }
    }

    return steps;
  }
}
