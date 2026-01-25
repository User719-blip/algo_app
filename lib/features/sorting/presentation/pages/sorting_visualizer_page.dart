import 'dart:async';

import 'package:algorythm_app/core/models/algorithm_page_data.dart';
import 'package:algorythm_app/core/models/visual_bar.dart';
import 'package:algorythm_app/core/models/visual_tile.dart';
import 'package:algorythm_app/core/theme/app_colors.dart';
import 'package:algorythm_app/core/utils/step_mapper.dart';
import 'package:algorythm_app/core/widgets/algorithm_animation_panel.dart';
import 'package:algorythm_app/core/widgets/bar_section.dart';
import 'package:algorythm_app/core/widgets/bullet_text.dart';
import 'package:algorythm_app/core/widgets/code_block.dart';
import 'package:algorythm_app/core/widgets/playback_controls.dart';
import 'package:algorythm_app/core/widgets/section_container.dart';
import 'package:algorythm_app/core/widgets/section_paragraph.dart';
import 'package:algorythm_app/core/widgets/section_subheading.dart';
import 'package:algorythm_app/core/widgets/section_title.dart';
import 'package:algorythm_app/core/widgets/tile_section.dart';
import 'package:algorythm_app/domain/algorithm_step.dart';
import 'package:algorythm_app/domain/step_type.dart';
import 'package:algorythm_app/features/sorting/data/sorting_algorithms.dart';
import 'package:flutter/foundation.dart';
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

  TextStyle _highlightStyle(ThemeData theme) {
    return theme.textTheme.bodyMedium?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ) ??
        const TextStyle(color: Colors.white, fontWeight: FontWeight.w600);
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
                _buildConceptSection(theme),
                const SizedBox(height: 28),
                AnimatedBuilder(
                  animation: _barPlayback,
                  builder: (context, _) {
                    final int barIndex = _barPlayback.index;
                    final AlgorithmStep barStep = _steps[barIndex];
                    final List<VisualBar> bars = mapStepToBars(barStep);
                    return _buildVisualizationSection(
                      theme,
                      bars,
                      barStep,
                      barIndex,
                      _barPlayback.playing,
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

                        return _buildResourcesSection(
                          theme,
                          bars,
                          tiles,
                          barStep,
                          tileStep,
                          barIndex,
                          barPlaying,
                          tileIndex,
                          _tilePlayback.playing,
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

  Widget _buildConceptSection(ThemeData theme) {
    return SectionContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(title: '1. Conceptual Explanation'),
          const SizedBox(height: 16),
          SectionSubheading('What is ${_data.name}?'),
          const SizedBox(height: 8),
          SectionParagraph(_data.conceptSummary),
          const SizedBox(height: 18),
          const SectionSubheading('How it works'),
          const SizedBox(height: 8),
          ..._data.conceptPoints.map(BulletText.new),
          const SizedBox(height: 18),
          const SectionSubheading('When to use it'),
          const SizedBox(height: 8),
          SectionParagraph(_data.conceptUsage),
        ],
      ),
    );
  }

  Widget _buildVisualizationSection(
    ThemeData theme,
    List<VisualBar> bars,
    AlgorithmStep barStep,
    int barIndex,
    bool isPlaying,
  ) {
    final double barProgress = _progressFor(barIndex);

    return SectionContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(title: '2. Visualization & Complexity'),
          const SizedBox(height: 8),
          SectionParagraph(
            'Track every comparison and swap while keeping complexity facts within reach.',
          ),
          const SizedBox(height: 24),
          BarSection(bars: bars),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.center,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: _accentForStep(barStep).withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: _accentForStep(barStep).withValues(alpha: 0.35),
                ),
              ),
              child: Text(
                _stepLabel(barStep),
                style: _highlightStyle(theme),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 12,
            runSpacing: 12,
            children: [
              ControlIconButton(
                icon: Icons.rotate_left,
                tooltip: 'Reset to start',
                onTap: barIndex == 0 && !isPlaying
                    ? null
                    : () => _resetPlayback(_PlaybackChannel.bars),
              ),
              ControlIconButton(
                icon: Icons.skip_previous,
                tooltip: 'Previous step',
                onTap: barIndex == 0
                    ? null
                    : () => _stepBackward(_PlaybackChannel.bars),
              ),
              PlayPauseButton(
                isPlaying: isPlaying,
                onTap: () => _togglePlayback(_PlaybackChannel.bars),
              ),
              ControlIconButton(
                icon: Icons.skip_next,
                tooltip: 'Next step',
                onTap: barIndex >= _steps.length - 1
                    ? null
                    : () => _stepForward(_PlaybackChannel.bars),
              ),
            ],
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 6,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(
                value: barProgress,
                backgroundColor: Colors.white.withValues(alpha: 0.08),
                valueColor: AlwaysStoppedAnimation<Color>(
                  _accentForStep(barStep),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Step ${barIndex + 1} of ${_steps.length}',
            style: _highlightStyle(theme),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 28),
          _buildComplexityGrid(theme),
        ],
      ),
    );
  }

  Widget _buildComplexityGrid(ThemeData theme) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWide = constraints.maxWidth > 620;
        final double tileWidth = isWide
            ? (constraints.maxWidth - 16) / 2
            : constraints.maxWidth;
        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: _data.complexity.map((item) {
            return SizedBox(
              width: tileWidth,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.12),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.title, style: theme.textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text(
                      item.complexity,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    SectionParagraph(item.note),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildResourcesSection(
    ThemeData theme,
    List<VisualBar> bars,
    List<VisualTile> tiles,
    AlgorithmStep barStep,
    AlgorithmStep tileStep,
    int barIndex,
    bool barPlaying,
    int tileIndex,
    bool tilePlaying,
  ) {
    final double barProgress = _progressFor(barIndex);
    final double tileProgress = _progressFor(tileIndex);

    return SectionContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(title: '3. Dry Run, Pseudocode & Implementations'),
          const SizedBox(height: 16),
          _buildDryRunCards(theme),
          const SizedBox(height: 24),
          LayoutBuilder(
            builder: (context, constraints) {
              final bool isWide = constraints.maxWidth > 640;
              final double panelWidth = isWide
                  ? (constraints.maxWidth - 20) / 2
                  : constraints.maxWidth;
              return Wrap(
                spacing: 20,
                runSpacing: 20,
                children: [
                  SizedBox(
                    width: panelWidth,
                    child: AlgorithmAnimationPanel(
                      title: 'Bar animation',
                      description: _stepLabel(barStep),
                      visual: BarSection(bars: bars),
                      accent: _accentForStep(barStep),
                      isPlaying: barPlaying,
                      onPlayPause: () => _togglePlayback(_PlaybackChannel.bars),
                      onStepBack: barIndex == 0
                          ? null
                          : () => _stepBackward(_PlaybackChannel.bars),
                      onStepForward: barIndex >= _steps.length - 1
                          ? null
                          : () => _stepForward(_PlaybackChannel.bars),
                      onReset: barIndex == 0 && !barPlaying
                          ? null
                          : () => _resetPlayback(_PlaybackChannel.bars),
                      progress: barProgress,
                      stepLabel: 'Step ${barIndex + 1} / ${_steps.length}',
                    ),
                  ),
                  SizedBox(
                    width: panelWidth,
                    child: AlgorithmAnimationPanel(
                      title: 'Tile animation',
                      description: _stepLabel(tileStep),
                      visual: TileSection(tiles: tiles),
                      accent: _accentForStep(tileStep),
                      isPlaying: tilePlaying,
                      onPlayPause: () =>
                          _togglePlayback(_PlaybackChannel.tiles),
                      onStepBack: tileIndex == 0
                          ? null
                          : () => _stepBackward(_PlaybackChannel.tiles),
                      onStepForward: tileIndex >= _steps.length - 1
                          ? null
                          : () => _stepForward(_PlaybackChannel.tiles),
                      onReset: tileIndex == 0 && !tilePlaying
                          ? null
                          : () => _resetPlayback(_PlaybackChannel.tiles),
                      progress: tileProgress,
                      stepLabel: 'Step ${tileIndex + 1} / ${_steps.length}',
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 28),
          _buildCodeSection(theme),
        ],
      ),
    );
  }

  Widget _buildDryRunCards(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _data.dryRuns.map((pass) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(pass.title, style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.sorted.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(pass.highlight, style: _highlightStyle(theme)),
              ),
              const SizedBox(height: 16),
              ...pass.steps.map(BulletText.new),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCodeSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Pseudocode', style: theme.textTheme.titleMedium),
        const SizedBox(height: 12),
        CodeBlock(_data.pseudoCode),
        const SizedBox(height: 20),
        LayoutBuilder(
          builder: (context, constraints) {
            final bool isWide = constraints.maxWidth > 640;
            final double blockWidth = isWide
                ? (constraints.maxWidth - 20) / 2
                : constraints.maxWidth;
            return Wrap(
              spacing: 20,
              runSpacing: 20,
              children: _data.implementations.entries.map((entry) {
                return SizedBox(
                  width: blockWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(entry.key, style: theme.textTheme.titleMedium),
                      const SizedBox(height: 12),
                      CodeBlock(entry.value),
                    ],
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}
