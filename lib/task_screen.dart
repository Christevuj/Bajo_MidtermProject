import 'package:flutter/material.dart';

class TaskScreen extends StatefulWidget {
  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final List<String> _tasks = [];
  final TextEditingController _taskController = TextEditingController();

  void _addTask() {
    if (_taskController.text.isNotEmpty) {
      setState(() {
        _tasks.add(_taskController.text);
        _taskController.clear();
      });
    }
  }

  void _removeTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  void _toggleTaskDone(int index) {
    // Optional: You can implement functionality to mark tasks as done here
    // For now, just removing the task when marked done for simplicity
    _removeTask(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Manager'),
      ),
      body: Column(
        children: [
          // Input field and button
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _taskController,
                    decoration: InputDecoration(
                      hintText: 'Enter a task',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: _addTask,
                  color: Colors.blue,
                ),
              ],
            ),
          ),
          // Task List
          Expanded(
            child: ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_tasks[index]),
                  trailing: Wrap(
                    children: [
                      IconButton(
                        icon: Icon(Icons.check, color: Colors.green),
                        onPressed: () => _toggleTaskDone(index),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _removeTask(index),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
