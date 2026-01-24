import 'package:algorythm_app/domain/algorithm_step.dart';
import 'package:algorythm_app/domain/step_type.dart';
import 'package:algorythm_app/presentation/models/visual_bar.dart';
import 'package:algorythm_app/presentation/models/visual_tile.dart';

List<VisualBar> mapStepToBars(AlgorithmStep step) {
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

    return VisualBar(step.values[index], BarState.normal);
  });
}

List<VisualTile> mapStepToTile(AlgorithmStep step) {
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

    return VisualTile(step.values[index], TileState.normal);
  });
}
