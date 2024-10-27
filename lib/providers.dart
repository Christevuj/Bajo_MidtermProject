import 'package:flutter/material.dart';

class TasksNotifier extends ChangeNotifier {
  final List<Map<String, dynamic>> _tasks = [];

  void updateTask(String id, Map<String, dynamic> newTask) {
    final index = _tasks.indexWhere((task) => task['id'] == id);
    if (index != -1) {
      _tasks[index] = newTask;
      notifyListeners();
    }
  }
}
