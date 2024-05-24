import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';

import 'package:saasaki_assignment/models/Task.dart';
import 'package:saasaki_assignment/services/task_service.dart';

class AddTaskScreen extends StatefulWidget {
  final TaskModel? task;

  const AddTaskScreen({super.key, this.task});

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  DateTime _selectedDateTime = DateTime.now();
  final TaskService _taskService = TaskService();
  bool _isEditMode = false;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _isEditMode = true;
      _titleController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description;
      _selectedDateTime = widget.task!.deadline;
      _durationController.text =
          widget.task!.expectedDuration.inHours.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? 'Edit Task' : 'Add Task'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: Text(
                      'Deadline: ${_selectedDateTime.day}/${_selectedDateTime.month}/${_selectedDateTime.year}, ${_selectedDateTime.hour}:${_selectedDateTime.minute}'),
                ),
                TextButton(
                  onPressed: _selectDateTime,
                  child: Text('Select Date & Time'),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _durationController,
              decoration:
                  InputDecoration(labelText: 'Expected Duration (hours)'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: _isEditMode ? _updateTask : _addTask,
              child: Text(_isEditMode ? 'Update Task' : 'Add Task'),
            ),
          ],
        ),
      ),
    );
  }

  void _selectDateTime() {
    DatePicker.showDateTimePicker(
      context,
      showTitleActions: true,
      onConfirm: (date) {
        setState(() {
          _selectedDateTime = date;
        });
      },
      currentTime: _selectedDateTime,
      locale: LocaleType.en,
    );
  }

  void _addTask() {
    String title = _titleController.text.trim();
    String description = _descriptionController.text.trim();
    DateTime deadline = _selectedDateTime;
    int durationInHours = int.tryParse(_durationController.text.trim()) ?? 1;
    Duration expectedDuration = Duration(hours: durationInHours);

    TaskModel newTask = TaskModel(
      id: '', // Firestore will auto-generate the ID
      title: title,
      description: description,
      deadline: deadline,
      expectedDuration: expectedDuration,
    );

    _taskService.addTask(newTask).then((_) {
      Navigator.of(context).pop();
    }).catchError((error) {
      // Handle error if task adding fails
      print('Error adding task: $error');
    });
  }

  void _updateTask() {
    String title = _titleController.text.trim();
    String description = _descriptionController.text.trim();
    DateTime deadline = _selectedDateTime;
    int durationInHours = int.tryParse(_durationController.text.trim()) ?? 1;
    Duration expectedDuration = Duration(hours: durationInHours);

    TaskModel updatedTask = TaskModel(
      id: widget.task!.id, // Keep the same ID
      title: title,
      description: description,
      deadline: deadline,
      expectedDuration: expectedDuration,
      isCompleted: widget.task!.isCompleted,
    );

    _taskService.updateTask(updatedTask).then((_) {
      Navigator.of(context).pop();
    }).catchError((error) {
      // Handle error if task updating fails
      print('Error updating task: $error');
    });
  }
}
