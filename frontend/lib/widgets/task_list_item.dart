import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/task_model.dart';
import '../providers/task_provider.dart';
import '../utils/date_formatter.dart';
import '../screens/edit_task_screen.dart';

class TaskListItem extends StatelessWidget {
  final Task task;
  const TaskListItem({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<TaskProvider>();
    return Dismissible(
      key: ValueKey(task.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) async {
        await provider.deleteTask(task.id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Task deleted')),
        );
      },
      child: Card(
        child: ListTile(
          leading: Checkbox(
            value: task.isCompleted,
            onChanged: (_) => provider.toggleComplete(task.id),
          ),
          title: Text(
            task.title,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              decoration: task.isCompleted ? TextDecoration.lineThrough : null,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: _buildSubtitle(task),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => EditTaskScreen(task: task),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget? _buildSubtitle(Task task) {
    final parts = <String>[];
    if (task.dueDate != null) {
      final due = task.dueDate!;
      if (DateFormatter.isOverdue(due) && !task.isCompleted) {
        parts.add('Overdue • ${DateFormatter.formatRelative(due)}');
      } else {
        parts.add('Due ${DateFormatter.formatRelative(due)}');
      }
    }

    // Always show session expiration info
    var expiration = task.expirationStatus;
    if (task.minutesUntilExpiration == 0) {
      expiration = '$expiration (server will remove)';
    }
    parts.add(expiration);

    if (parts.isEmpty) return null;
    return Text(parts.join(' · '));
  }
}
