import 'package:algorythm_app/core/theme/app_colors.dart';
import 'package:algorythm_app/core/widgets/bullet_text.dart';
import 'package:algorythm_app/core/widgets/section_container.dart';
import 'package:algorythm_app/core/widgets/section_paragraph.dart';
import 'package:algorythm_app/core/widgets/section_subheading.dart';
import 'package:algorythm_app/core/widgets/section_title.dart';
import 'package:algorythm_app/features/arrays/views/pages/array_algorithms_page.dart';
import 'package:algorythm_app/features/sorting/views/pages/sorting_algorithms_page.dart';
import 'package:flutter/material.dart';

class AlgorithmHomePage extends StatefulWidget {
  const AlgorithmHomePage({super.key});

  @override
  State<AlgorithmHomePage> createState() => _AlgorithmHomePageState();
}

class _AlgorithmHomePageState extends State<AlgorithmHomePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _openSorting() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const SortingAlgorithmsPage()));
  }

  void _openArrays() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const ArrayAlgorithmsPage()));
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
          child: Scrollbar(
            controller: _scrollController,
            thumbVisibility: true,
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Algorithm Explorer',
                    style: theme.textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Pick a track to deep-dive through visual explainers, dry runs, and annotated code.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  SectionContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SectionTitle(
                          title: 'Sorting algorithms',
                          subtitle:
                              'Animate comparisons, swaps, and invariants.',
                        ),
                        const SizedBox(height: 18),
                        const SectionSubheading('What you will explore'),
                        const SizedBox(height: 8),
                        const SectionParagraph(
                          'Track side-by-side bar and tile animations, inspect invariant overlays, and compare classic routines.',
                        ),
                        const SizedBox(height: 18),
                        const SectionSubheading('Highlights'),
                        const SizedBox(height: 8),
                        const BulletText(
                          'Dual visualizations for bars and tiles with synced playback controls.',
                        ),
                        const BulletText(
                          'Step transcripts, invariants, and dry runs bundled per algorithm.',
                        ),
                        const BulletText(
                          'Copy-ready code snippets across multiple languages.',
                        ),
                        const SizedBox(height: 22),
                        Align(
                          alignment: Alignment.centerRight,
                          child: FilledButton.icon(
                            key: const ValueKey('open-sorting-track'),
                            onPressed: _openSorting,
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
                            label: const Text('Explore sorting track'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  SectionContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SectionTitle(
                          title: 'Array algorithms',
                          subtitle:
                              'Visualize sliding windows, prefixes, and Kadane frames.',
                        ),
                        const SizedBox(height: 18),
                        const SectionSubheading('What you will explore'),
                        const SizedBox(height: 8),
                        const SectionParagraph(
                          'Follow window expansions, range highlights, and log streams while iterating through curated dry runs.',
                        ),
                        const SizedBox(height: 18),
                        const SectionSubheading('Highlights'),
                        const SizedBox(height: 8),
                        const BulletText(
                          'Range-aware bar charts with current and best window indicators.',
                        ),
                        const BulletText(
                          'Live narration, step logs, and summary chips for running totals.',
                        ),
                        const BulletText(
                          'Pseudocode plus multi-language implementations ready to copy.',
                        ),
                        const SizedBox(height: 22),
                        Align(
                          alignment: Alignment.centerRight,
                          child: FilledButton.icon(
                            key: const ValueKey('open-array-track'),
                            onPressed: _openArrays,
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
                            label: const Text('Explore array track'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'More visual walkthroughs coming soon.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
