import 'package:algorythm_app/core/models/dry_run_pass.dart';
import 'package:algorythm_app/core/theme/app_colors.dart';
import 'package:algorythm_app/core/widgets/bullet_text.dart';
import 'package:algorythm_app/core/widgets/code_block.dart';
import 'package:algorythm_app/core/widgets/section_container.dart';
import 'package:algorythm_app/core/widgets/section_title.dart';
import 'package:flutter/material.dart';

class ArrayResourcesSection extends StatelessWidget {
  final List<DryRunPass> dryRuns;
  final String pseudoCode;
  final Map<String, String> implementations;

  const ArrayResourcesSection({
    required this.dryRuns,
    required this.pseudoCode,
    required this.implementations,
    super.key,
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
          const SectionTitle(title: '3. Dry Runs & Code References'),
          const SizedBox(height: 16),
          _DryRunList(dryRuns: dryRuns, highlightStyle: _highlightStyle(theme)),
          const SizedBox(height: 24),
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
