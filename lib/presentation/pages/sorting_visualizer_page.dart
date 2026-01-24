import 'dart:async';

import 'package:algorythm_app/algorithms/base_algorithm.dart';
import 'package:algorythm_app/algorithms/sorting/bubble_sort.dart';
import 'package:algorythm_app/algorithms/sorting/selection_sort.dart';
import 'package:algorythm_app/domain/algorithm_step.dart';
import 'package:algorythm_app/domain/step_type.dart';
import 'package:algorythm_app/presentation/models/algorithm_page_data.dart';
import 'package:algorythm_app/presentation/models/complexity_item.dart';
import 'package:algorythm_app/presentation/models/dry_run_pass.dart';
import 'package:algorythm_app/presentation/models/visual_bar.dart';
import 'package:algorythm_app/presentation/models/visual_tile.dart';
import 'package:algorythm_app/presentation/theme/app_colors.dart';
import 'package:algorythm_app/presentation/utils/step_mapper.dart';
import 'package:algorythm_app/presentation/widget/algorithm_animation_panel.dart';
import 'package:algorythm_app/presentation/widget/bar_section.dart';
import 'package:algorythm_app/presentation/widget/bullet_text.dart';
import 'package:algorythm_app/presentation/widget/code_block.dart';
import 'package:algorythm_app/presentation/widget/playback_controls.dart';
import 'package:algorythm_app/presentation/widget/section_container.dart';
import 'package:algorythm_app/presentation/widget/section_paragraph.dart';
import 'package:algorythm_app/presentation/widget/section_subheading.dart';
import 'package:algorythm_app/presentation/widget/section_title.dart';
import 'package:algorythm_app/presentation/widget/tile_section.dart';
import 'package:flutter/material.dart';

const List<int> _visualInput = [5, 1, 4, 2, 8];

const String _bubblePseudoCode = '''procedure bubbleSort(arr):
  n <- length(arr)
  for i from 0 to n - 2:
    swapped <- false
    for j from 0 to n - i - 2:
      if arr[j] > arr[j + 1]:
        swap arr[j], arr[j + 1]
        swapped <- true
    if not swapped:
      break
''';

const String _bubbleCpp = '''void bubbleSort(std::vector<int>& arr) {
  for (std::size_t i = 0; i + 1 < arr.size(); ++i) {
    bool swapped = false;
    for (std::size_t j = 0; j + 1 < arr.size() - i; ++j) {
      if (arr[j] > arr[j + 1]) {
        std::swap(arr[j], arr[j + 1]);
        swapped = true;
      }
    }
    if (!swapped) {
      break;
    }
  }
}
''';

const String _bubblePython = '''def bubble_sort(values):
    arr = values[:]
    for i in range(len(arr) - 1):
        swapped = False
        for j in range(len(arr) - i - 1):
            if arr[j] > arr[j + 1]:
                arr[j], arr[j + 1] = arr[j + 1], arr[j]
                swapped = True
        if not swapped:
            break
    return arr
''';

const String _bubbleJava = '''public static void bubbleSort(int[] arr) {
    for (int i = 0; i < arr.length - 1; i++) {
        boolean swapped = false;
        for (int j = 0; j < arr.length - i - 1; j++) {
            if (arr[j] > arr[j + 1]) {
                int temp = arr[j];
                arr[j] = arr[j + 1];
                arr[j + 1] = temp;
                swapped = true;
            }
        }
        if (!swapped) {
            break;
        }
    }
}
''';

const String _selectionPseudoCode = '''procedure selectionSort(arr):
  n <- length(arr)
  for i from 0 to n - 2:
    minIndex <- i
    for j from i + 1 to n - 1:
      if arr[j] < arr[minIndex]:
        minIndex <- j
    if minIndex != i:
      swap arr[i], arr[minIndex]
''';

const String _selectionCpp = '''void selectionSort(std::vector<int>& arr) {
  for (std::size_t i = 0; i + 1 < arr.size(); ++i) {
    std::size_t minIndex = i;
    for (std::size_t j = i + 1; j < arr.size(); ++j) {
      if (arr[j] < arr[minIndex]) {
        minIndex = j;
      }
    }
    if (minIndex != i) {
      std::swap(arr[i], arr[minIndex]);
    }
  }
}
''';

