import 'package:flutter/material.dart';

class CodeBlock extends StatelessWidget {
  final String code;

  const CodeBlock(this.code, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: SelectableText(
        code,
        style:
            theme.textTheme.bodyMedium?.copyWith(
              fontFamily: 'monospace',
              height: 1.45,
              letterSpacing: 0.3,
              color: Colors.white,
            ) ??
            const TextStyle(
              fontFamily: 'monospace',
              height: 1.45,
              letterSpacing: 0.3,
              color: Colors.white,
            ),
      ),
    );
  }
}
