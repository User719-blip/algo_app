import 'package:flutter/material.dart';

class SectionSubheading extends StatelessWidget {
  final String text;

  const SectionSubheading(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text(
      text,
      style:
          theme.textTheme.titleMedium?.copyWith(color: Colors.white) ??
          const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
    );
  }
}