const String _selectionPython = '''def selection_sort(values):
    arr = values[:]
    for i in range(len(arr) - 1):
        min_index = i
        for j in range(i + 1, len(arr)):
            if arr[j] < arr[min_index]:
                min_index = j
        if min_index != i:
            arr[i], arr[min_index] = arr[min_index], arr[i]
    return arr
''';

const String _selectionJava = '''public static void selectionSort(int[] arr) {
    for (int i = 0; i < arr.length - 1; i++) {
        int minIndex = i;
        for (int j = i + 1; j < arr.length; j++) {
            if (arr[j] < arr[minIndex]) {
                minIndex = j;
            }
        }
        if (minIndex != i) {
            int temp = arr[i];
            arr[i] = arr[minIndex];
            arr[minIndex] = temp;
        }
    }
}
''';

const AlgorithmPageData _bubbleSortData = AlgorithmPageData(
  name: 'Bubble Sort',
  tagline: 'See adjacent swaps push heavier values toward the end each pass.',
  conceptSummary:
      'Bubble Sort is a comparison-driven routine that repeatedly walks through a list, switching neighbouring values that appear in the wrong order. After each pass the largest value "bubbles" to the end of the list.',
  conceptPoints: [
    'Start at the beginning of the array and compare items in pairs.',
    'Swap the pair when the left item is larger than the right one.',
    'Shrink the unsorted portion from the end after every sweep.',
    'Abort early if a pass completes without any swaps.',
  ],
  conceptUsage:
      'Reach for Bubble Sort when teaching comparison-based sorting, animating algorithm intuition, or working with tiny datasets where simplicity matters more than speed.',
  dryRuns: [
    DryRunPass(
      title: 'Pass 1',
      highlight: 'Largest value moves to the far right after the first sweep.',
      steps: [
        'Compare 5 and 1 -> swap -> [1, 5, 4, 2, 8]',
        'Compare 5 and 4 -> swap -> [1, 4, 5, 2, 8]',
        'Compare 5 and 2 -> swap -> [1, 4, 2, 5, 8]',
        'Compare 5 and 8 -> keep -> [1, 4, 2, 5, 8]',
      ],
    ),
    DryRunPass(
      title: 'Pass 2',
      highlight:
          'Next heaviest element settles one slot before the sorted tail.',
      steps: [
        'Compare 1 and 4 -> keep -> [1, 4, 2, 5, 8]',
        'Compare 4 and 2 -> swap -> [1, 2, 4, 5, 8]',
        'Compare 4 and 5 -> keep -> [1, 2, 4, 5, 8]',
      ],
    ),
    DryRunPass(
      title: 'Pass 3',
      highlight: 'No swaps means the list is sorted; algorithm stops early.',
      steps: [
        'Compare 1 and 2 -> keep -> [1, 2, 4, 5, 8]',
        'Compare 2 and 4 -> keep -> [1, 2, 4, 5, 8]',
      ],
    ),
  ],
  complexity: [
    ComplexityItem(
      title: 'Best Case',
      complexity: 'O(n)',
      note: 'Already sorted lists need just one pass to confirm order.',
    ),
    ComplexityItem(
      title: 'Average Case',
      complexity: 'O(n²)',
      note: 'Roughly half of the neighbouring pairs require inspection.',
    ),
    ComplexityItem(
      title: 'Worst Case',
      complexity: 'O(n²)',
      note: 'A reversed list triggers every possible comparison and swap.',
    ),
    ComplexityItem(
      title: 'Space',
      complexity: 'O(1)',
      note: 'Sorting happens in-place with a single temporary variable.',
    ),
  ],
  pseudoCode: _bubblePseudoCode,
  implementations: {
    'C++': _bubbleCpp,
    'Python': _bubblePython,
    'Java': _bubbleJava,
  },
);

