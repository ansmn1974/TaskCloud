import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:taskcloud/main.dart';

void main() {
  testWidgets('Edit task flow updates title', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Add a task first via UI
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(0), 'Original');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.text('Original'), findsOneWidget);

    // Tap the list tile to open edit
    await tester.tap(find.text('Original'));
    await tester.pumpAndSettle();

    // Change title and save changes
    await tester.enterText(find.byType(TextFormField).at(0), 'Updated');
    await tester.tap(find.text('Save changes'));
    await tester.pumpAndSettle();

    expect(find.text('Original'), findsNothing);
    expect(find.text('Updated'), findsOneWidget);
  });
}
