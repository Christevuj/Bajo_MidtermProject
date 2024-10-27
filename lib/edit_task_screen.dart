import 'package:bajo_flutterapp/tasks_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditTaskScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> task;

  const EditTaskScreen({super.key, required this.task});

  @override
  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends ConsumerState<EditTaskScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String _selectedPriority = 'Low';

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.task['title'] ?? '';
    _descriptionController.text = widget.task['description'] ?? '';
    _selectedDate = widget.task['date'];
    _selectedTime = widget.task['time'];
    _selectedPriority = widget.task['priority'] ?? 'Low';
  }

  void _updateTask(BuildContext context) {
    final title = _titleController.text;
    final description = _descriptionController.text;

    if (title.isEmpty || description.isEmpty || _selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all fields')),
      );
      return;
    }

    final updatedTask = {
      'title': title,
      'description': description,
      'date': _selectedDate,
      'time': _selectedTime,
      'deadline': DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      ),
      'priority': _selectedPriority,
    };

    ref.read(tasksProvider.notifier).updateTask(widget.task['id'], updatedTask);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF7E60BF), 
                Color(0xFFE5D0FF), 
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text(
          'Edit Task',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
                  minHeight: 400,
                  maxWidth: 600,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16.0),
                    const Text('Title', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16.0),
                    TextField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),
                          borderSide: BorderSide(color: Colors.grey.shade300, width: 0.5),
                        ),
                        hintText: 'Enter task title',
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    const Text('Description', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16.0),
                    TextField(
                      controller: _descriptionController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),
                          borderSide: BorderSide(color: Colors.grey.shade300, width: 0.5),
                        ),
                        hintText: 'Enter task description',
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    const Text('Deadline', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    const Text('Priority', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildPriorityButton('High', const Color(0xFFE5D0FF), const Color(0xFF7E60BF)),
                        _buildPriorityButton('Medium', const Color(0xFFFFD27F), const Color(0xFFFFB732)),
                        _buildPriorityButton('Low', const Color(0xFFACE1AF), const Color(0xFF6F9B67)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 35.0),
              ElevatedButton(
                onPressed: () => _updateTask(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 190, 117, 190),
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  minimumSize: const Size(185, 60),
                ),
                child: const Text(
                  'Update Task',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityButton(String priority, Color bgColor, Color borderColor) {
    return ElevatedButton(
      onPressed: () => setState(() => _selectedPriority = priority),
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        side: BorderSide(
          color: _selectedPriority == priority ? borderColor : Colors.transparent,
          width: _selectedPriority == priority ? 1.5 : 0.5,
        ),
      ),
      child: Text(
        priority,
        style: TextStyle(
          color: _selectedPriority == priority ? borderColor : Colors.black,
        ),
      ),
    );
  }
}
