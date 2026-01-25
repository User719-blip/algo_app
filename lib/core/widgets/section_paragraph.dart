import 'package:flutter/material.dart';

class SectionParagraph extends StatelessWidget {
  final String text;

  const SectionParagraph(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text(
      text,
      style:
          theme.textTheme.bodyMedium?.copyWith(
            color: Colors.white.withValues(alpha: 0.78),
          ) ??
          TextStyle(color: Colors.white.withValues(alpha: 0.78)),
    );
  }
}
