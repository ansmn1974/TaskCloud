// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:taskcloud/main.dart';

void main() {
  testWidgets('Home shows empty state; Add task works', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Empty state
    expect(find.text('No tasks yet'), findsOneWidget);

    // Add via FAB through form
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).at(0), 'Test task');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('No tasks yet'), findsNothing);
    expect(find.text('Test task'), findsOneWidget);
  });
}
