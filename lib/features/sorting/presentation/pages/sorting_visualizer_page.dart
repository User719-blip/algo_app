import 'dart:async';

import 'package:algorythm_app/core/models/algorithm_page_data.dart';
import 'package:algorythm_app/core/models/visual_bar.dart';
import 'package:algorythm_app/core/models/visual_tile.dart';
import 'package:algorythm_app/core/theme/app_colors.dart';
import 'package:algorythm_app/core/utils/step_mapper.dart';
import 'package:algorythm_app/domain/algorithm_step.dart';
import 'package:algorythm_app/domain/step_type.dart';
import 'package:algorythm_app/features/sorting/data/sorting_algorithms.dart';
import 'package:algorythm_app/features/sorting/presentation/widgets/sorting_concept_section.dart';
import 'package:algorythm_app/features/sorting/presentation/widgets/sorting_resources_section.dart';
import 'package:algorythm_app/features/sorting/presentation/widgets/sorting_visualization_section.dart';
import 'package:flutter/material.dart';

enum _PlaybackChannel { bars, tiles }

class _PlaybackState extends ChangeNotifier {
  _PlaybackState({int index = 0, bool playing = false})
    : _index = index,
      _playing = playing;

  int _index;
  bool _playing;

  int get index => _index;
  bool get playing => _playing;

  void update({int? index, bool? playing, bool notify = true}) {
    bool hasChanged = false;
    if (index != null && index != _index) {
      _index = index;
      hasChanged = true;
    }
    if (playing != null && playing != _playing) {
      _playing = playing;
      hasChanged = true;
    }
    if (hasChanged && notify) {
      notifyListeners();
    }
  }

  void reset({bool notify = true}) {
    update(index: 0, playing: false, notify: notify);
  }
}

class SortingVisualizerPage extends StatefulWidget {
  final SortingAlgorithmId initialAlgorithm;

  const SortingVisualizerPage({
    super.key,
    this.initialAlgorithm = SortingAlgorithmId.selection,
  });

  @override
  State<SortingVisualizerPage> createState() => _SortingVisualizerPageState();
}

class _SortingVisualizerPageState extends State<SortingVisualizerPage> {
  static const Duration _playbackInterval = Duration(milliseconds: 600);

  late SortingAlgorithmId _activeAlgorithm;
  late AlgorithmPageData _data;
  late List<AlgorithmStep> _steps;

  Timer? _barTimer;
  Timer? _tileTimer;

  late final _PlaybackState _barPlayback;
  late final _PlaybackState _tilePlayback;

  @override
  void initState() {
    super.initState();
    _barPlayback = _PlaybackState();
    _tilePlayback = _PlaybackState();
    _applyAlgorithm(widget.initialAlgorithm, initial: true);
  }

  void _applyAlgorithm(SortingAlgorithmId algorithm, {bool initial = false}) {
    _cancelTimer(_PlaybackChannel.bars);
    _cancelTimer(_PlaybackChannel.tiles);

    final config = sortingAlgorithmCatalog[algorithm]!;
    final steps = config.algorithm.generateSteps(kSortingDemoInput);

    void assign() {
      _activeAlgorithm = algorithm;
      _data = config.data;
      _steps = steps;
      _barPlayback.reset(notify: !initial);
      _tilePlayback.reset(notify: !initial);
    }

    if (initial) {
      assign();
    } else {
      setState(assign);
    }
  }

  @override
  void dispose() {
    _cancelTimer(_PlaybackChannel.bars);
    _cancelTimer(_PlaybackChannel.tiles);
    _barPlayback.dispose();
    _tilePlayback.dispose();
    super.dispose();
  }

  _PlaybackState _playbackFor(_PlaybackChannel channel) {
    return channel == _PlaybackChannel.bars ? _barPlayback : _tilePlayback;
  }

  Timer? _timerFor(_PlaybackChannel channel) {
    return channel == _PlaybackChannel.bars ? _barTimer : _tileTimer;
  }

  void _storeTimer(_PlaybackChannel channel, Timer? timer) {
    if (channel == _PlaybackChannel.bars) {
      _barTimer = timer;
    } else {
      _tileTimer = timer;
    }
  }

