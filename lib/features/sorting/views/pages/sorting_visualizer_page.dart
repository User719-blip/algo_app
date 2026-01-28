import 'package:algorythm_app/core/models/visual_bar.dart';
import 'package:algorythm_app/core/models/visual_tile.dart';
import 'package:algorythm_app/core/theme/app_colors.dart';
import 'package:algorythm_app/features/sorting/controllers/sorting_visualizer_controller.dart';
import 'package:algorythm_app/features/sorting/data/sorting_algorithms.dart';
import 'package:algorythm_app/features/sorting/models/sorting_visualizer_state.dart';
import 'package:algorythm_app/features/sorting/views/widgets/sorting_concept_section.dart';
import 'package:algorythm_app/features/sorting/views/widgets/sorting_resources_section.dart';
import 'package:algorythm_app/features/sorting/views/widgets/sorting_visualization_section.dart';
import 'package:flutter/material.dart';

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
  late final SortingVisualizerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = SortingVisualizerController(
      initialAlgorithm: widget.initialAlgorithm,
    );
    _controller.addListener(_onControllerChanged);
  }

  void _onControllerChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.isInitialized) {
      return const SizedBox.shrink();
    }

    final SortingVisualizerState state = _controller.state;
    final theme = Theme.of(context);

    final List<VisualBar> barVisual = _controller.barVisual;
    final List<VisualTile> tileVisual = _controller.tileVisual;

    final barStep = _controller.barStep;
    final tileStep = _controller.tileStep;

    final barPlayback = _controller.barPlayback;
    final tilePlayback = _controller.tilePlayback;

    final String barDescription = _controller.describeStep(barStep);
    final String tileDescription = _controller.describeStep(tileStep);

    final Color barAccent = _controller.accentForStep(barStep);
    final Color tileAccent = _controller.accentForStep(tileStep);

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
                  '${state.data.name} Visual Guide',
                  style: theme.textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  state.data.tagline,
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
                    selected: {state.activeAlgorithm},
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
                      if (next != state.activeAlgorithm) {
                        _controller.selectAlgorithm(next);
                      }
                    },
                  ),
                ),
                const SizedBox(height: 32),
                SortingConceptSection(data: state.data),
                const SizedBox(height: 28),
                SortingVisualizationSection(
                  bars: barVisual,
                  complexity: state.data.complexity,
                  stepLabel: barDescription,
                  accent: barAccent,
                  progress: _controller.barProgress,
                  currentIndex: barPlayback.index,
                  totalSteps: state.steps.length,
                  isPlaying: barPlayback.playing,
                  onPlayPause: () =>
                      _controller.togglePlayback(SortingPlaybackChannel.bars),
                  onStepBack: barPlayback.index == 0
                      ? null
                      : () => _controller.stepBackward(
                          SortingPlaybackChannel.bars,
                        ),
                  onStepForward: barPlayback.index >= state.steps.length - 1
                      ? null
                      : () => _controller.stepForward(
                          SortingPlaybackChannel.bars,
                        ),
                  onReset: barPlayback.index == 0 && !barPlayback.playing
                      ? null
                      : () => _controller.resetPlayback(
                          SortingPlaybackChannel.bars,
                        ),
                ),
                const SizedBox(height: 28),
                SortingResourcesSection(
                  dryRuns: state.data.dryRuns,
                  pseudoCode: state.data.pseudoCode,
                  implementations: state.data.implementations,
                  barVisual: barVisual,
                  tileVisual: tileVisual,
                  barDescription: barDescription,
                  tileDescription: tileDescription,
                  barAccent: barAccent,
                  tileAccent: tileAccent,
                  barProgress: _controller.barProgress,
                  tileProgress: _controller.tileProgress,
                  barStepLabel: _controller.barStepLabel,
                  tileStepLabel: _controller.tileStepLabel,
                  isBarPlaying: barPlayback.playing,
                  isTilePlaying: tilePlayback.playing,
                  onBarPlayPause: () =>
                      _controller.togglePlayback(SortingPlaybackChannel.bars),
                  onTilePlayPause: () =>
                      _controller.togglePlayback(SortingPlaybackChannel.tiles),
                  onBarStepBack: barPlayback.index == 0
                      ? null
                      : () => _controller.stepBackward(
                          SortingPlaybackChannel.bars,
                        ),
                  onBarStepForward: barPlayback.index >= state.steps.length - 1
                      ? null
                      : () => _controller.stepForward(
                          SortingPlaybackChannel.bars,
                        ),
                  onTileStepBack: tilePlayback.index == 0
                      ? null
                      : () => _controller.stepBackward(
                          SortingPlaybackChannel.tiles,
                        ),
                  onTileStepForward:
                      tilePlayback.index >= state.steps.length - 1
                      ? null
                      : () => _controller.stepForward(
                          SortingPlaybackChannel.tiles,
                        ),
                  onBarReset: barPlayback.index == 0 && !barPlayback.playing
                      ? null
                      : () => _controller.resetPlayback(
                          SortingPlaybackChannel.bars,
                        ),
                  onTileReset: tilePlayback.index == 0 && !tilePlayback.playing
                      ? null
                      : () => _controller.resetPlayback(
                          SortingPlaybackChannel.tiles,
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
