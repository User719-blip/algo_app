import 'package:algorythm_app/algorithms/base_algorithm.dart';
import 'package:algorythm_app/algorithms/sorting/bubble_sort.dart';
import 'package:algorythm_app/algorithms/sorting/insertion_sort.dart';
import 'package:algorythm_app/algorithms/sorting/merge_sort.dart';
import 'package:algorythm_app/algorithms/sorting/selection_sort.dart';
import 'package:algorythm_app/core/models/algorithm_page_data.dart';
import 'package:algorythm_app/core/models/complexity_item.dart';
import 'package:algorythm_app/core/models/dry_run_pass.dart';

enum SortingAlgorithmId { selection, insertion, bubble, merge }

class SortingAlgorithmConfig {
  final SortingAlgorithmId id;
  final Algorithm algorithm;
  final AlgorithmPageData data;

  const SortingAlgorithmConfig({
    required this.id,
    required this.algorithm,
    required this.data,
  });
}

const List<int> kSortingDemoInput = [5, 1, 4, 2, 8];

const String _bubblePseudoCode = '''procedure bubbleSort(arr):
  n <- length(arr)
  for i from 0 to n - 2:
    swapped <- false
    for j from 0 to n - i - 2:
      if arr[j] > arr[j + 1]:
        swap arr[j], arr[j + 1]
        swapped <- true
    if not swapped:
      break
''';

const String _bubbleCpp = '''void bubbleSort(std::vector<int>& arr) {
  for (std::size_t i = 0; i + 1 < arr.size(); ++i) {
    bool swapped = false;
    for (std::size_t j = 0; j + 1 < arr.size() - i; ++j) {
      if (arr[j] > arr[j + 1]) {
        std::swap(arr[j], arr[j + 1]);
        swapped = true;
      }
    }
    if (!swapped) {
      break;
    }
  }
}
''';

const String _bubblePython = '''def bubble_sort(values):
    arr = values[:]
    for i in range(len(arr) - 1):
        swapped = False
        for j in range(len(arr) - i - 1):
            if arr[j] > arr[j + 1]:
                arr[j], arr[j + 1] = arr[j + 1], arr[j]
                swapped = True
        if not swapped:
            break
    return arr
''';

const String _bubbleJava = '''public static void bubbleSort(int[] arr) {
    for (int i = 0; i < arr.length - 1; i++) {
        boolean swapped = false;
        for (int j = 0; j < arr.length - i - 1; j++) {
            if (arr[j] > arr[j + 1]) {
                int temp = arr[j];
                arr[j] = arr[j + 1];
                arr[j + 1] = temp;
                swapped = true;
            }
        }
        if (!swapped) {
            break;
        }
    }
}
''';

const String _selectionPseudoCode = '''procedure selectionSort(arr):
  n <- length(arr)
  for i from 0 to n - 2:
    minIndex <- i
    for j from i + 1 to n - 1:
      if arr[j] < arr[minIndex]:
        minIndex <- j
    if minIndex != i:
      swap arr[i], arr[minIndex]
''';

const String _selectionCpp = '''void selectionSort(std::vector<int>& arr) {
  for (std::size_t i = 0; i + 1 < arr.size(); ++i) {
    std::size_t minIndex = i;
    for (std::size_t j = i + 1; j < arr.size(); ++j) {
      if (arr[j] < arr[minIndex]) {
        minIndex = j;
      }
    }
    if (minIndex != i) {
      std::swap(arr[i], arr[minIndex]);
    }
  }
}
''';

const String _selectionPython = '''def selection_sort(values):
    arr = values[:]
    for i in range(len(arr) - 1):
        min_index = i
        for j in range(i + 1, len(arr)):
            if arr[j] < arr[min_index]:
                min_index = j
        if min_index != i:
            arr[i], arr[min_index] = arr[min_index], arr[i]
    return arr
''';

const String _selectionJava = '''public static void selectionSort(int[] arr) {
    for (int i = 0; i < arr.length - 1; i++) {
        int minIndex = i;
        for (int j = i + 1; j < arr.length; j++) {
            if (arr[j] < arr[minIndex]) {
                minIndex = j;
            }
        }
        if (minIndex != i) {
            int temp = arr[i];
            arr[i] = arr[minIndex];
            arr[minIndex] = temp;
        }
    }
}
''';