const AlgorithmPageData _selectionSortData = AlgorithmPageData(
  name: 'Selection Sort',
  tagline:
      'Trace how Selection Sort grows a sorted prefix by scanning for minima.',
  conceptSummary:
      'Selection Sort splits the list into a sorted prefix and an unsorted suffix. Each pass scans the suffix to find the minimum element and swaps it into the front, expanding the sorted region.',
  conceptPoints: [
    'Assume the first unsorted value is the current minimum.',
    'Walk the suffix to discover a smaller candidate index.',
    'Swap the discovered minimum into the front of the suffix.',
    'Grow the sorted prefix until no unsorted values remain.',
  ],
  conceptUsage:
      'Use Selection Sort to highlight search-and-swap patterns, prove algorithm invariants, or work with tiny arrays where clarity is more important than speed.',
  dryRuns: [
    DryRunPass(
      title: 'Pass 1',
      highlight: 'Find the smallest value and move it into the first slot.',
      steps: [
        'Assume index 0 (value 5) is the minimum.',
        'Compare value 1 with current minimum 5 -> update minimum to index 1.',
        'Compare value 4 with minimum 1 -> keep current minimum.',
        'Compare value 2 with minimum 1 -> keep current minimum.',
        'Compare value 8 with minimum 1 -> keep current minimum.',
        'Swap index 0 with index 1 -> [1, 5, 4, 2, 8].',
        'Mark index 0 as sorted.',
      ],
    ),
    DryRunPass(
      title: 'Pass 2',
      highlight: 'Search the remaining suffix for the next smallest value.',
      steps: [
        'Assume index 1 (value 5) is the new minimum.',
        'Compare value 4 with minimum 5 -> update minimum to index 2.',
        'Compare value 2 with minimum 4 -> update minimum to index 3.',
        'Compare value 8 with minimum 2 -> keep current minimum.',
        'Swap index 1 with index 3 -> [1, 2, 4, 5, 8].',
        'Mark index 1 as sorted.',
      ],
    ),
    DryRunPass(
      title: 'Pass 3',
      highlight: 'Sorted prefix expands even when no swap is required.',
      steps: [
        'Assume index 2 (value 4) is the minimum.',
        'Compare value 5 with minimum 4 -> keep current minimum.',
        'Compare value 8 with minimum 4 -> keep current minimum.',
        'No swap needed; index 2 stays in place.',
        'Mark index 2 as sorted; the remaining tail is already ordered.',
      ],
    ),
  ],
  complexity: [
    ComplexityItem(
      title: 'Best Case',
      complexity: 'O(n²)',
      note: 'Selection Sort still scans the suffix even when already sorted.',
    ),
    ComplexityItem(
      title: 'Average Case',
      complexity: 'O(n²)',
      note: 'Every pass performs a full scan of the shrinking suffix.',
    ),
    ComplexityItem(
      title: 'Worst Case',
      complexity: 'O(n²)',
      note: 'Reversed input does not change the fixed scan pattern.',
    ),
    ComplexityItem(
      title: 'Space',
      complexity: 'O(1)',
      note: 'In-place swapping only needs one temporary variable.',
    ),
  ],
  pseudoCode: _selectionPseudoCode,
  implementations: {
    'C++': _selectionCpp,
    'Python': _selectionPython,
    'Java': _selectionJava,
  },
);

enum _SortingAlgorithm { selection, bubble }

class _AlgorithmConfig {
  final Algorithm algorithm;
  final AlgorithmPageData data;

  const _AlgorithmConfig({required this.algorithm, required this.data});
}

enum _PlaybackChannel { bars, tiles }

class SortingVisualizerPage extends StatefulWidget {
  const SortingVisualizerPage({super.key});

  @override
  State<SortingVisualizerPage> createState() => _SortingVisualizerPageState();
}

class _SortingVisualizerPageState extends State<SortingVisualizerPage> {
  static const Duration _playbackInterval = Duration(milliseconds: 600);

  late final Map<_SortingAlgorithm, _AlgorithmConfig> _configs;
  late _SortingAlgorithm _activeAlgorithm;
  late AlgorithmPageData _data;
  late List<AlgorithmStep> _steps;

