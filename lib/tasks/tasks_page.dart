// lib/tasks/tasks_page.dart
import 'package:flutter/material.dart';
import 'task_model.dart';


class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  // Sample tasks for demonstration
  final List<Task> tasks = [
    Task(
      id: '1',
      title: 'Daily Handover',
      description: 'Complete the daily handover report.',
      assignedTo: 'Nurse Amy',
      status: TaskStatus.pending,
      priority: TaskPriority.high,
      dueDate: DateTime.now().add(const Duration(days: 1)),
    ),
    Task(
      id: '2',
      title: 'Meal Preparation',
      description: 'Prepare meals for children.',
      assignedTo: 'Cook Sam',
      status: TaskStatus.inProgress,
      priority: TaskPriority.medium,
      dueDate: DateTime.now().add(const Duration(hours: 5)),
    ),
    Task(
      id: '3',
      title: 'Attendance Check',
      description: 'Check attendance for all staff members.',
      assignedTo: 'Coordinator Ben',
      status: TaskStatus.completed,
      priority: TaskPriority.low,
      dueDate: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tasks',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              // ListView handles scrolling automatically
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 28,
                            backgroundColor: _getPriorityColor(task.priority),
                            child: Text(
                              task.title[0],
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 20),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  task.title,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                const SizedBox(height: 4),
                                Text(task.description),
                                const SizedBox(height: 4),
                                Text('Assigned to: ${task.assignedTo}'),
                                const SizedBox(height: 2),
                                Text(
                                    'Due: ${task.dueDate.toLocal().toString().split(' ')[0]}'),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(task.status),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  getTaskStatusLabel(task.status),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(height: 6),
                              IconButton(
                                icon: const Icon(Icons.check_circle,
                                    color: Colors.green),
                                onPressed: () {
                                  setState(() {
                                    task.status = TaskStatus.completed;
                                  });
                                },
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Map priority to color
  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return Colors.red;
      case TaskPriority.medium:
        return Colors.orange;
      case TaskPriority.low:
        return Colors.green;
    }
  }

  // Map status to color
  Color _getStatusColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending:
        return Colors.orange;
      case TaskStatus.inProgress:
        return Colors.blue;
      case TaskStatus.completed:
        return Colors.green;
      case TaskStatus.overdue:
        return Colors.red;
    }
  }
}