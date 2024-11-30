import 'dart:async';  // Import Timer for updating the time every second
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bajo_flutterapp/add_task_screen.dart';
import 'package:bajo_flutterapp/history_screen.dart';
import 'tasks_provider.dart';
import 'edit_task_screen.dart';
import 'package:intl/intl.dart';  // Import intl package for date formatting

final searchQueryProvider = StateProvider<String>((ref) => '');

class Dashboard extends ConsumerStatefulWidget {
  const Dashboard({super.key});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends ConsumerState<Dashboard> {
  String currentTime = '';
  String currentDate = '';
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    currentDate = _getCurrentDate();
    currentTime = _getCurrentTime();
    _startTimer(); // Start the timer when the widget is created
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        currentTime = _getCurrentTime();
      });
    });
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    final hour = now.hour % 12;
    final minute = now.minute.toString().padLeft(2, '0');
    final second = now.second.toString().padLeft(2, '0');
    final suffix = now.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute:$second $suffix'; // Include seconds
  }

  String _getCurrentDate() {
    final now = DateTime.now();
    final formatter = DateFormat('MMMM dd, yyyy');
    return formatter.format(now); // Format date as "November 30, 2024"
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> tasks = ref.watch(tasksProvider);
    final String searchQuery = ref.watch(searchQueryProvider);

    // Filter the tasks based on the search query
    List<Map<String, dynamic>> filteredTasks = tasks.where((task) {
      return task['title'].toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      body: Column(
        children: [
          // Padding added to add margins on top and both sides of the image
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
            child: Container(
              height: 200, // You can adjust the height of the container
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20), // Rounded corners
                image: const DecorationImage(
                  image: AssetImage('assets/images/purple.jpg'),
                  fit: BoxFit.cover, // Ensure the image covers the whole area
                ),
              ),
              // Stack to overlay the current date and time over the image
              child: Stack(
                children: [
                  Positioned(
                    left: 20,
                    bottom: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currentDate,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          currentTime,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: TextField(
              onChanged: (query) {
                ref.read(searchQueryProvider.notifier).state = query;
              },
              decoration: InputDecoration(
                labelText: 'Search by Title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(color: Colors.purple, width: 1.0),
                ),
                prefixIcon: const Icon(Icons.search, color: Colors.purple),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Task List
          Expanded(
            child: filteredTasks.isEmpty
                ? const Center(child: Text('No tasks available.'))
                : ListView.builder(
                    itemCount: filteredTasks.length,
                    itemBuilder: (context, index) {
                      final task = filteredTasks[index];
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
                              ref
                                  .read(tasksProvider.notifier)
                                  .completeTask(task['id']);
                            },
                            onDelete: () {
                              ref.read(tasksProvider.notifier).deleteTask(task['id']);
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => AddTaskScreen(),
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
          } else {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const Dashboard(),
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
              Icons.description,
              task['description'] ?? 'No description available',
            ),
            const SizedBox(height: 4),
            _buildRowWithIcon(
              Icons.calendar_today,
              'Date: ${task['date']?.toLocal().toString().split(' ')[0] ?? 'N/A'}',
            ),
            _buildRowWithIcon(
              Icons.access_time,
              'Time: ${_formatTime(task['time'])}',
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

    final hour = time.hour % 12;
    final minute = time.minute.toString().padLeft(2, '0');
    final suffix = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $suffix';
  }
}
