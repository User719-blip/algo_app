import 'package:algorythm_app/core/models/dry_run_pass.dart';
import 'package:algorythm_app/core/models/visual_bar.dart';
import 'package:algorythm_app/core/models/visual_tile.dart';
import 'package:algorythm_app/core/theme/app_colors.dart';
import 'package:algorythm_app/core/widgets/algorithm_animation_panel.dart';
import 'package:algorythm_app/core/widgets/bar_section.dart';
import 'package:algorythm_app/core/widgets/bullet_text.dart';
import 'package:algorythm_app/core/widgets/code_block.dart';
import 'package:algorythm_app/core/widgets/section_container.dart';
import 'package:algorythm_app/core/widgets/section_title.dart';
import 'package:algorythm_app/core/widgets/tile_section.dart';
import 'package:algorythm_app/features/sorting/models/sorting_playback_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SortingResourcesSection extends StatelessWidget {
  final List<DryRunPass> dryRuns;
  final ValueListenable<List<VisualBar>> barVisualListenable;
  final ValueListenable<List<VisualTile>> tileVisualListenable;
  final ValueListenable<double> barProgressListenable;
  final ValueListenable<double> tileProgressListenable;
  final ValueListenable<String> barStepLabelListenable;
  final ValueListenable<String> tileStepLabelListenable;
  final ValueListenable<SortingPlaybackState> barPlaybackListenable;
  final ValueListenable<SortingPlaybackState> tilePlaybackListenable;
  final String pseudoCode;
  final Map<String, String> implementations;
  final String barDescription;
  final String tileDescription;
  final Color barAccent;
  final Color tileAccent;
  final VoidCallback onBarPlayPause;
  final VoidCallback onTilePlayPause;
  final VoidCallback? onBarStepBack;
  final VoidCallback? onBarStepForward;
  final VoidCallback? onTileStepBack;
  final VoidCallback? onTileStepForward;
  final VoidCallback? onBarReset;
  final VoidCallback? onTileReset;

  const SortingResourcesSection({
    super.key,
    required this.dryRuns,
    required this.pseudoCode,
    required this.implementations,
    required this.barDescription,
    required this.tileDescription,
    required this.barAccent,
    required this.tileAccent,
    required this.onBarPlayPause,
    required this.onTilePlayPause,
    this.onBarStepBack,
    this.onBarStepForward,
    this.onTileStepBack,
    this.onTileStepForward,
    this.onBarReset,
    this.onTileReset,
    required this.barVisualListenable,
    required this.tileVisualListenable,
    required this.barProgressListenable,
    required this.tileProgressListenable,
    required this.barStepLabelListenable,
    required this.tileStepLabelListenable,
    required this.barPlaybackListenable,
    required this.tilePlaybackListenable,
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
          const SectionTitle(title: '3. Dry Run, Pseudocode & Implementations'),
          const SizedBox(height: 16),
          _DryRunList(dryRuns: dryRuns, highlightStyle: _highlightStyle(theme)),
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
                    child: _AnimationPanelBuilder<VisualBar>(
                      title: 'Bar animation',
                      description: barDescription,
                      accent: barAccent,
                      visualListenable: barVisualListenable,
                      progressListenable: barProgressListenable,
                      stepLabelListenable: barStepLabelListenable,
                      playbackListenable: barPlaybackListenable,
                      onPlayPause: onBarPlayPause,
                      onStepBack: onBarStepBack,
                      onStepForward: onBarStepForward,
                      onReset: onBarReset,
                      builder: (values) => BarSection(bars: values),
                    ),
                  ),
                  SizedBox(
                    width: panelWidth,
                    child: _AnimationPanelBuilder<VisualTile>(
                      title: 'Tile animation',
                      description: tileDescription,
                      accent: tileAccent,
                      visualListenable: tileVisualListenable,
                      progressListenable: tileProgressListenable,
                      stepLabelListenable: tileStepLabelListenable,
                      playbackListenable: tilePlaybackListenable,
                      onPlayPause: onTilePlayPause,
                      onStepBack: onTileStepBack,
                      onStepForward: onTileStepForward,
                      onReset: onTileReset,
                      builder: (values) => TileSection(tiles: values),
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 28),
          _CodeSection(
            pseudoCode: pseudoCode,
            implementations: implementations,
          ),
        ],
      ),
    );
  }
}

class _DryRunList extends StatelessWidget {
  final List<DryRunPass> dryRuns;
  final TextStyle highlightStyle;

  const _DryRunList({required this.dryRuns, required this.highlightStyle});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: dryRuns.map((pass) {
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
                child: Text(pass.highlight, style: highlightStyle),
              ),
              const SizedBox(height: 16),
              ...pass.steps.map(BulletText.new),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _AnimationPanelBuilder<T> extends StatelessWidget {
  final String title;
  final String description;
  final Color accent;
  final ValueListenable<List<T>> visualListenable;
  final ValueListenable<double> progressListenable;
  final ValueListenable<String> stepLabelListenable;
  final ValueListenable<SortingPlaybackState> playbackListenable;
  final VoidCallback onPlayPause;
  final VoidCallback? onStepBack;
  final VoidCallback? onStepForward;
  final VoidCallback? onReset;
  final Widget Function(List<T> values) builder;

  const _AnimationPanelBuilder({
    required this.title,
    required this.description,
    required this.accent,
    required this.visualListenable,
    required this.progressListenable,
    required this.stepLabelListenable,
    required this.playbackListenable,
    required this.onPlayPause,
    this.onStepBack,
    this.onStepForward,
    this.onReset,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<T>>(
      valueListenable: visualListenable,
      builder: (context, visuals, _) {
        return ValueListenableBuilder<SortingPlaybackState>(
          valueListenable: playbackListenable,
          builder: (context, playback, __) {
            return ValueListenableBuilder<double>(
              valueListenable: progressListenable,
              builder: (context, progress, ___) {
                return ValueListenableBuilder<String>(
                  valueListenable: stepLabelListenable,
                  builder: (context, stepLabel, ____) {
                    return AlgorithmAnimationPanel(
                      title: title,
                      description: description,
                      visual: builder(visuals),
                      accent: accent,
                      isPlaying: playback.playing,
                      onPlayPause: onPlayPause,
                      onStepBack: onStepBack,
                      onStepForward: onStepForward,
                      onReset: onReset,
                      progress: progress,
                      stepLabel: stepLabel,
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}

class _CodeSection extends StatelessWidget {
  final String pseudoCode;
  final Map<String, String> implementations;

  const _CodeSection({required this.pseudoCode, required this.implementations});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Pseudocode', style: theme.textTheme.titleMedium),
        const SizedBox(height: 12),
        CodeBlock(pseudoCode),
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
              children: implementations.entries.map((entry) {
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
