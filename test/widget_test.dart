import 'package:bajo_flutterapp/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Task App Test', (WidgetTester tester) async {
    await tester.pumpWidget(TaskApp());

    // Verify that the initial UI is displayed
    expect(find.text('Task Manager'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);

    // Enter a task
    await tester.enterText(find.byType(TextField), 'Test Task');
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that the task was added
    expect(find.text('Test Task'), findsOneWidget);

    // Mark task as done
    await tester.tap(find.byIcon(Icons.check));
    await tester.pump();

    // Verify that the task was removed
    expect(find.text('Test Task'), findsNothing);

    // Add another task
    await tester.enterText(find.byType(TextField), 'Another Task');
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that the new task was added
    expect(find.text('Another Task'), findsOneWidget);

    // Remove the task
    await tester.tap(find.byIcon(Icons.delete));
    await tester.pump();

    // Verify that the task was removed
    expect(find.text('Another Task'), findsNothing);
  });
}
