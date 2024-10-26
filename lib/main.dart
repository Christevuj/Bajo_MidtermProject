import 'package:bajo_flutterapp/dashboard.dart'; // Import the Dashboard
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'tasks_provider.dart'; // Import your tasks provider
import 'landing_page.dart'; // Import the new landing page

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taskinator',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: const LandingPage(), // Set LandingPage as the initial screen
    );
  }
}
