import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: TaskApp()));
}

class TaskApp extends StatelessWidget {
  const TaskApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TASKINATOR',
      home: const HomeScreen(),
    );
  }
}

// Define a provider for tasks
final tasksProvider = StateNotifierProvider<TasksNotifier, List<Map<String, dynamic>>>((ref) {
  return TasksNotifier();
});

// Define a provider for completed tasks
final completedTasksProvider = StateNotifierProvider<CompletedTasksNotifier, List<Map<String, dynamic>>>((ref) {
  return CompletedTasksNotifier();
});

// Tasks Notifier
class TasksNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  TasksNotifier() : super([]);

  void addTask(Map<String, dynamic> task) {
    state = [...state, task];
  }

  void removeTask(String task) {
    state = state.where((t) => t['task'] != task).toList();
  }
}

// Completed Tasks Notifier
class CompletedTasksNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  CompletedTasksNotifier() : super([]);

  void addCompletedTask(Map<String, dynamic> task) {
    state = [...state, task];
  }
}

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(tasksProvider);
    final TextEditingController controller = TextEditingController();
    DateTime? selectedDate;
    TimeOfDay? selectedTime;

    void addTask() {
      if (controller.text.isNotEmpty && selectedDate != null && selectedTime != null) {
        ref.read(tasksProvider.notifier).addTask({
          'task': controller.text,
          'date': selectedDate,
          'time': selectedTime,
        });
        controller.clear();
        selectedDate = null;
        selectedTime = null;
      }
    }

    Future<void> pickDate() async {
      DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
      );

      if (pickedDate != null) {
        selectedDate = pickedDate;
      }
    }

    Future<void> pickTime() async {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        selectedTime = pickedTime;
      }
    }

    void navigateToTasks() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TaskListScreen(),
        ),
      );
    }

    void navigateToHistory() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HistoryScreen(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFE18AAA), // Charm Pink
        centerTitle: true,
        title: Text(
          'TASKINATOR',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Enter a task',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: pickDate,
                child: Text(selectedDate == null
                    ? 'Pick Date'
                    : '${selectedDate!.toLocal()}'.split(' ')[0]),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: pickTime,
                child: Text(selectedTime == null
                    ? 'Pick Time'
                    : selectedTime!.format(context)),
              ),
            ],
          ),
          SizedBox(height: 30),
          ElevatedButton(
            onPressed: addTask,
            child: Text('Add Task', style: TextStyle(color: Colors.black)), // Set font color to black
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFE4A0B7), // Set the button color to Kobi
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.zero, // Makes the button square
              ),
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20), // Adjust padding as needed
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
        ],
        onTap: (index) {
          if (index == 1) {
            navigateToTasks();
          } else if (index == 2) {
            navigateToHistory();
          }
        },
      ),
    );
  }
}

class TaskListScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Map<String, dynamic>> tasks = ref.watch(tasksProvider);

    void markComplete(Map<String, dynamic> task) {
      ref.read(completedTasksProvider.notifier).addCompletedTask(task);
      ref.read(tasksProvider.notifier).removeTask(task['task']);
      Navigator.pop(context); // Go back after marking complete
    }

    void removeTask(String task) {
      ref.read(tasksProvider.notifier).removeTask(task);
      Navigator.pop(context); // Go back after deleting
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFE18AAA), // Charm Pink
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
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
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
                    markComplete(task);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    removeTask(task['task']);
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

class HistoryScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Map<String, dynamic>> completedTasks = ref.watch(completedTasksProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFE18AAA), // Charm Pink
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
