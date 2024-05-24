import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:saasaki_assignment/models/Task.dart';
import 'package:saasaki_assignment/screens/add_task_screen.dart';
import 'package:saasaki_assignment/services/task_service.dart';

class TaskTile extends StatefulWidget {
  final TaskModel task;

  TaskTile({
    required this.task,
    super.key,
  });

  @override
  State<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  final TaskService taskService = TaskService();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            SlidableAction(
              borderRadius: BorderRadius.circular(15),
              onPressed: (context) async {
                await taskService.deleteTask(widget.task.id);
                setState(() {});
              },
              icon: Icons.delete,
              backgroundColor: Colors.red.shade500,
            )
          ],
        ),
        startActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            SlidableAction(
              borderRadius: BorderRadius.circular(15),
              onPressed: (context) async {
                widget.task.isCompleted = !widget.task.isCompleted;
                await taskService.updateTask(widget.task);
                setState(() {});
              },
              icon: Icons.done,
              backgroundColor: Colors.green.shade500,
            ),
          ],
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddTaskScreen(task: widget.task),
              ),
            );
          },
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 10,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: widget.task.isCompleted
                    ? Colors.green.shade300
                    : Colors.purple.shade200,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.task.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      decoration: widget.task.isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    widget.task.description,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      decoration: widget.task.isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Deadline: ${widget.task.deadline.toLocal().toString().split(' ')[0]} ${widget.task.deadline.hour}:${widget.task.deadline.minute}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                      decoration: widget.task.isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
