// lib/tasks/task_model.dart
import 'package:flutter/material.dart';

/// --------------------
/// Task Status Enum
/// --------------------
enum TaskStatus { pending, inProgress, completed, overdue }

/// --------------------
/// Task Priority Enum
/// --------------------
enum TaskPriority { low, medium, high }

/// --------------------
/// Helper: Status label
/// --------------------
String getTaskStatusLabel(TaskStatus status) {
  switch (status) {
    case TaskStatus.pending:
      return "Pending";
    case TaskStatus.inProgress:
      return "In Progress";
    case TaskStatus.completed:
      return "Completed";
    case TaskStatus.overdue:
      return "Overdue";
  }
}

/// --------------------
/// Helper: Priority label
/// --------------------
String getTaskPriorityLabel(TaskPriority priority) {
  switch (priority) {
    case TaskPriority.low:
      return "Low";
    case TaskPriority.medium:
      return "Medium";
    case TaskPriority.high:
      return "High";
  }
}

/// --------------------
/// Task Model
/// --------------------
class Task {
  String id;
  String title;
  String description;
  String assignedTo; // Staff member name or ID
  TaskStatus status;
  TaskPriority priority;
  DateTime createdAt;
  DateTime dueDate;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.assignedTo,
    this.status = TaskStatus.pending,
    this.priority = TaskPriority.medium,
    DateTime? createdAt,
    required this.dueDate,
  }) : createdAt = createdAt ?? DateTime.now();
}