import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ChangeNotifier for managing tasks
class TasksNotifier extends ChangeNotifier {
  List<Map<String, dynamic>> _tasks = [];

  List<Map<String, dynamic>> get tasks => _tasks;

  void addTask(Map<String, dynamic> task) {
    _tasks.add(task);
    notifyListeners(); // Notify listeners to update UI
  }

  void removeTask(String task) {
    _tasks.removeWhere((t) => t['task'] == task);
    notifyListeners(); // Notify listeners to update UI
  }
}

// Provider for tasks
final tasksProvider = ChangeNotifierProvider<TasksNotifier>((ref) {
  return TasksNotifier();
});

// ChangeNotifier for managing completed tasks
class CompletedTasksNotifier extends ChangeNotifier {
  List<Map<String, dynamic>> _completedTasks = [];

  List<Map<String, dynamic>> get completedTasks => _completedTasks;

  void addCompletedTask(Map<String, dynamic> task) {
    _completedTasks.add(task);
    notifyListeners(); // Notify listeners to update UI
  }
}

// Provider for completed tasks
final completedTasksProvider = ChangeNotifierProvider<CompletedTasksNotifier>((ref) {
  return CompletedTasksNotifier();
});

// Screen for displaying and managing tasks
class TaskListScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskNotifier = ref.watch(tasksProvider);

    void markComplete(Map<String, dynamic> task) {
      // Logic for marking a task as complete
      ref.read(completedTasksProvider.notifier).addCompletedTask(task);
      taskNotifier.removeTask(task['task']);
      Navigator.pop(context); // Go back after completing the task
    }

    void removeTask(String task) {
      taskNotifier.removeTask(task);
      Navigator.pop(context); // Go back after removing the task
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFE18AAA),
        centerTitle: true,
        title: Text(
          'All Tasks',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: taskNotifier.tasks.length,
        itemBuilder: (context, index) {
          final task = taskNotifier.tasks[index];
          return ListTile(
            title: Text(task['task']),
            subtitle: Text(
              'Due: ${task['date']?.toLocal().toString().split(' ')[0]} at ${task['time']?.format(context)}',
            ),
            trailing: Wrap(
              spacing: 8.0,
              children: [
                IconButton(
                  icon: Icon(Icons.check, color: Colors.green),
                  onPressed: () {
                    markComplete(task); // Mark task as complete
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    removeTask(task['task']); // Remove task
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
