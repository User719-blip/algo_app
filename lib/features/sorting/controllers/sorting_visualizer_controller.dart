import 'dart:async';

import 'package:algorythm_app/core/models/visual_bar.dart';
import 'package:algorythm_app/core/models/visual_tile.dart';
import 'package:algorythm_app/core/theme/app_colors.dart';
import 'package:algorythm_app/core/utils/step_mapper.dart';
import 'package:algorythm_app/domain/algorithm_step.dart';
import 'package:algorythm_app/domain/step_type.dart';
import 'package:algorythm_app/features/sorting/data/sorting_algorithms.dart';
import 'package:algorythm_app/features/sorting/models/sorting_playback_state.dart';
import 'package:algorythm_app/features/sorting/models/sorting_visualizer_state.dart';
import 'package:flutter/material.dart';

enum SortingPlaybackChannel { bars, tiles }

class SortingVisualizerController extends ChangeNotifier {
  SortingVisualizerController({
    SortingAlgorithmId initialAlgorithm = SortingAlgorithmId.selection,
    Duration playbackInterval = const Duration(milliseconds: 600),
  }) : _playbackInterval = playbackInterval {
    _loadAlgorithm(initialAlgorithm, notify: false);
  }

  final Duration _playbackInterval;

  SortingVisualizerState? _state;
  Timer? _barTimer;
  Timer? _tileTimer;

  SortingVisualizerState get state {
    final currentState = _state;
    if (currentState == null) {
      throw StateError('SortingVisualizerController accessed before init.');
    }
    return currentState;
  }

  List<AlgorithmStep> get _steps => state.steps;

  SortingPlaybackState get barPlayback => state.barPlayback;
  SortingPlaybackState get tilePlayback => state.tilePlayback;

  AlgorithmStep get barStep => _steps[barPlayback.index];
  AlgorithmStep get tileStep => _steps[tilePlayback.index];

  List<VisualBar> get barVisual => mapStepToBars(barStep);
  List<VisualTile> get tileVisual => mapStepToTile(tileStep);

  String get barStepLabel => 'Step ${barPlayback.index + 1} / ${_steps.length}';
  String get tileStepLabel =>
      'Step ${tilePlayback.index + 1} / ${_steps.length}';

  double get barProgress => _progressFor(barPlayback.index);
  double get tileProgress => _progressFor(tilePlayback.index);

  String describeStep(AlgorithmStep step) {
    switch (step.type) {
      case StepType.compare:
        return 'Comparing index ${step.indexA} and ${step.indexB}';
      case StepType.swap:
        return 'Swapping index ${step.indexA} with ${step.indexB}';
      case StepType.sorted:
        return 'Index ${step.indexA} is locked in place';
    }
  }

  Color accentForStep(AlgorithmStep step) {
    switch (step.type) {
      case StepType.compare:
        return AppColors.compare;
      case StepType.swap:
        return AppColors.swap;
      case StepType.sorted:
        return AppColors.sorted;
    }
  }

  void selectAlgorithm(SortingAlgorithmId algorithm) {
    _cancelTimer(SortingPlaybackChannel.bars);
    _cancelTimer(SortingPlaybackChannel.tiles);
    _loadAlgorithm(algorithm);
  }

  void togglePlayback(SortingPlaybackChannel channel) {
    final playback = _playbackFor(channel);
    if (playback.playing) {
      pausePlayback(channel);
      return;
    }

    if (playback.index >= _steps.length - 1) {
      _updatePlayback(
        channel,
        const SortingPlaybackState(index: 0, playing: false),
      );
    }

    _startPlayback(channel);
  }

  void pausePlayback(SortingPlaybackChannel channel) {
    _cancelTimer(channel);
    final playback = _playbackFor(channel);
    if (playback.playing) {
      _updatePlayback(channel, playback.copyWith(playing: false));
    }
  }

  void resetPlayback(SortingPlaybackChannel channel) {
    pausePlayback(channel);
    _updatePlayback(
      channel,
      const SortingPlaybackState(index: 0, playing: false),
    );
  }

  void stepForward(SortingPlaybackChannel channel) {
    final playback = _playbackFor(channel);
    if (playback.index >= _steps.length - 1) {
      return;
    }
    pausePlayback(channel);
    _updatePlayback(channel, playback.copyWith(index: playback.index + 1));
  }

  void stepBackward(SortingPlaybackChannel channel) {
    final playback = _playbackFor(channel);
    if (playback.index == 0) {
      return;
    }
    pausePlayback(channel);
    _updatePlayback(channel, playback.copyWith(index: playback.index - 1));
  }

  bool get isInitialized => _state != null;

  @override
  void dispose() {
    _cancelTimer(SortingPlaybackChannel.bars);
    _cancelTimer(SortingPlaybackChannel.tiles);
    super.dispose();
  }

  void _loadAlgorithm(SortingAlgorithmId algorithm, {bool notify = true}) {
    final config = sortingAlgorithmCatalog[algorithm]!;
    final steps = config.algorithm.generateSteps(kSortingDemoInput);
    _state = SortingVisualizerState(
      activeAlgorithm: algorithm,
      data: config.data,
      steps: steps,
      barPlayback: const SortingPlaybackState(),
      tilePlayback: const SortingPlaybackState(),
    );
    if (notify) {
      notifyListeners();
    }
  }

  SortingPlaybackState _playbackFor(SortingPlaybackChannel channel) {
    return channel == SortingPlaybackChannel.bars ? barPlayback : tilePlayback;
  }

  void _startPlayback(SortingPlaybackChannel channel) {
    _cancelTimer(channel);
    final timer = Timer.periodic(
      _playbackInterval,
      (currentTimer) => _handleTick(channel, currentTimer),
    );
    _storeTimer(channel, timer);
    _updatePlayback(channel, _playbackFor(channel).copyWith(playing: true));
  }

  void _handleTick(SortingPlaybackChannel channel, Timer timer) {
    if (!hasListeners) {
      timer.cancel();
      return;
    }

    final playback = _playbackFor(channel);
    if (playback.index >= _steps.length - 1) {
      _cancelTimer(channel);
      _updatePlayback(channel, playback.copyWith(playing: false));
      return;
    }

    _updatePlayback(channel, playback.copyWith(index: playback.index + 1));
  }

  void _cancelTimer(SortingPlaybackChannel channel) {
    final timer = channel == SortingPlaybackChannel.bars
        ? _barTimer
        : _tileTimer;
    timer?.cancel();
    _storeTimer(channel, null);
  }

  void _storeTimer(SortingPlaybackChannel channel, Timer? timer) {
    if (channel == SortingPlaybackChannel.bars) {
      _barTimer = timer;
    } else {
      _tileTimer = timer;
    }
  }

  void _updatePlayback(
    SortingPlaybackChannel channel,
    SortingPlaybackState value,
  ) {
    final currentState = state;
    if (channel == SortingPlaybackChannel.bars) {
      _state = currentState.copyWith(barPlayback: value);
    } else {
      _state = currentState.copyWith(tilePlayback: value);
    }
    notifyListeners();
  }

  double _progressFor(int index) {
    if (_steps.length <= 1) {
      return 0;
    }
    return index / (_steps.length - 1);
  }
}