const String _insertionPseudoCode = '''procedure insertionSort(arr):
  for i from 1 to length(arr) - 1:
  key <- arr[i]
  j <- i - 1
  while j >= 0 and arr[j] > key:
    arr[j + 1] <- arr[j]
    j <- j - 1
  arr[j + 1] <- key
''';

const String _insertionCpp = '''void insertionSort(std::vector<int>& arr) {
  for (std::size_t i = 1; i < arr.size(); ++i) {
  int key = arr[i];
  std::size_t j = i;
  while (j > 0 && arr[j - 1] > key) {
    arr[j] = arr[j - 1];
    --j;
  }
  arr[j] = key;
  }
}
''';

const String _insertionPython = '''def insertion_sort(values):
  arr = values[:]
  for i in range(1, len(arr)):
    key = arr[i]
    j = i - 1
    while j >= 0 and arr[j] > key:
      arr[j + 1] = arr[j]
      j -= 1
    arr[j + 1] = key
  return arr
''';

const String _insertionJava = '''public static void insertionSort(int[] arr) {
  for (int i = 1; i < arr.length; i++) {
    int key = arr[i];
    int j = i - 1;
    while (j >= 0 && arr[j] > key) {
      arr[j + 1] = arr[j];
      j--;
    }
    arr[j + 1] = key;
  }
}
''';

const String _mergePseudoCode = '''procedure mergeSort(arr):
  if length(arr) <= 1:
    return arr
  mid <- length(arr) / 2
  left <- mergeSort(arr[0..mid))
  right <- mergeSort(arr[mid..length(arr)))
  return merge(left, right)

procedure merge(left, right):
  result <- empty list
  while left and right are not empty:
    if left[0] <= right[0]:
      append left[0] to result
      remove left[0] from left
    else:
      append right[0] to result
      remove right[0] from right
  append remaining elements of left to result
  append remaining elements of right to result
  return result
''';

const String _mergeCpp =
    '''void merge(std::vector<int>& arr, int left, int mid, int right) {
  std::vector<int> temp(right - left + 1);
  int i = left;
  int j = mid + 1;
  int k = 0;

  while (i <= mid && j <= right) {
    if (arr[i] <= arr[j]) {
      temp[k++] = arr[i++];
    } else {
      temp[k++] = arr[j++];
    }
  }

  while (i <= mid) {
    temp[k++] = arr[i++];
  }

  while (j <= right) {
    temp[k++] = arr[j++];
  }

  for (int idx = 0; idx < static_cast<int>(temp.size()); ++idx) {
    arr[left + idx] = temp[idx];
  }
}

void mergeSort(std::vector<int>& arr, int left, int right) {
  if (left >= right) {
    return;
  }
  int mid = left + (right - left) / 2;
  mergeSort(arr, left, mid);
  mergeSort(arr, mid + 1, right);
  merge(arr, left, mid, right);
}
''';

const String _mergePython = '''def merge_sort(values):
  arr = values[:]

  def merge(left, right):
    merged = []
    i = j = 0
    while i < len(left) and j < len(right):
      if left[i] <= right[j]:
        merged.append(left[i])
        i += 1
      else:
        merged.append(right[j])
        j += 1
    merged.extend(left[i:])
    merged.extend(right[j:])
    return merged

  def sort(segment):
    if len(segment) <= 1:
      return segment
    mid = len(segment) // 2
    left = sort(segment[:mid])
    right = sort(segment[mid:])
    return merge(left, right)

  return sort(arr)
''';

const String _mergeJava =
    '''private static void merge(int[] arr, int left, int mid, int right) {
  int[] temp = new int[right - left + 1];
  int i = left;
  int j = mid + 1;
  int k = 0;

  while (i <= mid && j <= right) {
    if (arr[i] <= arr[j]) {
      temp[k++] = arr[i++];
    } else {
      temp[k++] = arr[j++];
    }
  }

  while (i <= mid) {
    temp[k++] = arr[i++];
  }

  while (j <= right) {
    temp[k++] = arr[j++];
  }

  for (int idx = 0; idx < temp.length; idx++) {
    arr[left + idx] = temp[idx];
  }
}

public static void mergeSort(int[] arr, int left, int right) {
  if (left >= right) {
    return;
  }
  int mid = left + (right - left) / 2;
  mergeSort(arr, left, mid);
  mergeSort(arr, mid + 1, right);
  merge(arr, left, mid, right);
}
''';

