import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latihan_firestore/Component/colors.dart';
import 'package:latihan_firestore/controller/delete.controller.dart';
import 'package:latihan_firestore/controller/todo_controller.dart';
import 'package:latihan_firestore/pages/edit_page.dart';

class TodoCard extends StatelessWidget {
  final Map<String, dynamic> todo;

  const TodoCard({super.key, required this.todo});

  @override
  Widget build(BuildContext context) {
    final TodoController todoController = Get.find();
    final DeleteController deleteController = Get.put(DeleteController());

    String humanizeDate(String? iso) {
      if (iso == null || iso.isEmpty) return 'No due date';
      final parsed = DateTime.tryParse(iso);
      if (parsed == null) return iso;
      final now = DateTime.now();
      final local = parsed.toLocal();
      final dateOnly = DateTime(local.year, local.month, local.day);
      final today = DateTime(now.year, now.month, now.day);
      final diffDays = dateOnly.difference(today).inDays;

      if (diffDays == 0) return 'Today';
      if (diffDays == 1) return 'Tomorrow';
      if (diffDays == -1) return 'Yesterday';
      if (diffDays > 1 && diffDays <= 7) return 'In $diffDays days';
      if (diffDays < -1 && diffDays >= -7) return '${-diffDays} days ago';

      const months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      return '${dateOnly.day} ${months[dateOnly.month - 1]} ${dateOnly.year}';
    }

    String formatPriority(dynamic value) {
      final s = (value ?? '').toString();
      if (s.isEmpty) return '';
      return s[0].toUpperCase() + s.substring(1).toLowerCase();
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Checkbox(
            value: todo['isDone'] == true,
            activeColor: AppColors.primaryGreen,
            onChanged: (_) => todoController.toggleTodoCompletion(todo['id']),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  todo['taskName'],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    decoration: todo['isDone'] == true
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${humanizeDate(todo['dueDate'])} • ${formatPriority(todo['priority'])}',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit, color: AppColors.textPrimary),
            onPressed: () async {
              final result = await Get.to<bool>(() => EditPage(todo: todo));
              if (result == true) {
                Get.snackbar('Updated', 'Task updated successfully');
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: AppColors.urgent),
            onPressed: () async {
              final confirm = await Get.dialog<bool>(
                AlertDialog(
                  title: const Text('Hold Up!'),
                  content: Text('Delete "${todo['taskName']}" ?'),
                  actions: [
                    TextButton(
                      onPressed: () => Get.back(result: false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Get.back(result: true),
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                await deleteController.deleteTodo(todo['id']);
              }
            },
          ),
        ],
      ),
    );
  }
}
