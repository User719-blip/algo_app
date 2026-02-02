import 'package:algorythm_app/core/widgets/playback_controls.dart';
import 'package:algorythm_app/core/widgets/section_container.dart';
import 'package:algorythm_app/core/widgets/section_paragraph.dart';
import 'package:algorythm_app/core/widgets/section_title.dart';
import 'package:algorythm_app/domain/array_frame.dart';
import 'package:algorythm_app/features/arrays/models/array_bar_visual.dart';
import 'package:algorythm_app/features/arrays/models/array_playback_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'kadane_bar_chart.dart';

class KadaneVisualizationSection extends StatelessWidget {
  final ValueListenable<List<ArrayBarVisual>> bars;
  final ValueListenable<ArrayRange> currentRange;
  final ValueListenable<ArrayRange> bestRange;
  final ValueListenable<ArrayPlaybackState> playback;
  final ValueListenable<String> stepLabel;
  final ValueListenable<double> progress;
  final ValueListenable<String> caption;
  final ValueListenable<int> currentSum;
  final ValueListenable<int> bestSum;
  final ValueListenable<List<String>> logEntries;
  final VoidCallback onPlayPause;
  final VoidCallback? onStepBack;
  final VoidCallback? onStepForward;
  final VoidCallback? onReset;

  const KadaneVisualizationSection({
    super.key,
    required this.bars,
    required this.currentRange,
    required this.bestRange,
    required this.playback,
    required this.stepLabel,
    required this.progress,
    required this.caption,
    required this.currentSum,
    required this.bestSum,
    required this.logEntries,
    required this.onPlayPause,
    this.onStepBack,
    this.onStepForward,
    this.onReset,
  });

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
    return SectionContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(title: '2. Visualization & Tracking'),
          const SizedBox(height: 8),
          SectionParagraph(
            "Follow the sliding window, see the best segment glow, and read how the sums evolve at every index.",
          ),
          const SizedBox(height: 24),
          ValueListenableBuilder<List<ArrayBarVisual>>(
            valueListenable: bars,
            builder: (context, visuals, _) {
              if (visuals.isEmpty) {
                return Container(
                  height: 120,
                  alignment: Alignment.center,
                  child: Text(
                    'No frames to display yet.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.6),
                    ),
                  ),
                );
              }
              final ArrayRange active = currentRange.value;
              final ArrayRange champion = bestRange.value;
              return KadaneBarChart(
                bars: visuals,
                currentStart: active.start,
                currentEnd: active.end,
                bestStart: champion.start,
                bestEnd: champion.end,
              );
            },
          ),
          const SizedBox(height: 20),
          _SummaryChips(
            currentSum: currentSum,
            bestSum: bestSum,
            highlightStyle: _highlightStyle(theme),
          ),
          const SizedBox(height: 16),
          ValueListenableBuilder<String>(
            valueListenable: caption,
            builder: (_, text, __) => Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
              ),
              child: Text(
                text,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          LayoutBuilder(
            builder: (context, constraints) {
              final double spacing = constraints.maxWidth < 360 ? 8 : 12;
              final children = [
                ControlIconButton(
                  icon: Icons.rotate_left,
                  tooltip: 'Reset to start',
                  onTap: onReset,
                ),
                ControlIconButton(
                  icon: Icons.skip_previous,
                  tooltip: 'Previous step',
                  onTap: onStepBack,
                ),
                ValueListenableBuilder<ArrayPlaybackState>(
                  valueListenable: playback,
                  builder: (_, state, __) => PlayPauseButton(
                    isPlaying: state.playing,
                    onTap: onPlayPause,
                  ),
                ),
                ControlIconButton(
                  icon: Icons.skip_next,
                  tooltip: 'Next step',
                  onTap: onStepForward,
                ),
              ];
              return Align(
                alignment: Alignment.center,
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: spacing,
                  runSpacing: spacing,
                  children: children,
                ),
              );
            },
          ),
          const SizedBox(height: 18),
          ValueListenableBuilder<double>(
            valueListenable: progress,
            builder: (_, value, __) => LinearProgressIndicator(
              value: value,
              backgroundColor: Colors.white.withValues(alpha: 0.08),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          const SizedBox(height: 8),
          ValueListenableBuilder<String>(
            valueListenable: stepLabel,
            builder: (_, label, __) => Text(
              label,
              style: _highlightStyle(theme),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          _StepLog(logEntries: logEntries),
        ],
      ),
    );
  }
}

class _SummaryChips extends StatelessWidget {
  final ValueListenable<int> currentSum;
  final ValueListenable<int> bestSum;
  final TextStyle highlightStyle;

  const _SummaryChips({
    required this.currentSum,
    required this.bestSum,
    required this.highlightStyle,
  });

  @override
  Widget build(BuildContext context) {
    final listenable = Listenable.merge([currentSum, bestSum]);
    return AnimatedBuilder(
      animation: listenable,
      builder: (_, __) {
        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _SummaryTile(
              title: 'Running sum',
              value: currentSum.value,
              icon: Icons.trending_flat,
              highlightStyle: highlightStyle,
            ),
            _SummaryTile(
              title: 'Best sum',
              value: bestSum.value,
              icon: Icons.emoji_events,
              highlightStyle: highlightStyle,
            ),
          ],
        );
      },
    );
  }
}

class _SummaryTile extends StatelessWidget {
  final String title;
  final int value;
  final IconData icon;
  final TextStyle highlightStyle;

  const _SummaryTile({
    required this.title,
    required this.value,
    required this.icon,
    required this.highlightStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 200,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(title, style: theme.textTheme.bodyMedium),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value.toString(),
            style:
                theme.textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ) ??
                const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }
}

class _StepLog extends StatelessWidget {
  final ValueListenable<List<String>> logEntries;

  const _StepLog({required this.logEntries});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ValueListenableBuilder<List<String>>(
      valueListenable: logEntries,
      builder: (_, entries, __) {
        if (entries.isEmpty) {
          return Text(
            'Step insights will appear as you progress through the frames.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.6),
            ),
          );
        }
        return Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
          ),
          child: SizedBox(
            height: 180,
            child: Scrollbar(
              thumbVisibility: true,
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                itemBuilder: (_, index) => Text(
                  entries[index],
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                  ),
                ),
                separatorBuilder: (_, __) =>
                    const Divider(color: Color(0x22FFFFFF), height: 16),
                itemCount: entries.length,
              ),
            ),
          ),
        );
      },
    );
  }
}