  int _barIndex = 0;
  int _tileIndex = 0;

  Timer? _barTimer;
  Timer? _tileTimer;

  bool _barPlaying = false;
  bool _tilePlaying = false;

  @override
  void initState() {
    super.initState();
    _configs = _buildConfigs();
    _applyAlgorithm(_SortingAlgorithm.selection, initial: true);
  }

  Map<_SortingAlgorithm, _AlgorithmConfig> _buildConfigs() {
    return {
      _SortingAlgorithm.selection: _AlgorithmConfig(
        algorithm: SelectionSort(),
        data: _selectionSortData,
      ),
      _SortingAlgorithm.bubble: _AlgorithmConfig(
        algorithm: BubbleSort(),
        data: _bubbleSortData,
      ),
    };
  }

  void _applyAlgorithm(_SortingAlgorithm algorithm, {bool initial = false}) {
    _pausePlayback(_PlaybackChannel.bars, updateState: false);
    _pausePlayback(_PlaybackChannel.tiles, updateState: false);

    final config = _configs[algorithm]!;
    final steps = config.algorithm.generateSteps(_visualInput);

    void assign() {
      _activeAlgorithm = algorithm;
      _data = config.data;
      _steps = steps;
      _barIndex = 0;
      _tileIndex = 0;
      _barPlaying = false;
      _tilePlaying = false;
    }

    if (initial) {
      assign();
    } else {
      setState(assign);
    }
  }

  @override
  void dispose() {
    _barTimer?.cancel();
    _tileTimer?.cancel();
    super.dispose();
  }

  void _startPlayback(_PlaybackChannel channel) {
    _pausePlayback(channel, updateState: false);

    void tick() {
      if (!mounted) {
        return;
      }
      final int currentIndex = channel == _PlaybackChannel.bars
          ? _barIndex
          : _tileIndex;
      if (currentIndex >= _steps.length - 1) {
        _pausePlayback(channel, updateState: false);
        setState(() {});
        return;
      }
      setState(() {
        if (channel == _PlaybackChannel.bars) {
          _barIndex++;
        } else {
          _tileIndex++;
        }
      });
    }

    final timer = Timer.periodic(_playbackInterval, (_) => tick());
    setState(() {
      if (channel == _PlaybackChannel.bars) {
        _barTimer = timer;
        _barPlaying = true;
      } else {
        _tileTimer = timer;
        _tilePlaying = true;
      }
    });
  }

  void _pausePlayback(_PlaybackChannel channel, {bool updateState = true}) {
    if (channel == _PlaybackChannel.bars) {
      _barTimer?.cancel();
      _barTimer = null;
      if (updateState) {
        setState(() => _barPlaying = false);
      } else {
        _barPlaying = false;
      }
    } else {
      _tileTimer?.cancel();
      _tileTimer = null;
      if (updateState) {
        setState(() => _tilePlaying = false);
      } else {
        _tilePlaying = false;
      }
    }
  }

  void _togglePlayback(_PlaybackChannel channel) {
    final bool isPlaying = channel == _PlaybackChannel.bars
        ? _barPlaying
        : _tilePlaying;
    final int currentIndex = channel == _PlaybackChannel.bars
        ? _barIndex
        : _tileIndex;

    if (isPlaying) {
      _pausePlayback(channel);
      return;
    }

    if (currentIndex >= _steps.length - 1) {
      setState(() {
        if (channel == _PlaybackChannel.bars) {
          _barIndex = 0;
        } else {
          _tileIndex = 0;
        }
      });
    }
    _startPlayback(channel);
  }

  void _stepForward(_PlaybackChannel channel) {
    final int currentIndex = channel == _PlaybackChannel.bars
        ? _barIndex
        : _tileIndex;
    if (currentIndex >= _steps.length - 1) {
      return;
    }
    _pausePlayback(channel);
    setState(() {
      if (channel == _PlaybackChannel.bars) {
        _barIndex++;
      } else {
        _tileIndex++;
      }
    });
  }

