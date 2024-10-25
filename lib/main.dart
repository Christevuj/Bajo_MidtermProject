import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'task_screen.dart';
import 'history_screen.dart';

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
final tasksProvider = ChangeNotifierProvider<TasksNotifier>((ref) {
  return TasksNotifier();
});

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskNotifier = ref.watch(tasksProvider);
    final TextEditingController controller = TextEditingController();
    DateTime? selectedDate;
    TimeOfDay? selectedTime;

    void addTask() {
      if (controller.text.isNotEmpty && selectedDate != null && selectedTime != null) {
        taskNotifier.addTask({
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
        backgroundColor: Color(0xFFE18AAA),
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
            child: Text('Add Task', style: TextStyle(color: Colors.black)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFE4A0B7),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
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
