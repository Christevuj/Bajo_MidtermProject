import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'history_screen.dart';
import 'add_task_screen.dart';

class TasksNotifier extends ChangeNotifier {
  final List<Map<String, dynamic>> _tasks = [];

  List<Map<String, dynamic>> get tasks => _tasks;

  void addTask(Map<String, dynamic> task) {
    task['id'] = DateTime.now().millisecondsSinceEpoch.toString();
    _tasks.add(task);
    notifyListeners();
  }

  void removeTask(String taskTitle) {
    _tasks.removeWhere((t) => t['title'] == taskTitle);
    notifyListeners();
  }

  void updateTask(String id, Map<String, dynamic> updatedTask) {
    final index = _tasks.indexWhere((task) => task['id'] == id);
    if (index != -1) {
      _tasks[index] = {
        'id': id,
        'title': updatedTask['title'],
        'description': updatedTask['description'],
        'date': updatedTask['date'],
        'time': updatedTask['time'],
        'priority': updatedTask['priority'],
      };
      notifyListeners();
    }
  }

  void completeTask(task) {}

  void deleteTask(task) {}
}

// Riverpod Provider for tasks
final tasksProvider = ChangeNotifierProvider((ref) => TasksNotifier());

class TaskListScreen extends ConsumerWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(tasksProvider).tasks;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Manager'),
        centerTitle: true,
      ),
      body: Container(
        margin: const EdgeInsets.all(16.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: tasks.isEmpty
            ? const Center(child: Text('No tasks available.'))
            : ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(task['title']),
                      subtitle: Text(
                          'Due: ${task['date'].toLocal().toString().split(' ')[0]} at ${task['time'].format(context)}'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddTaskScreen(task: task),
                          ),
                        );
                      },
                      trailing: Wrap(
                        spacing: 8.0,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.check, color: Colors.green),
                            onPressed: () {
                              ref
                                  .read(tasksProvider.notifier)
                                  .completeTask(task['id']);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              ref
                                  .read(tasksProvider.notifier)
                                  .deleteTask(task['id']);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: Stack(
        alignment: Alignment.center,
        children: [
          const SizedBox(height: 50),
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddTaskScreen()),
              );
            },
            child: const Icon(Icons.add),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.history),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const HistoryScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
