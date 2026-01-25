// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:algorythm_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Selection Sort page loads', (WidgetTester tester) async {
    await tester.pumpWidget(const AlgorythmApp());
    await tester.pumpAndSettle();

    const openSelectionButtonKey = ValueKey('open-selection');
    final Finder openWalkthroughButton = find.byKey(openSelectionButtonKey);

    await tester.ensureVisible(openWalkthroughButton);
    await tester.tap(openWalkthroughButton);
    await tester.pumpAndSettle();

    expect(find.text('Selection Sort Visual Guide'), findsOneWidget);
    expect(find.textContaining('Visualization & Complexity'), findsOneWidget);
  });
}
