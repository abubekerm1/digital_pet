import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:digital_pet/main.dart';

void main() {
  testWidgets('Care actions update meters and reset restores them',
      (WidgetTester tester) async {
    await tester.pumpWidget(const SmileyApp());

    expect(find.text('Happiness: 50 / 100'), findsOneWidget);
    expect(find.text('Hunger: 50 / 100'), findsOneWidget);

    await tester.ensureVisible(find.text('Feed'));
    await tester.tap(find.text('Feed'));
    await tester.pumpAndSettle();

    expect(find.text('Happiness: 60 / 100'), findsOneWidget);
    expect(find.text('Hunger: 40 / 100'), findsOneWidget);

    await tester.ensureVisible(find.text('Play'));
    await tester.tap(find.text('Play'));
    await tester.pumpAndSettle();

    expect(find.text('Happiness: 75 / 100'), findsOneWidget);
    expect(find.text('Hunger: 50 / 100'), findsOneWidget);

    await tester.ensureVisible(find.text('Reset / Restart'));
    await tester.tap(find.text('Reset / Restart'));
    await tester.pumpAndSettle();

    expect(find.text('Happiness: 50 / 100'), findsOneWidget);
    expect(find.text('Hunger: 50 / 100'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
  });
}