final SortingAlgorithmConfig selectionSortConfig = SortingAlgorithmConfig(
  id: SortingAlgorithmId.selection,
  algorithm: SelectionSort(),
  data: AlgorithmPageData(
    name: 'Selection Sort',
    tagline:
        'Trace how Selection Sort grows a sorted prefix by scanning for minima.',
    conceptSummary:
        'Selection Sort splits the list into a sorted prefix and an unsorted suffix. Each pass scans the suffix to find the minimum element and swaps it into the front, expanding the sorted region.',
    conceptPoints: [
      'Assume the first unsorted value is the current minimum.',
      'Walk the suffix to discover a smaller candidate index.',
      'Swap the discovered minimum into the front of the suffix.',
      'Grow the sorted prefix until no unsorted values remain.',
    ],
    conceptUsage:
        'Use Selection Sort to highlight search-and-swap patterns, prove algorithm invariants, or work with tiny arrays where clarity is more important than speed.',
    dryRuns: [
      DryRunPass(
        title: 'Pass 1',
        highlight: 'Find the smallest value and move it into the first slot.',
        steps: [
          'Assume index 0 (value 5) is the minimum.',
          'Compare value 1 with current minimum 5 -> update minimum to index 1.',
          'Compare value 4 with minimum 1 -> keep current minimum.',
          'Compare value 2 with minimum 1 -> keep current minimum.',
          'Compare value 8 with minimum 1 -> keep current minimum.',
          'Swap index 0 with index 1 -> [1, 5, 4, 2, 8].',
          'Mark index 0 as sorted.',
        ],
      ),
      DryRunPass(
        title: 'Pass 2',
        highlight: 'Search the remaining suffix for the next smallest value.',
        steps: [
          'Assume index 1 (value 5) is the new minimum.',
          'Compare value 4 with minimum 5 -> update minimum to index 2.',
          'Compare value 2 with minimum 4 -> update minimum to index 3.',
          'Compare value 8 with minimum 2 -> keep current minimum.',
          'Swap index 1 with index 3 -> [1, 2, 4, 5, 8].',
          'Mark index 1 as sorted.',
        ],
      ),
      DryRunPass(
        title: 'Pass 3',
        highlight: 'Sorted prefix expands even when no swap is required.',
        steps: [
          'Assume index 2 (value 4) is the minimum.',
          'Compare value 5 with minimum 4 -> keep current minimum.',
          'Compare value 8 with minimum 4 -> keep current minimum.',
          'No swap needed; index 2 stays in place.',
          'Mark index 2 as sorted; the remaining tail is already ordered.',
        ],
      ),
    ],
    complexity: [
      ComplexityItem(
        title: 'Best Case',
        complexity: 'O(n²)',
        note: 'Selection Sort still scans the suffix even when already sorted.',
      ),
      ComplexityItem(
        title: 'Average Case',
        complexity: 'O(n²)',
        note: 'Every pass performs a full scan of the shrinking suffix.',
      ),
      ComplexityItem(
        title: 'Worst Case',
        complexity: 'O(n²)',
        note: 'Reversed input does not change the fixed scan pattern.',
      ),
      ComplexityItem(
        title: 'Space',
        complexity: 'O(1)',
        note: 'In-place swapping only needs one temporary variable.',
      ),
    ],
    pseudoCode: _selectionPseudoCode,
    implementations: {
      'C++': _selectionCpp,
      'Python': _selectionPython,
      'Java': _selectionJava,
    },
  ),
);

