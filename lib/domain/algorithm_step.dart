import 'package:algorythm_app/domain/step_type.dart';

class AlgorithmStep {
  final List<int> values;
  final StepType type;
  final int? indexA;
  final int? indexB;
  final Set<int> sortedIndices;
  final Set<int> invariantIndices;
  final Map<int, String> invariantLabels;

  AlgorithmStep({
    required this.values,
    required this.type,
    required this.indexA,
    required this.indexB,
    Set<int>? sortedIndices,
    Set<int>? invariantIndices,
    Map<int, String>? invariantLabels,
  }) : sortedIndices = sortedIndices == null
           ? const <int>{}
           : Set.unmodifiable(sortedIndices),
       invariantIndices = invariantLabels != null
           ? Set.unmodifiable(invariantLabels.keys)
           : invariantIndices == null
           ? const <int>{}
           : Set.unmodifiable(invariantIndices),
       invariantLabels = invariantLabels == null
           ? const <int, String>{}
           : Map.unmodifiable(invariantLabels);
}
