import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class ControlIconButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback? onTap;

  const ControlIconButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final Color color = onTap == null
        ? Colors.white.withValues(alpha: 0.18)
        : Colors.white.withValues(alpha: 0.3);

    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(40),
        child: Ink(
          height: 52,
          width: 52,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(40),
            border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
          ),
          child: Icon(icon, color: Colors.white, size: 26),
        ),
      ),
    );
  }
}

class PlayPauseButton extends StatelessWidget {
  final bool isPlaying;
  final VoidCallback onTap;

  const PlayPauseButton({
    required this.isPlaying,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: isPlaying ? 'Pause' : 'Play',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(40),
        child: Ink(
          height: 64,
          width: 64,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.sorted, const Color(0xFF2563eb)],
            ),
            borderRadius: BorderRadius.circular(40),
            boxShadow: const [
              BoxShadow(
                color: Color(0x5538bdf8),
                blurRadius: 18,
                offset: Offset(0, 12),
              ),
            ],
          ),
          child: Icon(
            isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
            color: Colors.white,
            size: 36,
          ),
        ),
      ),
    );
  }
}
