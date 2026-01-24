import 'package:algorythm_app/domain/step_type.dart';

class AlgorithmStep {
  final List<int> values;
  final StepType type;
  final int? indexA;
  final int? indexB;
  final Set<int> sortedIndices;

  AlgorithmStep({
    required this.values,
    required this.type,
    required this.indexA,
    required this.indexB,
    Set<int>? sortedIndices,
  }) : sortedIndices = sortedIndices == null
           ? const <int>{}
           : Set.unmodifiable(sortedIndices);
}
