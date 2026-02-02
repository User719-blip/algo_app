import 'package:algorythm_app/core/models/algorithm_page_data.dart';
import 'package:algorythm_app/domain/array_frame.dart';

import 'array_algorithm_config.dart';
import 'array_playback_state.dart';

class ArrayVisualizerState {
  final ArrayAlgorithmId activeAlgorithm;
  final AlgorithmPageData data;
  final List<ArrayFrame> frames;
  final ArrayPlaybackState playback;

  const ArrayVisualizerState({
    required this.activeAlgorithm,
    required this.data,
    required this.frames,
    required this.playback,
  });

  ArrayVisualizerState copyWith({
    ArrayAlgorithmId? activeAlgorithm,
    AlgorithmPageData? data,
    List<ArrayFrame>? frames,
    ArrayPlaybackState? playback,
  }) {
    return ArrayVisualizerState(
      activeAlgorithm: activeAlgorithm ?? this.activeAlgorithm,
      data: data ?? this.data,
      frames: frames ?? this.frames,
      playback: playback ?? this.playback,
    );
  }
}
