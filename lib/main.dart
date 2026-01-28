import 'package:algorythm_app/features/sorting/views/pages/sorting_algorithms_page.dart';
import 'package:algorythm_app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const AlgorythmApp());
}

class AlgorythmApp extends StatelessWidget {
  const AlgorythmApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.build(),
      home: const SortingAlgorithmsPage(),
    );
  }
}
