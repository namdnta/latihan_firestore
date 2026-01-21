import 'package:flutter/material.dart';
import 'package:latihan_firestore/Component/colors.dart';

class TodoCard extends StatelessWidget {
  final String title;
  final String? dueDate;
  final String priority;
  final bool isDone;
  final VoidCallback? onToggle;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const TodoCard({
    super.key,
    required this.title,
    this.dueDate,
    required this.priority,
    required this.isDone,
    this.onToggle,
    this.onEdit,
    this.onDelete,
  });

  Color _priorityColor() {
    switch (priority.toLowerCase()) {
      case 'high':
        return AppColors.priorityHigh;
      case 'medium':
        return AppColors.priorityMedium;
      default:
        return AppColors.priorityLow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.cardBackground,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: Checkbox(
          value: isDone,
          onChanged: (_) => onToggle?.call(),
          activeColor: AppColors.primaryGreen,
        ),
        title: Text(title, style: const TextStyle(color: AppColors.textPrimary)),
        subtitle: dueDate == null
            ? null
            : Text(
                dueDate!,
                style: const TextStyle(color: AppColors.textSecondary),
              ),
        trailing: Wrap(
          spacing: 6,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: _priorityColor(),
                shape: BoxShape.circle,
              ),
            ),
            IconButton(onPressed: onEdit, icon: const Icon(Icons.edit)),
            IconButton(onPressed: onDelete, icon: const Icon(Icons.delete)),
          ],
        ),
      ),
    );
  }
}
