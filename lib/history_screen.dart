import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'task_screen.dart'; // Import the task screen for accessing TaskNotifier

// Define a provider for completed tasks
final completedTasksProvider = ChangeNotifierProvider<CompletedTasksNotifier>((ref) {
  return CompletedTasksNotifier();
});

// Completed Tasks Notifier
class CompletedTasksNotifier extends ChangeNotifier {
  List<Map<String, dynamic>> _completedTasks = [];

  List<Map<String, dynamic>> get completedTasks => _completedTasks;

  void addCompletedTask(Map<String, dynamic> task) {
    _completedTasks.add(task);
    notifyListeners(); // Notify listeners to update UI
  }
}

class HistoryScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Map<String, dynamic>> completedTasks = ref.watch(completedTasksProvider).completedTasks;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFE18AAA),
        centerTitle: true,
        title: Text(
          'Completed Tasks',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: completedTasks.length,
        itemBuilder: (context, index) {
          final task = completedTasks[index];
          return ListTile(
            title: Text(task['task']),
            subtitle: Text(
              'Completed on: ${task['date']?.toLocal().toString().split(' ')[0]} at ${task['time']?.format(context)}',
            ),
          );
        },
      ),
    );
  }
}
