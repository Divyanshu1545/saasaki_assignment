class TaskModel {
  String id;
  String title;
  String description;
  DateTime deadline;
  Duration expectedDuration;
  bool isCompleted;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.deadline,
    required this.expectedDuration,
    this.isCompleted = false,
  });
   Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'deadline': deadline.toIso8601String(),
      'expectedDuration': expectedDuration.inMinutes, // Store duration in minutes
      'isCompleted': isCompleted,
    };
  }

  // Converts Map to TaskModel
  factory TaskModel.fromMap(Map<String, dynamic> map, String id) {
    return TaskModel(
      id: id,
      title: map['title'],
      description: map['description'],
      deadline: DateTime.parse(map['deadline']),
      expectedDuration: Duration(minutes: map['expectedDuration']),
      isCompleted: map['isCompleted'] ?? false,
    );
  }
}
