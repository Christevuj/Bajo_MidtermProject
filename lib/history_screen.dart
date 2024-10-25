import 'package:flutter/material.dart';

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