final SortingAlgorithmConfig insertionSortConfig = SortingAlgorithmConfig(
  id: SortingAlgorithmId.insertion,
  algorithm: InsertionSort(),
  data: AlgorithmPageData(
    name: 'Insertion Sort',
    tagline: 'Slide each element into place as the sorted prefix grows.',
    conceptSummary:
        'Insertion Sort builds a sorted prefix one element at a time, sliding larger entries to the right until the current key fits its position.',
    conceptPoints: [
      'Treat the left portion of the array as an already sorted prefix.',
      'Choose the next value (the key) and compare it with elements to its left.',
      'Shift larger elements one slot to the right to make room for the key.',
      'Drop the key into the gap and extend the sorted prefix by one.',
    ],
    conceptUsage:
        'Reach for Insertion Sort when the input is small, nearly sorted, or streaming in real time so partial results stay ordered.',
    dryRuns: [
      DryRunPass(
        title: 'Pass 1',
        highlight:
            'Insert value 1 before 5 to establish the first sorted pair.',
        steps: [
          'Key = 1 compares with 5 -> shift 5 right -> [5, 5, 4, 2, 8].',
          'Place key 1 at index 0 -> [1, 5, 4, 2, 8].',
        ],
      ),
      DryRunPass(
        title: 'Pass 2',
        highlight: 'Value 4 slots between 1 and 5 after one comparison.',
        steps: [
          'Key = 4 compares with 5 -> shift 5 right -> [1, 5, 5, 2, 8].',
          'Place key 4 at index 1 -> [1, 4, 5, 2, 8].',
        ],
      ),
      DryRunPass(
        title: 'Pass 3',
        highlight:
            'Value 2 ripples left through multiple shifts before landing.',
        steps: [
          'Key = 2 compares with 5 -> shift 5 right -> [1, 4, 5, 5, 8].',
          'Key = 2 compares with 4 -> shift 4 right -> [1, 4, 4, 5, 8].',
          'Place key 2 at index 1 -> [1, 2, 4, 5, 8].',
        ],
      ),
    ],
    complexity: [
      ComplexityItem(
        title: 'Best Case',
        complexity: 'O(n)',
        note: 'Already sorted input only checks each neighbour once.',
      ),
      ComplexityItem(
        title: 'Average Case',
        complexity: 'O(n²)',
        note: 'About half of the sorted prefix shifts for each insertion.',
      ),
      ComplexityItem(
        title: 'Worst Case',
        complexity: 'O(n²)',
        note: 'Descending input forces a full shift for every key.',
      ),
      ComplexityItem(
        title: 'Space',
        complexity: 'O(1)',
        note: 'Only a single key variable is used for temporary storage.',
      ),
    ],
    pseudoCode: _insertionPseudoCode,
    implementations: {
      'C++': _insertionCpp,
      'Python': _insertionPython,
      'Java': _insertionJava,
    },
  ),
);

final SortingAlgorithmConfig bubbleSortConfig = SortingAlgorithmConfig(
  id: SortingAlgorithmId.bubble,
  algorithm: BubbleSort(),
  data: AlgorithmPageData(
    name: 'Bubble Sort',
    tagline: 'See adjacent swaps push heavier values toward the end each pass.',
    conceptSummary:
        'Bubble Sort is a comparison-driven routine that repeatedly walks through a list, switching neighbouring values that appear in the wrong order. After each pass the largest value "bubbles" to the end of the list.',
    conceptPoints: [
      'Start at the beginning of the array and compare items in pairs.',
      'Swap the pair when the left item is larger than the right one.',
      'Shrink the unsorted portion from the end after every sweep.',
      'Abort early if a pass completes without any swaps.',
    ],
    conceptUsage:
        'Reach for Bubble Sort when teaching comparison-based sorting, animating algorithm intuition, or working with tiny datasets where simplicity matters more than speed.',
    dryRuns: [
      DryRunPass(
        title: 'Pass 1',
        highlight:
            'Largest value moves to the far right after the first sweep.',
        steps: [
          'Compare 5 and 1 -> swap -> [1, 5, 4, 2, 8]',
          'Compare 5 and 4 -> swap -> [1, 4, 5, 2, 8]',
          'Compare 5 and 2 -> swap -> [1, 4, 2, 5, 8]',
          'Compare 5 and 8 -> keep -> [1, 4, 2, 5, 8]',
        ],
      ),
      DryRunPass(
        title: 'Pass 2',
        highlight:
            'Next heaviest element settles one slot before the sorted tail.',
        steps: [
          'Compare 1 and 4 -> keep -> [1, 4, 2, 5, 8]',
          'Compare 4 and 2 -> swap -> [1, 2, 4, 5, 8]',
          'Compare 4 and 5 -> keep -> [1, 2, 4, 5, 8]',
        ],
      ),
      DryRunPass(
        title: 'Pass 3',
        highlight: 'No swaps means the list is sorted; algorithm stops early.',
        steps: [
          'Compare 1 and 2 -> keep -> [1, 2, 4, 5, 8]',
          'Compare 2 and 4 -> keep -> [1, 2, 4, 5, 8]',
        ],
      ),
    ],
    complexity: [
      ComplexityItem(
        title: 'Best Case',
        complexity: 'O(n)',
        note: 'Already sorted lists need just one pass to confirm order.',
      ),
      ComplexityItem(
        title: 'Average Case',
        complexity: 'O(n²)',
        note: 'Roughly half of the neighbouring pairs require inspection.',
      ),
      ComplexityItem(
        title: 'Worst Case',
        complexity: 'O(n²)',
        note: 'A reversed list triggers every possible comparison and swap.',
      ),
      ComplexityItem(
        title: 'Space',
        complexity: 'O(1)',
        note: 'Sorting happens in-place with a single temporary variable.',
      ),
    ],
    pseudoCode: _bubblePseudoCode,
    implementations: {
      'C++': _bubbleCpp,
      'Python': _bubblePython,
      'Java': _bubbleJava,
    },
  ),
);

