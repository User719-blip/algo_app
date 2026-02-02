import 'package:algorythm_app/algorithms/arrays/array_algorithm.dart';
import 'package:algorythm_app/core/models/algorithm_page_data.dart';

enum ArrayAlgorithmId { kadane }

class ArrayAlgorithmConfig {
  final ArrayAlgorithmId id;
  final ArrayAlgorithm algorithm;
  final AlgorithmPageData data;
  final List<int> demoInput;

  const ArrayAlgorithmConfig({
    required this.id,
    required this.algorithm,
    required this.data,
    required this.demoInput,
  });
}
