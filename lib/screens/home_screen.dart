import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saasaki_assignment/models/Task.dart';
import 'package:saasaki_assignment/providers/authentication_provider.dart';
import 'package:saasaki_assignment/screens/add_task_screen.dart';
import 'package:saasaki_assignment/services/task_service.dart';
import 'package:saasaki_assignment/widgets/task_tile.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TaskService _taskService = TaskService();

  late Stream<List<TaskModel>> _tasksStream;

  @override
  void initState() {
    super.initState();
    _tasksStream = _taskService.getUserTasks();
  }

  @override
  Widget build(BuildContext context) {
    final _authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Manager'),
        actions: [
          IconButton(
              onPressed: () {
                _authProvider.logout(context);
              },
              icon: Icon(Icons.logout_rounded))
        ],
      ),
      body: StreamBuilder<List<TaskModel>>(
        stream: _tasksStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No tasks available'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              TaskModel task = snapshot.data![index];
              return TaskTile(task: task);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddTaskScreen,
        child: Icon(Icons.add),
      ),
    );
  }

  void _navigateToAddTaskScreen() {
    // Navigate to the screen where users can add tasks
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AddTaskScreen()));
  }
}