  void _cancelTimer(_PlaybackChannel channel) {
    final Timer? timer = _timerFor(channel);
    if (timer != null) {
      timer.cancel();
    }
    _storeTimer(channel, null);
  }

  void _handleTick(_PlaybackChannel channel, Timer timer) {
    if (!mounted) {
      timer.cancel();
      return;
    }

    final playback = _playbackFor(channel);
    final int currentIndex = playback.index;
    if (currentIndex >= _steps.length - 1) {
      _cancelTimer(channel);
      playback.update(playing: false);
      return;
    }

    playback.update(index: currentIndex + 1);
  }

  void _startPlayback(_PlaybackChannel channel) {
    _cancelTimer(channel);

    final timer = Timer.periodic(
      _playbackInterval,
      (currentTimer) => _handleTick(channel, currentTimer),
    );

    _storeTimer(channel, timer);
    _playbackFor(channel).update(playing: true);
  }

  void _pausePlayback(_PlaybackChannel channel) {
    _cancelTimer(channel);
    _playbackFor(channel).update(playing: false);
  }

  void _togglePlayback(_PlaybackChannel channel) {
    final playback = _playbackFor(channel);
    if (playback.playing) {
      _pausePlayback(channel);
      return;
    }

    if (playback.index >= _steps.length - 1) {
      playback.update(index: 0);
    }

    _startPlayback(channel);
  }

  void _stepForward(_PlaybackChannel channel) {
    final playback = _playbackFor(channel);
    if (playback.index >= _steps.length - 1) {
      return;
    }

    _pausePlayback(channel);
    playback.update(index: playback.index + 1);
  }

  void _stepBackward(_PlaybackChannel channel) {
    final playback = _playbackFor(channel);
    if (playback.index == 0) {
      return;
    }

    _pausePlayback(channel);
    playback.update(index: playback.index - 1);
  }

  void _resetPlayback(_PlaybackChannel channel) {
    _pausePlayback(channel);
    _playbackFor(channel).update(index: 0);
  }

  double _progressFor(int index) {
    if (_steps.length <= 1) {
      return 0;
    }
    return index / (_steps.length - 1);
  }

  String _stepLabel(AlgorithmStep step) {
    switch (step.type) {
      case StepType.compare:
        return 'Comparing index ${step.indexA} and ${step.indexB}';
      case StepType.swap:
        return 'Swapping index ${step.indexA} with ${step.indexB}';
      case StepType.sorted:
        return 'Index ${step.indexA} is locked in place';
    }
  }

