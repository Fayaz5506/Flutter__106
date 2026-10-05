import 'priority.dart';

class Task {
  final String id;
  final String title;
  final DateTime dueTime;
  final Priority priority;
  final bool isDone;
  final DateTime createdAt;

  Task({
    required this.id,
    required this.title,
    required this.dueTime,
    required this.priority,
    this.isDone = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Task copyWith({
    String? id,
    String? title,
    DateTime? dueTime,
    Priority? priority,
    bool? isDone,
    DateTime? createdAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      dueTime: dueTime ?? this.dueTime,
      priority: priority ?? this.priority,
      isDone: isDone ?? this.isDone,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'dueTime': dueTime.toIso8601String(),
      'priority': priority.name,
      'isDone': isDone,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as String,
      title: json['title'] as String,
      dueTime: DateTime.parse(json['dueTime'] as String),
      priority: Priority.fromString(json['priority'] as String),
      isDone: json['isDone'] as bool? ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }
}
