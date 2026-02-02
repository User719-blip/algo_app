import 'package:algorythm_app/algorithms/arrays/kadane_algorithm.dart';
import 'package:algorythm_app/core/models/algorithm_page_data.dart';
import 'package:algorythm_app/core/models/complexity_item.dart';
import 'package:algorythm_app/core/models/dry_run_pass.dart';
import 'package:algorythm_app/features/arrays/models/array_algorithm_config.dart';

const List<int> kArrayDemoInput = [3, -2, 5, -1, 4, -5, 2];

const String _kadanePseudoCode = '''procedure kadane(arr):
  if arr is empty:
    return 0
  maxSoFar <- arr[0]
  current <- arr[0]
  start <- end <- 0
  bestStart <- bestEnd <- 0
  for i from 1 to length(arr) - 1:
    if current + arr[i] < arr[i]:
      current <- arr[i]
      start <- end <- i
    else:
      current <- current + arr[i]
      end <- i
    if current > maxSoFar:
      maxSoFar <- current
      bestStart <- start
      bestEnd <- end
  return maxSoFar, [bestStart, bestEnd]
''';

const String _kadaneDart = '''int kadane(List<int> values) {
  if (values.isEmpty) {
    return 0;
  }
  int current = values.first;
  int best = values.first;
  for (int i = 1; i < values.length; i++) {
    current = current + values[i] > values[i]
        ? current + values[i]
        : values[i];
    if (current > best) {
      best = current;
    }
  }
  return best;
}
''';

const String _kadanePython = '''def kadane(nums):
    if not nums:
        return 0
    current = best = nums[0]
    for x in nums[1:]:
        current = max(x, current + x)
        best = max(best, current)
    return best
''';

const String _kadaneCpp = '''int kadane(const std::vector<int>& nums) {
  if (nums.empty()) {
    return 0;
  }
  int current = nums.front();
  int best = nums.front();
  for (std::size_t i = 1; i < nums.size(); ++i) {
    current = std::max(nums[i], current + nums[i]);
    best = std::max(best, current);
  }
  return best;
}
''';

final Map<ArrayAlgorithmId, ArrayAlgorithmConfig> arrayAlgorithmCatalog = {
  ArrayAlgorithmId.kadane: ArrayAlgorithmConfig(
    id: ArrayAlgorithmId.kadane,
    algorithm: const KadaneAlgorithm(),
    demoInput: kArrayDemoInput,
    data: AlgorithmPageData(
      name: "Kadane's Algorithm",
      tagline: 'Linear-time maximum subarray finder.',
      conceptSummary:
          'Kadane keeps a running window that either extends with the next element or restarts at it, ensuring the best subarray emerges in a single pass.',
      conceptPoints: [
        'Maintain a current window sum and restart when it becomes negative.',
        'Track the best sum and its range while scanning.',
        'Runs in linear time with constant extra space.',
      ],
      conceptUsage:
          'Use it to detect profit streaks, energy bursts, or any contiguous segment with maximum gain.',
      dryRuns: [
        DryRunPass(
          title: 'Mixed signs',
          steps: [
            'Start at index 0 with sum 3.',
            'Extend across positive swings to accumulate toward 9.',
            'Reset when the running sum dips below the next element.',
          ],
          highlight: 'Final best sum is 9 spanning indices 0..4.',
        ),
      ],
      complexity: [
        ComplexityItem(
          title: 'Time',
          complexity: 'O(n)',
          note: 'Each element updates the current and best sums once.',
        ),
        ComplexityItem(
          title: 'Space',
          complexity: 'O(1)',
          note: 'Only a couple of scalar trackers regardless of input size.',
        ),
      ],
      pseudoCode: _kadanePseudoCode,
      implementations: {
        'Dart': _kadaneDart,
        'Python': _kadanePython,
        'C++': _kadaneCpp,
      },
    ),
  ),
};

final List<ArrayAlgorithmConfig> arrayAlgorithmList = List.unmodifiable(
  arrayAlgorithmCatalog.values,
);
