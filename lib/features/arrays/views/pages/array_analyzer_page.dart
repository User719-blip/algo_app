import 'package:algorythm_app/core/theme/app_colors.dart';
import 'package:algorythm_app/features/arrays/controllers/kadane_visualizer_controller.dart';
import 'package:algorythm_app/features/arrays/data/array_algorithms.dart';
import 'package:algorythm_app/features/arrays/models/array_algorithm_config.dart';
import 'package:algorythm_app/features/arrays/models/array_visualizer_state.dart';
import 'package:algorythm_app/features/arrays/views/widgets/array_concept_section.dart';
import 'package:algorythm_app/features/arrays/views/widgets/array_resources_section.dart';
import 'package:algorythm_app/features/arrays/views/widgets/kadane_visualization_section.dart';
import 'package:flutter/material.dart';

class ArrayAnalyzerPage extends StatefulWidget {
  final ArrayAlgorithmId initialAlgorithm;

  const ArrayAnalyzerPage({
    super.key,
    this.initialAlgorithm = ArrayAlgorithmId.kadane,
  });

  @override
  State<ArrayAnalyzerPage> createState() => _ArrayAnalyzerPageState();
}

class _ArrayAnalyzerPageState extends State<ArrayAnalyzerPage> {
  late final KadaneVisualizerController _controller;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller = KadaneVisualizerController(
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
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.isInitialized) {
      return const SizedBox.shrink();
    }

    final ArrayVisualizerState state = _controller.state;
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
          child: Scrollbar(
            controller: _scrollController,
            thumbVisibility: true,
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '${state.data.name} Analyzer',
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
                  if (arrayAlgorithmList.isNotEmpty)
                    _AlgorithmSwitcher(
                      state: state,
                      onSelect: _controller.selectAlgorithm,
                    ),
                  if (arrayAlgorithmList.isNotEmpty) const SizedBox(height: 32),
                  ArrayConceptSection(data: state.data),
                  const SizedBox(height: 28),
                  KadaneVisualizationSection(
                    bars: _controller.barVisualListenable,
                    currentRange: _controller.currentRangeListenable,
                    bestRange: _controller.bestRangeListenable,
                    playback: _controller.playbackListenable,
                    stepLabel: _controller.stepLabelListenable,
                    progress: _controller.progressListenable,
                    caption: _controller.captionListenable,
                    currentSum: _controller.currentSumListenable,
                    bestSum: _controller.bestSumListenable,
                    logEntries: _controller.logListenable,
                    onPlayPause: _controller.togglePlayback,
                    onStepBack: state.playback.index == 0
                        ? null
                        : _controller.stepBackward,
                    onStepForward:
                        state.playback.index >= state.frames.length - 1
                        ? null
                        : _controller.stepForward,
                    onReset:
                        state.playback.index == 0 && !state.playback.playing
                        ? null
                        : _controller.reset,
                  ),
                  const SizedBox(height: 28),
                  ArrayResourcesSection(
                    dryRuns: state.data.dryRuns,
                    pseudoCode: state.data.pseudoCode,
                    implementations: state.data.implementations,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AlgorithmSwitcher extends StatelessWidget {
  final ArrayVisualizerState state;
  final void Function(ArrayAlgorithmId) onSelect;

  const _AlgorithmSwitcher({required this.state, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final segments = arrayAlgorithmList
        .map(
          (ArrayAlgorithmConfig config) => ButtonSegment<ArrayAlgorithmId>(
            value: config.id,
            label: Text(config.data.name),
          ),
        )
        .toList(growable: false);

    if (segments.length <= 1) {
      return const SizedBox.shrink();
    }

    return Align(
      alignment: Alignment.center,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: SegmentedButton<ArrayAlgorithmId>(
          showSelectedIcon: false,
          segments: segments,
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
              (states) =>
                  BorderSide(color: Colors.white.withValues(alpha: 0.25)),
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
              onSelect(next);
            }
          },
        ),
      ),
    );
  }
}
