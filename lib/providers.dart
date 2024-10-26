import 'package:flutter/material.dart';

class TasksNotifier extends ChangeNotifier {
  final List<Map<String, dynamic>> _tasks = []; // Example tasks list

  // Method to update a task
  void updateTask(String id, Map<String, dynamic> newTask) {
    // Find the task by id and update it
    final index = _tasks.indexWhere((task) => task['id'] == id);
    if (index != -1) {
      _tasks[index] = newTask; // Update the task
      notifyListeners(); // Notify listeners for UI updates
    }
  }

  // Other methods (like addTask, removeTask, etc.) can go here
}
