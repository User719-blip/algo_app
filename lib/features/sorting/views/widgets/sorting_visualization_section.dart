import 'package:algorythm_app/core/models/complexity_item.dart';
import 'package:algorythm_app/core/models/visual_bar.dart';
import 'package:algorythm_app/core/theme/app_colors.dart';
import 'package:algorythm_app/core/widgets/bar_section.dart';
import 'package:algorythm_app/core/widgets/playback_controls.dart';
import 'package:algorythm_app/core/widgets/section_container.dart';
import 'package:algorythm_app/core/widgets/section_paragraph.dart';
import 'package:algorythm_app/core/widgets/section_title.dart';
import 'package:flutter/material.dart';

class SortingVisualizationSection extends StatelessWidget {
  final List<VisualBar> bars;
  final List<ComplexityItem> complexity;
  final String stepLabel;
  final Color accent;
  final double progress;
  final int currentIndex;
  final int totalSteps;
  final bool isPlaying;
  final VoidCallback onPlayPause;
  final VoidCallback? onStepBack;
  final VoidCallback? onStepForward;
  final VoidCallback? onReset;

  const SortingVisualizationSection({
    super.key,
    required this.bars,
    required this.complexity,
    required this.stepLabel,
    required this.accent,
    required this.progress,
    required this.currentIndex,
    required this.totalSteps,
    required this.isPlaying,
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
                color: accent.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: accent.withValues(alpha: 0.35)),
              ),
              child: Text(
                stepLabel,
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
                onTap: onReset,
              ),
              ControlIconButton(
                icon: Icons.skip_previous,
                tooltip: 'Previous step',
                onTap: onStepBack,
              ),
              PlayPauseButton(isPlaying: isPlaying, onTap: onPlayPause),
              ControlIconButton(
                icon: Icons.skip_next,
                tooltip: 'Next step',
                onTap: onStepForward,
              ),
            ],
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 6,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.white.withValues(alpha: 0.08),
                valueColor: AlwaysStoppedAnimation<Color>(accent),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Step ${currentIndex + 1} of $totalSteps',
            style: _highlightStyle(theme),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 28),
          _ComplexityGrid(complexity: complexity),
        ],
      ),
    );
  }
}

class _ComplexityGrid extends StatelessWidget {
  final List<ComplexityItem> complexity;

  const _ComplexityGrid({required this.complexity});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWide = constraints.maxWidth > 620;
        final double tileWidth = isWide
            ? (constraints.maxWidth - 16) / 2
            : constraints.maxWidth;
        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: complexity.map((item) {
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
}
