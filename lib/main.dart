import 'package:flutter/material.dart';

void main() {
  runApp(TaskApp());
}

class TaskApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TASKINATOR',
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, dynamic>> _tasks = [];
  final List<Map<String, dynamic>> _completedTasks = []; // List for completed tasks
  final TextEditingController _controller = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  void _addTask() {
    if (_controller.text.isNotEmpty && _selectedDate != null && _selectedTime != null) {
      setState(() {
        _tasks.add({
          'task': _controller.text,
          'date': _selectedDate,
          'time': _selectedTime,
        });
        _controller.clear();
        _selectedDate = null;
        _selectedTime = null;
      });
    }
  }

  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _pickTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  void _removeTask(String task) {
    setState(() {
      _tasks.removeWhere((t) => t['task'] == task);
    });
  }

  void _markTaskAsComplete(Map<String, dynamic> task) {
    setState(() {
      _completedTasks.add(task); // Add task to completed tasks
      _tasks.remove(task); // Remove from active tasks
    });
  }

  void _navigateToTasks() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskListScreen(
          tasks: _tasks,
          markComplete: _markTaskAsComplete,
          removeTask: _removeTask,
        ),
      ),
    );
  }

  void _navigateToHistory() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HistoryScreen(completedTasks: _completedTasks),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
              controller: _controller,
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
                onPressed: _pickDate,
                child: Text(_selectedDate == null
                    ? 'Pick Date'
                    : '${_selectedDate!.toLocal()}'.split(' ')[0]),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: _pickTime,
                child: Text(_selectedTime == null
                    ? 'Pick Time'
                    : _selectedTime!.format(context)),
              ),
            ],
          ),
          SizedBox(height: 30),
          ElevatedButton(
            onPressed: _addTask,
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
            _navigateToTasks();
          } else if (index == 2) {
            _navigateToHistory();
          }
        },
      ),
    );
  }
}

class TaskListScreen extends StatelessWidget {
  final List<Map<String, dynamic>> tasks;
  final Function(Map<String, dynamic>) markComplete;
  final Function(String) removeTask;

  const TaskListScreen({
    required this.tasks,
    required this.markComplete,
    required this.removeTask,
  });

  @override
  Widget build(BuildContext context) {
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
                    Navigator.pop(context); // Go back after marking complete
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    removeTask(task['task']);
                    Navigator.pop(context); // Go back after deleting
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

class HistoryScreen extends StatelessWidget {
  final List<Map<String, dynamic>> completedTasks;

  const HistoryScreen({required this.completedTasks});

  @override
  Widget build(BuildContext context) {
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
