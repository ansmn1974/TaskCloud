import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:taskcloud/main.dart';

void main() {
  testWidgets('Add task flow updates list', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Should see empty state
    expect(find.text('No tasks yet'), findsOneWidget);

    // Tap FAB to navigate to AddTaskScreen
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    // Fill form
    await tester.enterText(find.byType(TextFormField).at(0), 'Buy milk');
    await tester.enterText(find.byType(TextFormField).at(1), '2L semi-skimmed');

    // Save
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    // Back on home; list should contain one item and not show empty state
    expect(find.text('No tasks yet'), findsNothing);
    expect(find.text('Buy milk'), findsOneWidget);
  });
}
