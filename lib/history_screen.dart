import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'tasks_provider.dart'; // Import the tasks provider

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final completedTasks = ref.watch(tasksProvider.notifier).completedTasks;
    final deletedTasks = ref.watch(tasksProvider.notifier).deletedTasks;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'History',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 255, 255, 255), // Set text color to white
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 190, 117, 190), // Violet
                Color(0xFFE5D0FF)
              ], // Gradient colors
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 4, // Add shadow
        iconTheme: const IconThemeData(color: Colors.white), // Set back button color to white
      ),
      body: completedTasks.isEmpty && deletedTasks.isEmpty
          ? Center(
              child: Text(
                'No completed tasks or deleted tasks available.',
                style: const TextStyle(fontSize: 14), // Adjusted font size
              ),
            )
          : ListView(
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                ),
                // Display completed tasks
                ...completedTasks.map((task) => GestureDetector(
                      onTap: () => _showTaskDetails(context, task),
                      child: _buildTaskContainer(
                        task: task,
                        icon: Icons
                            .check_circle, // Check-circle icon for completed tasks
                        iconColor: Colors.green,
                        backgroundColor: Colors.grey[200]!,
                      ),
                    )),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                ),
                // Display deleted tasks
                ...deletedTasks.map((task) => GestureDetector(
                      onTap: () => _showTaskDetails(context, task),
                      child: _buildTaskContainer(
                        task: task,
                        icon: Icons.delete, // Delete icon for deleted tasks
                        iconColor: Colors.red,
                        backgroundColor: Colors.red[100]!,
                      ),
                    )),
              ],
            ),
    );
  }

  Widget _buildTaskContainer({
    required Map<String, dynamic> task,
    required IconData icon,
    required Color iconColor,
    required Color backgroundColor,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 28), // Task icon on the left
          const SizedBox(width: 16), // Spacing between icon and title
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                task['title'],
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(task['label'] ?? 'No label available'),
            ],
          ),
        ],
      ),
    );
  }

  void _showTaskDetails(BuildContext context, Map<String, dynamic> task) {
    // Format the date to show only the date portion
    final formattedDate = DateFormat('yyyy-MM-dd').format(task['date']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(task['title']),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Description: ${task['description']}'),
              Text('Date: $formattedDate'),
              Text(
                  'Time: ${task['time'].format(context)}'), // Use TimeOfDay conversion
              Text('Priority: ${task['priority']}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
