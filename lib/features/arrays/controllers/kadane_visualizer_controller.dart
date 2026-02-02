import 'dart:async';

import 'package:algorythm_app/domain/array_frame.dart';
import 'package:algorythm_app/features/arrays/data/array_algorithms.dart';
import 'package:algorythm_app/features/arrays/models/array_algorithm_config.dart';
import 'package:algorythm_app/features/arrays/models/array_bar_visual.dart';
import 'package:algorythm_app/features/arrays/models/array_playback_state.dart';
import 'package:algorythm_app/features/arrays/models/array_visualizer_state.dart';
import 'package:flutter/foundation.dart';

class KadaneVisualizerController extends ChangeNotifier {
  KadaneVisualizerController({
    ArrayAlgorithmId initialAlgorithm = ArrayAlgorithmId.kadane,
    Duration playbackInterval = const Duration(milliseconds: 720),
  }) : _playbackInterval = playbackInterval {
    _loadAlgorithm(initialAlgorithm, notify: false);
  }

  final Duration _playbackInterval;

  final ValueNotifier<List<ArrayBarVisual>> barVisualNotifier =
      ValueNotifier<List<ArrayBarVisual>>(const []);
  final ValueNotifier<ArrayRange> currentRangeNotifier =
      ValueNotifier<ArrayRange>(const ArrayRange(start: 0, end: 0));
  final ValueNotifier<ArrayRange> bestRangeNotifier = ValueNotifier<ArrayRange>(
    const ArrayRange(start: 0, end: 0),
  );
  final ValueNotifier<String> stepLabelNotifier = ValueNotifier<String>(
    'Step 0 / 0',
  );
  final ValueNotifier<double> progressNotifier = ValueNotifier<double>(0);
  final ValueNotifier<ArrayPlaybackState> playbackNotifier =
      ValueNotifier<ArrayPlaybackState>(const ArrayPlaybackState());
  final ValueNotifier<String> captionNotifier = ValueNotifier<String>('');
  final ValueNotifier<int> currentSumNotifier = ValueNotifier<int>(0);
  final ValueNotifier<int> bestSumNotifier = ValueNotifier<int>(0);
  final ValueNotifier<List<String>> logNotifier = ValueNotifier<List<String>>(
    const [],
  );

  ArrayVisualizerState? _state;
  Timer? _timer;
  List<String> _frameLogs = const [];

  ArrayVisualizerState get state {
    final current = _state;
    if (current == null) {
      throw StateError('KadaneVisualizerController accessed before init.');
    }
    return current;
  }

  bool get isInitialized => _state != null;

  List<ArrayFrame> get _frames => state.frames;

  ArrayFrame get currentFrame => _frames[state.playback.index];

  void selectAlgorithm(ArrayAlgorithmId algorithm) {
    _cancelTimer();
    _loadAlgorithm(algorithm);
  }

  void togglePlayback() {
    final playback = state.playback;
    if (playback.playing) {
      pause();
      return;
    }

    if (_frames.isEmpty) {
      return;
    }

    if (playback.index >= _frames.length - 1) {
      _updatePlayback(const ArrayPlaybackState(index: 0, playing: false));
    }

    _startPlayback();
  }

  void pause() {
    _cancelTimer();
    final playback = state.playback;
    if (playback.playing) {
      _updatePlayback(playback.copyWith(playing: false), notifyProgress: false);
    }
  }

  void reset() {
    pause();
    _updatePlayback(const ArrayPlaybackState(index: 0, playing: false));
  }

  void stepForward() {
    final playback = state.playback;
    if (playback.index >= _frames.length - 1) {
      return;
    }
    pause();
    _updatePlayback(playback.copyWith(index: playback.index + 1));
  }

  void stepBackward() {
    final playback = state.playback;
    if (playback.index == 0) {
      return;
    }
    pause();
    _updatePlayback(playback.copyWith(index: playback.index - 1));
  }

  @override
  void dispose() {
    _cancelTimer();
    barVisualNotifier.dispose();
    currentRangeNotifier.dispose();
    bestRangeNotifier.dispose();
    stepLabelNotifier.dispose();
    progressNotifier.dispose();
    playbackNotifier.dispose();
    captionNotifier.dispose();
    currentSumNotifier.dispose();
    bestSumNotifier.dispose();
    logNotifier.dispose();
    super.dispose();
  }

  ValueListenable<List<ArrayBarVisual>> get barVisualListenable =>
      barVisualNotifier;
  ValueListenable<ArrayRange> get currentRangeListenable =>
      currentRangeNotifier;
  ValueListenable<ArrayRange> get bestRangeListenable => bestRangeNotifier;
  ValueListenable<String> get stepLabelListenable => stepLabelNotifier;
  ValueListenable<double> get progressListenable => progressNotifier;
  ValueListenable<ArrayPlaybackState> get playbackListenable =>
      playbackNotifier;
  ValueListenable<String> get captionListenable => captionNotifier;
  ValueListenable<int> get currentSumListenable => currentSumNotifier;
  ValueListenable<int> get bestSumListenable => bestSumNotifier;
  ValueListenable<List<String>> get logListenable => logNotifier;

