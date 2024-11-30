import 'package:bajo_flutterapp/tasks_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dashboard.dart'; // Import the Dashboard
import 'history_screen.dart'; // Import the History Screen

class AddTaskScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic>? task;

  const AddTaskScreen({super.key, this.task});

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends ConsumerState<AddTaskScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String _selectedPriority = 'Low';
  int _selectedIndex = 0; // Variable to keep track of selected bottom nav index

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _titleController.text = widget.task!['title'] ?? '';
      _descriptionController.text = widget.task!['description'] ?? '';
      _selectedDate = widget.task!['date'];
      _selectedTime = widget.task!['time'];
      _selectedPriority = widget.task!['priority'] ?? 'Low';
    }
  }

  void _saveTask(BuildContext context) {
    final title = _titleController.text;
    final description = _descriptionController.text;

    if (title.isEmpty ||
        description.isEmpty ||
        _selectedDate == null ||
        _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all fields')),
      );
      return;
    }

    final combinedDateTime = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );

    final newTask = {
      'title': title,
      'description': description,
      'date': _selectedDate,
      'time': _selectedTime,
      'deadline': combinedDateTime,
      'priority': _selectedPriority,
    };

    if (widget.task != null) {
      ref.read(tasksProvider.notifier).updateTask(widget.task!['id'], newTask);
    } else {
      ref.read(tasksProvider.notifier).addTask(newTask);
    }

    Navigator.pop(context);
  }

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pickTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null) setState(() => _selectedTime = picked);
  }

  // Method to handle BottomNavigationBar item taps
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (_selectedIndex == 0) {
      // Navigate to Home (Dashboard)
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Dashboard()),
      );
    } else if (_selectedIndex == 1) {
      // Navigate to History
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HistoryScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Container for "Create New Task" label with icon
              // Centered "Create New Task" label without icon
const Center(
  child: Text(
    'Create New Task',
    style: TextStyle(
      fontSize: 25,
      fontWeight: FontWeight.bold,
    ),
  ),
),

              const SizedBox(height: 20.0),

              // Container for Title and Description
              Container(
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                constraints: const BoxConstraints(
                  minHeight: 200,
                  maxWidth: 600,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Title',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16.0),
                    TextField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),
                          borderSide: BorderSide(
                              color: Colors.grey.shade300, width: 0.5),
                        ),
                        hintText: 'Enter task title',
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    const Text('Description',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16.0),
                    TextField(
                      controller: _descriptionController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),
                          borderSide: BorderSide(
                              color: Colors.grey.shade300, width: 0.5),
                        ),
                        hintText: 'Enter task description',
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20.0),

              // Container for Deadline (Date and Time)
              Container(
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                constraints: const BoxConstraints(
                  minHeight: 100,
                  maxWidth: 600,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Deadline',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16.0),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _pickDate(context),
                            icon: const Icon(Icons.calendar_today),
                            label: Text(_selectedDate == null
                                ? 'Pick Date'
                                : '${_selectedDate!.toLocal().toString().split(' ')[0]}'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 17),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _pickTime(context),
                            icon: const Icon(Icons.access_time),
                            label: Text(_selectedTime == null
                                ? 'Pick Time'
                                : _selectedTime!.format(context)),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 17),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20.0),

              // Container for Priority (No label "Priority")
              Container(
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                constraints: const BoxConstraints(
                  minHeight: 10,
                  maxWidth: 600,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Priority', // Adding the "Priority" label
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                        height:
                            16.0), // Adding some spacing between label and buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildPriorityButton('High', const Color(0xFFE5D0FF),
                            const Color.fromARGB(255, 141, 103, 223)),
                        _buildPriorityButton('Medium', const Color(0xFFFFD27F),
                            const Color(0xFFFFB732)),
                        _buildPriorityButton('Low', const Color(0xFFACE1AF),
                            const Color(0xFF6F9B67)),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 35.0),

              // Save Task Button
              ElevatedButton(
                onPressed: () => _saveTask(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(
                      255, 190, 117, 190), // Button background color
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  minimumSize: const Size(185, 50),
                ),
                child: Text(
                  widget.task != null ? 'Update Task' : 'Save Task',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white, // Set the text color to white
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
        ],
      ),
    );
  }

  Widget _buildPriorityButton(
      String priority, Color defaultColor, Color selectedColor) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPriority = priority;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        decoration: BoxDecoration(
          color: _selectedPriority == priority
              ? selectedColor
              : defaultColor, // Change color based on selection
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Text(
          priority,
          style: TextStyle(
            fontSize: 14.0,
            color: _selectedPriority == priority
                ? Colors.white
                : Colors.black, // Text color
          ),
        ),
      ),
    );
  }
}
