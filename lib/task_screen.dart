import 'package:flutter/material.dart';

class TaskScreen extends StatefulWidget {
  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final List<Map<String, dynamic>> _tasks = []; // Active tasks list
  final List<Map<String, dynamic>> _history = []; // Completed tasks history
  final TextEditingController _taskController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  void _addTask() {
    if (_taskController.text.isNotEmpty && _selectedDate != null && _selectedTime != null) {
      setState(() {
        _tasks.add({
          'task': _taskController.text,
          'date': _selectedDate,
          'time': _selectedTime,
        });
        _taskController.clear();
        _selectedDate = null;
        _selectedTime = null;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a task, date, and time.')),
      );
    }
  }

  void _removeTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  void _toggleTaskDone(int index) {
    setState(() {
      // Move the completed task to history
      _history.add(_tasks[index]);
      _tasks.removeAt(index);
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: AppBar(
          backgroundColor: Color(0xFFE18AAA), // Charm Pink
          elevation: 5.0,
          title: Row(
            children: [
              Icon(Icons.home, size: 28.0),
              SizedBox(width: 10),
              Text('Home', style: TextStyle(fontSize: 18.0)),
              Spacer(),
              IconButton(
                icon: Icon(Icons.history),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HistoryScreen(history: _history)),
                  );
                },
                color: Colors.white70, // History button
              ),
              CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, color: Color(0xFFE18AAA)),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
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
                  color: Color(0xFFECBDC4), // Cameo Pink
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => _selectDate(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFECBDC4), // Cameo Pink
                ),
                child: Text('Select Date'),
              ),
              ElevatedButton(
                onPressed: () => _selectTime(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFECBDC4), // Cameo Pink
                ),
                child: Text('Select Time'),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                final task = _tasks[index];
                final date = task['date'];
                final time = task['time'];

                return ListTile(
                  title: Text(task['task']),
                  subtitle: Text(
                    'Due: ${date?.toLocal().toString().split(' ')[0]} ${time?.format(context)}',
                  ),
                  trailing: Wrap(
                    spacing: 8,
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

class HistoryScreen extends StatelessWidget {
  final List<Map<String, dynamic>> history;

  HistoryScreen({required this.history});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFE18AAA), // Charm Pink
        title: Text('Task History'),
      ),
      body: ListView.builder(
        itemCount: history.length,
        itemBuilder: (context, index) {
          final task = history[index];
          final date = task['date'];
          final time = task['time'];

          return ListTile(
            title: Text(task['task']),
            subtitle: Text(
              'Completed: ${date?.toLocal().toString().split(' ')[0]} ${time?.format(context)}',
            ),
          );
        },
      ),
    );
  }
}
