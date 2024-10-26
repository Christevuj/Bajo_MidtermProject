import 'package:flutter_riverpod/flutter_riverpod.dart';

final tasksProvider = StateNotifierProvider<TasksNotifier, List<Map<String, dynamic>>>((ref) {
  return TasksNotifier();
});

class TasksNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  int _nextId = 0; // Initialize an ID counter
  final List<Map<String, dynamic>> _completedTasks = []; // Store completed tasks
  final List<Map<String, dynamic>> _deletedTasks = []; // Store deleted tasks

  TasksNotifier() : super([]);

  // Method to add a task
  void addTask(Map<String, dynamic> task) {
    task['id'] = _nextId++;
    state = [...state, task];
  }

  // Method to update a task
  void updateTask(int id, Map<String, dynamic> updatedTask) {
    state = [
      for (final task in state)
        if (task['id'] == id) 
          {...task, ...updatedTask} // Update task with new values
        else 
          task,
    ];
  }

  // Method to complete a task
  void completeTask(int id) {
    final taskToComplete = state.firstWhere((task) => task['id'] == id);
    state = state.where((task) => task['id'] != id).toList(); // Remove from dashboard
    _completedTasks.add({...taskToComplete, 'label': 'COMPLETED TASK'}); // Add to completed tasks
  }

  // Method to delete a task
  void deleteTask(int id) {
    final taskToDelete = state.firstWhere((task) => task['id'] == id);
    state = state.where((task) => task['id'] != id).toList(); // Remove from dashboard
    _deletedTasks.add({...taskToDelete, 'label': 'DELETED TASK'}); // Add to deleted tasks
  }

  // Method to get completed tasks
  List<Map<String, dynamic>> get completedTasks => _completedTasks;

  // Method to get deleted tasks
  List<Map<String, dynamic>> get deletedTasks => _deletedTasks;
}
