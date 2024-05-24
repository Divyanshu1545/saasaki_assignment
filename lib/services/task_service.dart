import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:saasaki_assignment/models/Task.dart';
import 'dart:developer' as devTools;

class TaskService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addTask(TaskModel task) async {
    String userId = _auth.currentUser!.uid;
    DocumentReference taskRef = _firestore.collection('tasks').doc(userId).collection('userTasks').doc();
    task.id = taskRef.id; // Set the auto-generated ID
    await taskRef.set(task.toMap());
  }

  Future<void> updateTask(TaskModel task) async {
    String userId = _auth.currentUser!.uid;
    await _firestore.collection('tasks').doc(userId).collection('userTasks').doc(task.id).update(task.toMap());
  }

  Future<void> deleteTask(String taskId) async {
    String userId = _auth.currentUser!.uid;
    await _firestore.collection('tasks').doc(userId).collection('userTasks').doc(taskId).delete();
  }

  Stream<List<TaskModel>> getUserTasks() {
    String userId = _auth.currentUser!.uid;
    return _firestore.collection('tasks').doc(userId).collection('userTasks').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => TaskModel.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
    });
  }
}