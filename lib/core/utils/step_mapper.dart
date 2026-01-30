import 'package:algorythm_app/domain/algorithm_step.dart';
import 'package:algorythm_app/domain/step_type.dart';

import '../models/visual_bar.dart';
import '../models/visual_tile.dart';

List<VisualBar> mapStepToBars(
  AlgorithmStep step, {
  bool highlightInvariants = false,
}) {
  return List.generate(step.values.length, (index) {
    final bool isActive =
        (step.type == StepType.compare || step.type == StepType.swap) &&
        (index == step.indexA || index == step.indexB);

    if (isActive) {
      return VisualBar(
        step.values[index],
        step.type == StepType.compare ? BarState.comparing : BarState.swapping,
      );
    }

    if (step.sortedIndices.contains(index)) {
      return VisualBar(step.values[index], BarState.sorted);
    }

    if (highlightInvariants && step.invariantIndices.contains(index)) {
      return VisualBar(step.values[index], BarState.invariant);
    }

    return VisualBar(step.values[index], BarState.normal);
  });
}

List<VisualTile> mapStepToTile(
  AlgorithmStep step, {
  bool highlightInvariants = false,
}) {
  return List.generate(step.values.length, (index) {
    final bool isActive =
        (step.type == StepType.compare || step.type == StepType.swap) &&
        (index == step.indexA || index == step.indexB);

    if (isActive) {
      return VisualTile(
        step.values[index],
        step.type == StepType.compare
            ? TileState.comparing
            : TileState.swapping,
      );
    }

    if (step.sortedIndices.contains(index)) {
      return VisualTile(step.values[index], TileState.sorted);
    }

    if (highlightInvariants && step.invariantIndices.contains(index)) {
      return VisualTile(step.values[index], TileState.invariant);
    }

    return VisualTile(step.values[index], TileState.normal);
  });
}
