import 'package:flutter_riverpod/flutter_riverpod.dart';

final tasksProvider = StateNotifierProvider<TasksNotifier, List<Map<String, dynamic>>>((ref) {
  return TasksNotifier();
});

class TasksNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  int _nextId = 0; 
  final List<Map<String, dynamic>> _completedTasks = []; 
  final List<Map<String, dynamic>> _deletedTasks = []; 

  TasksNotifier() : super([]);


  void addTask(Map<String, dynamic> task) {
    task['id'] = _nextId++;
    state = [...state, task];
  }


  void updateTask(int id, Map<String, dynamic> updatedTask) {
    state = [
      for (final task in state)
        if (task['id'] == id) 
          {...task, ...updatedTask} 
        else 
          task,
    ];
  }


  void completeTask(int id) {
    final taskToComplete = state.firstWhere((task) => task['id'] == id);
    state = state.where((task) => task['id'] != id).toList(); 
    _completedTasks.add({...taskToComplete, 'label': 'COMPLETED TASK'}); 
  }

  void deleteTask(int id) {
    final taskToDelete = state.firstWhere((task) => task['id'] == id);
    state = state.where((task) => task['id'] != id).toList(); 
    _deletedTasks.add({...taskToDelete, 'label': 'DELETED TASK'}); 
  }


  List<Map<String, dynamic>> get completedTasks => _completedTasks;


  List<Map<String, dynamic>> get deletedTasks => _deletedTasks;
}
