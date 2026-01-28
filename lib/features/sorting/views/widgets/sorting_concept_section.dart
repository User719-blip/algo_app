import 'package:algorythm_app/core/models/algorithm_page_data.dart';
import 'package:algorythm_app/core/widgets/bullet_text.dart';
import 'package:algorythm_app/core/widgets/section_container.dart';
import 'package:algorythm_app/core/widgets/section_paragraph.dart';
import 'package:algorythm_app/core/widgets/section_subheading.dart';
import 'package:algorythm_app/core/widgets/section_title.dart';
import 'package:flutter/material.dart';

class SortingConceptSection extends StatelessWidget {
  final AlgorithmPageData data;

  const SortingConceptSection({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return SectionContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(title: '1. Conceptual Explanation'),
          const SizedBox(height: 16),
          SectionSubheading('What is ${data.name}?'),
          const SizedBox(height: 8),
          SectionParagraph(data.conceptSummary),
          const SizedBox(height: 18),
          const SectionSubheading('How it works'),
          const SizedBox(height: 8),
          ...data.conceptPoints.map(BulletText.new),
          const SizedBox(height: 18),
          const SectionSubheading('When to use it'),
          const SizedBox(height: 8),
          SectionParagraph(data.conceptUsage),
        ],
      ),
    );
  }
}