  void _loadAlgorithm(ArrayAlgorithmId algorithm, {bool notify = true}) {
    final config = arrayAlgorithmCatalog[algorithm]!;
    final frames = config.algorithm.generateFrames(config.demoInput);

    if (frames.isEmpty) {
      _state = ArrayVisualizerState(
        activeAlgorithm: algorithm,
        data: config.data,
        frames: const [],
        playback: const ArrayPlaybackState(),
      );
      _frameLogs = const [];
      _publishEmpty();
      if (notify) {
        notifyListeners();
      }
      return;
    }

    _frameLogs = frames.map(_describeFrame).toList(growable: false);

    _state = ArrayVisualizerState(
      activeAlgorithm: algorithm,
      data: config.data,
      frames: frames,
      playback: const ArrayPlaybackState(),
    );

    playbackNotifier.value = state.playback;
    _publishFrame(state.playback, frame: frames.first, notify: false);

    if (notify) {
      notifyListeners();
    }
  }

  void _startPlayback() {
    _cancelTimer();
    final timer = Timer.periodic(
      _playbackInterval,
      (tick) => _handleTick(tick),
    );
    _timer = timer;
    _updatePlayback(
      state.playback.copyWith(playing: true),
      notifyProgress: false,
    );
  }

  void _handleTick(Timer timer) {
    if (!hasListeners) {
      timer.cancel();
      return;
    }

    final playback = state.playback;
    if (playback.index >= _frames.length - 1) {
      _cancelTimer();
      _updatePlayback(playback.copyWith(playing: false));
      return;
    }

    _updatePlayback(playback.copyWith(index: playback.index + 1));
  }

  void _cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void _updatePlayback(ArrayPlaybackState value, {bool notifyProgress = true}) {
    final current = state;
    _state = current.copyWith(playback: value);
    playbackNotifier.value = value;

    if (_frames.isEmpty) {
      _publishEmpty();
      return;
    }

    final ArrayFrame frame = _frames[value.index];
    _publishFrame(value, frame: frame, notify: notifyProgress);
  }

  void _publishFrame(
    ArrayPlaybackState playback, {
    required ArrayFrame frame,
    bool notify = true,
  }) {
    barVisualNotifier.value = _mapFrameToBars(frame);
    currentRangeNotifier.value = frame.currentRange;
    bestRangeNotifier.value = frame.bestRange;
    stepLabelNotifier.value = 'Step ${playback.index + 1} / ${_frames.length}';
    progressNotifier.value = _progressFor(playback.index);
    captionNotifier.value = frame.caption;
    currentSumNotifier.value = frame.currentSum;
    bestSumNotifier.value = frame.bestSum;
    logNotifier.value = List.unmodifiable(
      _frameLogs.take(playback.index + 1).toList(growable: false),
    );

    if (notify) {
      notifyListeners();
    }
  }

  void _publishEmpty() {
    barVisualNotifier.value = const [];
    currentRangeNotifier.value = const ArrayRange(start: 0, end: 0);
    bestRangeNotifier.value = const ArrayRange(start: 0, end: 0);
    stepLabelNotifier.value = 'Step 0 / 0';
    progressNotifier.value = 0;
    captionNotifier.value = 'No data to visualize.';
    currentSumNotifier.value = 0;
    bestSumNotifier.value = 0;
    logNotifier.value = const [];
  }

  double _progressFor(int index) {
    if (_frames.length <= 1) {
      return _frames.isEmpty ? 0 : 1;
    }
    return index / (_frames.length - 1);
  }

  List<ArrayBarVisual> _mapFrameToBars(ArrayFrame frame) {
    final int currentStart = frame.currentRange.start;
    final int currentEnd = frame.currentRange.end;
    final int bestStart = frame.bestRange.start;
    final int bestEnd = frame.bestRange.end;

    return List<ArrayBarVisual>.generate(frame.values.length, (index) {
      final bool inCurrent = index >= currentStart && index <= currentEnd;
      final bool inBest = index >= bestStart && index <= bestEnd;
      final bool isCurrentIndex = index == frame.index;
      return ArrayBarVisual(
        value: frame.values[index],
        isCurrentIndex: isCurrentIndex,
        inCurrentRange: inCurrent,
        inBestRange: inBest,
      );
    });
  }

  String _describeFrame(ArrayFrame frame) {
    final int start = frame.currentRange.start;
    final int end = frame.currentRange.end;
    final int bestStart = frame.bestRange.start;
    final int bestEnd = frame.bestRange.end;
    return 'i=${frame.index} → current=${frame.currentSum} [$start..$end], best=${frame.bestSum} [$bestStart..$bestEnd]';
  }
}
