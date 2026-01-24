import 'package:algorythm_app/presentation/pages/sorting_visualizer_page.dart';
import 'package:algorythm_app/presentation/theme/app_theme.dart';
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
      home: const SortingVisualizerPage(),
    );
  }
}