  Color _accentForStep(AlgorithmStep step) {
    switch (step.type) {
      case StepType.compare:
        return AppColors.compare;
      case StepType.swap:
        return AppColors.swap;
      case StepType.sorted:
        return AppColors.sorted;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.gradientTop, AppColors.gradientBottom],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '${_data.name} Visual Guide',
                  style: theme.textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  _data.tagline,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.center,
                  child: SegmentedButton<SortingAlgorithmId>(
                    showSelectedIcon: false,
                    segments: sortingAlgorithmList
                        .map(
                          (config) => ButtonSegment<SortingAlgorithmId>(
                            value: config.id,
                            label: Text(config.data.name),
                          ),
                        )
                        .toList(),
                    selected: {_activeAlgorithm},
                    style: ButtonStyle(
                      padding: const WidgetStatePropertyAll(
                        EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                      ),
                      foregroundColor: WidgetStateProperty.resolveWith(
                        (states) => Colors.white,
                      ),
                      backgroundColor: WidgetStateProperty.resolveWith(
                        (states) => states.contains(WidgetState.selected)
                            ? AppColors.sorted.withValues(alpha: 0.2)
                            : Colors.white.withValues(alpha: 0.08),
                      ),
                      side: WidgetStateProperty.resolveWith(
                        (states) => BorderSide(
                          color: Colors.white.withValues(alpha: 0.25),
                        ),
                      ),
                      overlayColor: WidgetStatePropertyAll(
                        Colors.white.withValues(alpha: 0.12),
                      ),
                      textStyle: WidgetStatePropertyAll(
                        theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ) ??
                            const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    onSelectionChanged: (selection) {
                      final next = selection.first;
                      if (next != _activeAlgorithm) {
                        _applyAlgorithm(next);
                      }
                    },
                  ),
                ),
                const SizedBox(height: 32),
                SortingConceptSection(data: _data),
                const SizedBox(height: 28),
                AnimatedBuilder(
                  animation: _barPlayback,
                  builder: (context, _) {
                    final int barIndex = _barPlayback.index;
                    final AlgorithmStep barStep = _steps[barIndex];
                    final List<VisualBar> bars = mapStepToBars(barStep);
                    final double barProgress = _progressFor(barIndex);
                    return SortingVisualizationSection(
                      bars: bars,
                      complexity: _data.complexity,
                      stepLabel: _stepLabel(barStep),
                      accent: _accentForStep(barStep),
                      progress: barProgress,
                      currentIndex: barIndex,
                      totalSteps: _steps.length,
                      isPlaying: _barPlayback.playing,
                      onPlayPause: () => _togglePlayback(_PlaybackChannel.bars),
                      onStepBack: barIndex == 0
                          ? null
                          : () => _stepBackward(_PlaybackChannel.bars),
                      onStepForward: barIndex >= _steps.length - 1
                          ? null
                          : () => _stepForward(_PlaybackChannel.bars),
                      onReset: barIndex == 0 && !_barPlayback.playing
                          ? null
                          : () => _resetPlayback(_PlaybackChannel.bars),
                    );
                  },
                ),
                const SizedBox(height: 28),
                AnimatedBuilder(
                  animation: _barPlayback,
                  builder: (context, _) {
                    final int barIndex = _barPlayback.index;
                    final AlgorithmStep barStep = _steps[barIndex];
                    final List<VisualBar> bars = mapStepToBars(barStep);
                    final bool barPlaying = _barPlayback.playing;

                    return AnimatedBuilder(
                      animation: _tilePlayback,
                      builder: (context, __) {
                        final int tileIndex = _tilePlayback.index;
                        final AlgorithmStep tileStep = _steps[tileIndex];
                        final List<VisualTile> tiles = mapStepToTile(tileStep);
                        final bool tilePlaying = _tilePlayback.playing;
                        final double barProgress = _progressFor(barIndex);
                        final double tileProgress = _progressFor(tileIndex);

                        return SortingResourcesSection(
                          dryRuns: _data.dryRuns,
                          pseudoCode: _data.pseudoCode,
                          implementations: _data.implementations,
                          barVisual: bars,
                          tileVisual: tiles,
                          barDescription: _stepLabel(barStep),
                          tileDescription: _stepLabel(tileStep),
                          barAccent: _accentForStep(barStep),
                          tileAccent: _accentForStep(tileStep),
                          barProgress: barProgress,
                          tileProgress: tileProgress,
                          barStepLabel:
                              'Step ${barIndex + 1} / ${_steps.length}',
                          tileStepLabel:
                              'Step ${tileIndex + 1} / ${_steps.length}',
                          isBarPlaying: barPlaying,
                          isTilePlaying: tilePlaying,
                          onBarPlayPause: () =>
                              _togglePlayback(_PlaybackChannel.bars),
                          onTilePlayPause: () =>
                              _togglePlayback(_PlaybackChannel.tiles),
                          onBarStepBack: barIndex == 0
                              ? null
                              : () => _stepBackward(_PlaybackChannel.bars),
                          onBarStepForward: barIndex >= _steps.length - 1
                              ? null
                              : () => _stepForward(_PlaybackChannel.bars),
                          onTileStepBack: tileIndex == 0
                              ? null
                              : () => _stepBackward(_PlaybackChannel.tiles),
                          onTileStepForward: tileIndex >= _steps.length - 1
                              ? null
                              : () => _stepForward(_PlaybackChannel.tiles),
                          onBarReset: barIndex == 0 && !barPlaying
                              ? null
                              : () => _resetPlayback(_PlaybackChannel.bars),
                          onTileReset: tileIndex == 0 && !tilePlaying
                              ? null
                              : () => _resetPlayback(_PlaybackChannel.tiles),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
