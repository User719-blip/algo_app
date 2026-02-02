import 'package:algorythm_app/core/theme/app_colors.dart';
import 'package:algorythm_app/core/widgets/bullet_text.dart';
import 'package:algorythm_app/core/widgets/section_container.dart';
import 'package:algorythm_app/core/widgets/section_paragraph.dart';
import 'package:algorythm_app/core/widgets/section_subheading.dart';
import 'package:algorythm_app/core/widgets/section_title.dart';
import 'package:algorythm_app/array_analyzer_page.dart';
import 'package:algorythm_app/features/arrays/data/array_algorithms.dart';
import 'package:algorythm_app/features/arrays/models/array_algorithm_config.dart';
import 'package:flutter/material.dart';

class ArrayAlgorithmsPage extends StatelessWidget {
  const ArrayAlgorithmsPage({super.key});

  void _openVisualizer(BuildContext context, ArrayAlgorithmConfig config) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ArrayAnalyzerPage(initialAlgorithm: config.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.gradientTop, AppColors.gradientBottom],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Array Algorithm Visualizer',
                  style: theme.textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'Dive into sliding windows, prefix tricks, and other array staples with live step tracking.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.72),
                  ),

                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),
                ...arrayAlgorithmList.expand((config) {
                  return [
                    SectionContainer(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SectionTitle(
                            title: config.data.name,
                            subtitle: config.data.tagline,
                          ),
                          const SizedBox(height: 18),
                          SectionSubheading('Concept highlights'),
                          const SizedBox(height: 8),
                          SectionParagraph(config.data.conceptSummary),
                          const SizedBox(height: 18),
                          SectionSubheading('Key steps'),
                          const SizedBox(height: 8),
                          ...config.data.conceptPoints
                              .take(3)
                              .map((point) => BulletText(point)),
                          const SizedBox(height: 18),
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: config.data.complexity.take(2).map((
                              item,
                            ) {
                              return SizedBox(
                                width: 220,
                                child: Container(
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.08),
                                    borderRadius: BorderRadius.circular(18),
                                    border: Border.all(
                                      color: Colors.white.withValues(
                                        alpha: 0.12,
                                      ),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.title,
                                        style: theme.textTheme.titleMedium,
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        item.complexity,
                                        style:
                                            theme.textTheme.titleLarge
                                                ?.copyWith(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w700,
                                                ) ??
                                            const TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w700,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 22),
                          Align(
                            alignment: Alignment.centerRight,
                            child: FilledButton.icon(
                              key: ValueKey('open-array-${config.id.name}'),
                              onPressed: () => _openVisualizer(context, config),
                              style: FilledButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                backgroundColor: AppColors.sorted.withValues(
                                  alpha: 0.85,
                                ),
                              ),
                              icon: const Icon(Icons.play_arrow_rounded),
                              label: const Text('Open visual walkthrough'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ];
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
