import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bajo_flutterapp/main.dart';

void main() {
  testWidgets('Task App Test', (WidgetTester tester) async {
    // Ensure the correct widget is referenced
    await tester.pumpWidget(const ProviderScope(child: MyApp())); // Change TaskApp to MyApp

    // Add a small delay to allow any animations to finish
    await tester.pumpAndSettle();

    // Update the expected text to match what you have in your app
    expect(find.text('Taskinator'), findsOneWidget); // Change to the correct title of your app
    expect(find.byIcon(Icons.add), findsOneWidget);
  });
}
