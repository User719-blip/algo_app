import 'package:flutter/material.dart';

import 'playback_controls.dart';

class AlgorithmAnimationPanel extends StatelessWidget {
  final String title;
  final String description;
  final Widget visual;
  final Color accent;
  final bool isPlaying;
  final VoidCallback onPlayPause;
  final String stepLabel;
  final double progress;
  final VoidCallback? onStepBack;
  final VoidCallback? onStepForward;
  final VoidCallback? onReset;
  final double visualMinHeight;

  const AlgorithmAnimationPanel({
    required this.title,
    required this.description,
    required this.visual,
    required this.accent,
    required this.isPlaying,
    required this.onPlayPause,
    required this.stepLabel,
    required this.progress,
    this.onStepBack,
    this.onStepForward,
    this.onReset,
    this.visualMinHeight = 220,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final List<Widget> controls = [];

    if (onReset != null) {
      controls.add(
        ControlIconButton(
          icon: Icons.rotate_left,
          tooltip: 'Reset to start',
          onTap: onReset,
        ),
      );
    }
    if (onStepBack != null) {
      controls.add(
        ControlIconButton(
          icon: Icons.skip_previous,
          tooltip: 'Previous step',
          onTap: onStepBack,
        ),
      );
    }

    controls.add(PlayPauseButton(isPlaying: isPlaying, onTap: onPlayPause));

    if (onStepForward != null) {
      controls.add(
        ControlIconButton(
          icon: Icons.skip_next,
          tooltip: 'Next step',
          onTap: onStepForward,
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.titleMedium),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              final double availableWidth = constraints.maxWidth;
              double width = availableWidth;
              if (availableWidth.isFinite) {
                if (availableWidth > 560) {
                  width = 560;
                } else if (availableWidth > 280) {
                  width = availableWidth;
                } else {
                  width = availableWidth;
                }
              } else {
                width = 400;
              }

              return ConstrainedBox(
                constraints: BoxConstraints(minHeight: visualMinHeight),
                child: Align(
                  alignment: Alignment.center,
                  child: SizedBox(width: width, child: visual),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.78),
            ),
          ),
          const SizedBox(height: 18),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 12,
            runSpacing: 12,
            children: controls,
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
          const SizedBox(height: 8),
          Text(
            stepLabel,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
