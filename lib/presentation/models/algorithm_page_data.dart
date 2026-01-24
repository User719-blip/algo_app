import 'package:algorythm_app/presentation/models/complexity_item.dart';
import 'package:algorythm_app/presentation/models/dry_run_pass.dart';

class AlgorithmPageData {
  final String name;
  final String tagline;
  final String conceptSummary;
  final List<String> conceptPoints;
  final String conceptUsage;
  final List<DryRunPass> dryRuns;
  final List<ComplexityItem> complexity;
  final String pseudoCode;
  final Map<String, String> implementations;

  const AlgorithmPageData({
    required this.name,
    required this.tagline,
    required this.conceptSummary,
    required this.conceptPoints,
    required this.conceptUsage,
    required this.dryRuns,
    required this.complexity,
    required this.pseudoCode,
    required this.implementations,
  });
}