final SortingAlgorithmConfig mergeSortConfig = SortingAlgorithmConfig(
  id: SortingAlgorithmId.merge,
  algorithm: MergeSort(),
  data: AlgorithmPageData(
    name: 'Merge Sort',
    tagline:
        'Divide, conquer, and stitch halves together in linearithmic time.',
    conceptSummary:
        'Merge Sort recursively splits the list into halves, sorts each half, then merges the sorted runs back together to produce a fully ordered array.',
    conceptPoints: [
      'Recursively split the array until only single-element runs remain.',
      'Merge sibling runs by comparing the next value from each half.',
      'Copy the smaller front value into the merged output and advance that half.',
      'Append whatever remains when one half is exhausted to finish the run.',
    ],
    conceptUsage:
        'Choose Merge Sort for reliable O(n log n) performance, stable ordering, and workloads that benefit from streaming or external memory merges.',
    dryRuns: [
      DryRunPass(
        title: 'Divide phase',
        highlight:
            'Recursively split [5, 1, 4, 2, 8] into single-element runs.',
        steps: [
          'Split into [5, 1, 4] and [2, 8].',
          'Split [5, 1, 4] into [5, 1] and [4].',
          'Split [5, 1] into [5] and [1].',
          'Base case reached: each sub-array now contains one value.',
        ],
      ),
      DryRunPass(
        title: 'Merge size 2 runs',
        highlight:
            'Build sorted pairs while stepping back up the recursion tree.',
        steps: [
          'Merge [5] and [1] -> [1, 5].',
          'Merge [2] and [8] -> [2, 8].',
          'Current runs: [1, 5], [4], [2, 8].',
        ],
      ),
      DryRunPass(
        title: 'Merge the final runs',
        highlight: 'Combine [1, 4, 5] with [2, 8] to finish the sort.',
        steps: [
          'Merge [1, 5] with [4] -> [1, 4, 5].',
          'Merge [1, 4, 5] with [2, 8] -> [1, 2, 4, 5, 8].',
          'All elements are now in ascending order.',
        ],
      ),
    ],
    complexity: [
      ComplexityItem(
        title: 'Best Case',
        complexity: 'O(n log n)',
        note:
            'Even sorted input still requires merging each level of the tree.',
      ),
      ComplexityItem(
        title: 'Average Case',
        complexity: 'O(n log n)',
        note:
            'Balanced splitting and merging keeps work proportional to n log n.',
      ),
      ComplexityItem(
        title: 'Worst Case',
        complexity: 'O(n log n)',
        note:
            'Every element participates in each level of merging regardless of order.',
      ),
      ComplexityItem(
        title: 'Space',
        complexity: 'O(n)',
        note: 'Temporary buffers store merged runs before copying back.',
      ),
    ],
    pseudoCode: _mergePseudoCode,
    implementations: {
      'C++': _mergeCpp,
      'Python': _mergePython,
      'Java': _mergeJava,
    },
  ),
);

final Map<SortingAlgorithmId, SortingAlgorithmConfig> sortingAlgorithmCatalog =
    {
      SortingAlgorithmId.selection: selectionSortConfig,
      SortingAlgorithmId.insertion: insertionSortConfig,
      SortingAlgorithmId.bubble: bubbleSortConfig,
      SortingAlgorithmId.merge: mergeSortConfig,
    };

final List<SortingAlgorithmConfig> sortingAlgorithmList = [
  selectionSortConfig,
  insertionSortConfig,
  bubbleSortConfig,
  mergeSortConfig,
];
