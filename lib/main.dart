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
  final List<String> _tasks = [];
  final TextEditingController _controller = TextEditingController();

  void _addTask() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _tasks.add(_controller.text);
        _controller.clear();
      });
    }
  }

  void _removeTask(String task) {
    setState(() {
      _tasks.remove(task);
    });
  }

  void _navigateToTasks() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskListScreen(
          tasks: _tasks,
          removeTask: _removeTask,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center, // Center the title
          children: [
            Text('TASKINATOR'),
          ],
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
          ElevatedButton(
            onPressed: _addTask,
            child: Icon(Icons.add),
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
        ],
        onTap: (index) {
          if (index == 1) {
            _navigateToTasks();
          }
        },
      ),
    );
  }
}

class TaskListScreen extends StatelessWidget {
  final List<String> tasks;
  final Function(String) removeTask;

  const TaskListScreen({required this.tasks, required this.removeTask});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center, // Center the title
          children: [
            Text('All Tasks'),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(tasks[index]),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                removeTask(tasks[index]);
                Navigator.pop(context); // Go back after removing
              },
            ),
          );
        },
      ),
    );
  }
}