  void _stepBackward(_PlaybackChannel channel) {
    final int currentIndex = channel == _PlaybackChannel.bars
        ? _barIndex
        : _tileIndex;
    if (currentIndex == 0) {
      return;
    }
    _pausePlayback(channel);
    setState(() {
      if (channel == _PlaybackChannel.bars) {
        _barIndex--;
      } else {
        _tileIndex--;
      }
    });
  }

  void _resetPlayback(_PlaybackChannel channel) {
    _pausePlayback(channel);
    setState(() {
      if (channel == _PlaybackChannel.bars) {
        _barIndex = 0;
      } else {
        _tileIndex = 0;
      }
    });
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
    final AlgorithmStep barStep = _steps[_barIndex];
    final AlgorithmStep tileStep = _steps[_tileIndex];

    final List<VisualBar> bars = mapStepToBars(barStep);
    final List<VisualTile> tiles = mapStepToTile(tileStep);

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
                  child: SegmentedButton<_SortingAlgorithm>(
                    showSelectedIcon: false,
                    segments: const [
                      ButtonSegment(
                        value: _SortingAlgorithm.selection,
                        label: Text('Selection Sort'),
                      ),
                      ButtonSegment(
                        value: _SortingAlgorithm.bubble,
                        label: Text('Bubble Sort'),
                      ),
                    ],
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
                _buildVisualizationSection(theme, bars, barStep),
                const SizedBox(height: 28),
                _buildResourcesSection(theme, bars, tiles, barStep, tileStep),
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
  ) {
    final double barProgress = _progressFor(_barIndex);

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
                onTap: _barIndex == 0 && !_barPlaying
                    ? null
                    : () => _resetPlayback(_PlaybackChannel.bars),
              ),
              ControlIconButton(
                icon: Icons.skip_previous,
                tooltip: 'Previous step',
                onTap: _barIndex == 0
                    ? null
                    : () => _stepBackward(_PlaybackChannel.bars),
              ),
              PlayPauseButton(
                isPlaying: _barPlaying,
                onTap: () => _togglePlayback(_PlaybackChannel.bars),
              ),
              ControlIconButton(
                icon: Icons.skip_next,
                tooltip: 'Next step',
                onTap: _barIndex >= _steps.length - 1
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
            'Step ${_barIndex + 1} of ${_steps.length}',
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
  ) {
    final double barProgress = _progressFor(_barIndex);
    final double tileProgress = _progressFor(_tileIndex);

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
                      isPlaying: _barPlaying,
                      onPlayPause: () => _togglePlayback(_PlaybackChannel.bars),
                      onStepBack: _barIndex == 0
                          ? null
                          : () => _stepBackward(_PlaybackChannel.bars),
                      onStepForward: _barIndex >= _steps.length - 1
                          ? null
                          : () => _stepForward(_PlaybackChannel.bars),
                      onReset: _barIndex == 0 && !_barPlaying
                          ? null
                          : () => _resetPlayback(_PlaybackChannel.bars),
                      progress: barProgress,
                      stepLabel: 'Step ${_barIndex + 1} / ${_steps.length}',
                    ),
                  ),
                  SizedBox(
                    width: panelWidth,
                    child: AlgorithmAnimationPanel(
                      title: 'Tile animation',
                      description: _stepLabel(tileStep),
                      visual: TileSection(tiles: tiles),
                      accent: _accentForStep(tileStep),
                      isPlaying: _tilePlaying,
                      onPlayPause: () =>
                          _togglePlayback(_PlaybackChannel.tiles),
                      onStepBack: _tileIndex == 0
                          ? null
                          : () => _stepBackward(_PlaybackChannel.tiles),
                      onStepForward: _tileIndex >= _steps.length - 1
                          ? null
                          : () => _stepForward(_PlaybackChannel.tiles),
                      onReset: _tileIndex == 0 && !_tilePlaying
                          ? null
                          : () => _resetPlayback(_PlaybackChannel.tiles),
                      progress: tileProgress,
                      stepLabel: 'Step ${_tileIndex + 1} / ${_steps.length}',
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
