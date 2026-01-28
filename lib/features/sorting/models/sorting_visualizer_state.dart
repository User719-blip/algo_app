import 'package:algorythm_app/core/models/algorithm_page_data.dart';
import 'package:algorythm_app/domain/algorithm_step.dart';
import 'package:algorythm_app/features/sorting/data/sorting_algorithms.dart';

import 'sorting_playback_state.dart';

class SortingVisualizerState {
  final SortingAlgorithmId activeAlgorithm;
  final AlgorithmPageData data;
  final List<AlgorithmStep> steps;
  final SortingPlaybackState barPlayback;
  final SortingPlaybackState tilePlayback;

  const SortingVisualizerState({
    required this.activeAlgorithm,
    required this.data,
    required this.steps,
    this.barPlayback = SortingPlaybackState.empty,
    this.tilePlayback = SortingPlaybackState.empty,
  });

  SortingVisualizerState copyWith({
    SortingAlgorithmId? activeAlgorithm,
    AlgorithmPageData? data,
    List<AlgorithmStep>? steps,
    SortingPlaybackState? barPlayback,
    SortingPlaybackState? tilePlayback,
  }) {
    return SortingVisualizerState(
      activeAlgorithm: activeAlgorithm ?? this.activeAlgorithm,
      data: data ?? this.data,
      steps: steps ?? this.steps,
      barPlayback: barPlayback ?? this.barPlayback,
      tilePlayback: tilePlayback ?? this.tilePlayback,
    );
  }
}
