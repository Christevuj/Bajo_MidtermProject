import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bajo_flutterapp/add_task_screen.dart';
import 'package:bajo_flutterapp/history_screen.dart';
import 'tasks_provider.dart'; // Import the tasks provider
import 'edit_task_screen.dart'; // Import the edit task screen

class Dashboard extends ConsumerWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Map<String, dynamic>> tasks = ref.watch(tasksProvider); // Watch the tasks list

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromARGB(255, 190, 117, 190), // Violet
                Color(0xFFE5D0FF),
              ],
            ),
          ),
        ),
        centerTitle: true,
        elevation: 5,
        shadowColor: Colors.grey.withOpacity(0.5),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.task, color: Colors.white, size: 30),
            SizedBox(width: 10),
            Text(
              'Taskinator',
              style: TextStyle(
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'RobotoMono',
              ),
            ),
          ],
        ),
        iconTheme: const IconThemeData(
          color: Colors.white, // Set back button color to white
        ),
      ),
      body: tasks.isEmpty
          ? const Center(child: Text('No tasks available.'))
          : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => EditTaskScreen(task: task),
                      ));
                    },
                    child: TaskCard(
                      task: task,
                      onComplete: () {
                        ref.read(tasksProvider.notifier).completeTask(task['id']);
                      },
                      onDelete: () {
                        ref.read(tasksProvider.notifier).deleteTask(task['id']);
                      },
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const AddTaskScreen(),
          ));
        },
        backgroundColor: const Color.fromARGB(255, 190, 117, 190),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
        ],
        onTap: (index) {
          if (index == 1) {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const HistoryScreen(),
            ));
          }
        },
      ),
    );
  }
}

class TaskCard extends StatelessWidget {
  final Map<String, dynamic> task;
  final VoidCallback onComplete;
  final VoidCallback onDelete;

  const TaskCard({
    super.key,
    required this.task,
    required this.onComplete,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: _getTaskIcon(task),
        title: Text(
          task['title'],
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRowWithIcon(
              Icons.description, task['description'] ?? 'No description available',
            ),
            const SizedBox(height: 4),
            _buildRowWithIcon(
              Icons.calendar_today,
              'Date: ${task['date']?.toLocal().toString().split(' ')[0] ?? 'N/A'}',
            ),
            _buildRowWithIcon(
              Icons.access_time, 
              'Time: ${_formatTime(task['time'])}', // Format time here
            ),
            const SizedBox(height: 4),
            _buildRowWithIcon(
              Icons.priority_high,
              'Priority: ${task['priority'] ?? 'N/A'}',
              color: _getPriorityColor(task['priority'] ?? 'N/A'),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.check, color: Colors.green),
              onPressed: onComplete,
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }

  Widget _getTaskIcon(Map<String, dynamic> task) {
    switch (task['priority']) {
      case 'High':
        return const Icon(Icons.warning, color: Colors.red);
      case 'Medium':
        return const Icon(Icons.flag, color: Colors.orange);
      case 'Low':
        return const Icon(Icons.check_circle, color: Colors.green);
      default:
        return const Icon(Icons.task, color: Colors.grey);
    }
  }

  Widget _buildRowWithIcon(IconData icon, String text, {Color? color}) {
    return Row(
      children: [
        Icon(icon, size: 20, color: color ?? Colors.black),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(color: color ?? Colors.black),
          ),
        ),
      ],
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'High':
        return const Color(0xFF7E60BF);
      case 'Medium':
        return Colors.orange;
      case 'Low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _formatTime(TimeOfDay? time) {
    if (time == null) {
      return 'N/A';
    }
    // Format TimeOfDay to a string in "HH:MM" format
    final hour = time.hour % 12; // Convert to 12-hour format
    final minute = time.minute.toString().padLeft(2, '0');
    final suffix = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $suffix';
  }
}
