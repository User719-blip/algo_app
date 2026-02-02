import 'package:algorythm_app/core/models/algorithm_page_data.dart';
import 'package:algorythm_app/core/widgets/bullet_text.dart';
import 'package:algorythm_app/core/widgets/section_container.dart';
import 'package:algorythm_app/core/widgets/section_paragraph.dart';
import 'package:algorythm_app/core/widgets/section_subheading.dart';
import 'package:algorythm_app/core/widgets/section_title.dart';
import 'package:flutter/material.dart';

class ArrayConceptSection extends StatelessWidget {
  final AlgorithmPageData data;

  const ArrayConceptSection({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return SectionContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(title: '1. Concept & Intuition'),
          const SizedBox(height: 16),
          SectionSubheading('Why ${data.name}?'),
          const SizedBox(height: 8),
          SectionParagraph(data.conceptSummary),
          const SizedBox(height: 18),
          const SectionSubheading('Key ideas'),
          const SizedBox(height: 8),
          ...data.conceptPoints.map(BulletText.new),
          const SizedBox(height: 18),
          const SectionSubheading('Use cases'),
          const SizedBox(height: 8),
          SectionParagraph(data.conceptUsage),
        ],
      ),
    );
  }
}
