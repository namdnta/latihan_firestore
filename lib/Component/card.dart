import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latihan_firestore/Component/colors.dart';
import 'package:latihan_firestore/controller/delete.controller.dart';
import 'package:latihan_firestore/controller/todo_controller.dart';


class TodoCard extends StatelessWidget {
  final Map<String, dynamic> todo;

  const TodoCard({super.key, required this.todo});

  @override
  Widget build(BuildContext context) {
    final TodoController todoController = Get.find();
    final DeleteController deleteController = Get.put(DeleteController());

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
            onChanged: (_) =>
                todoController.toggleTodoCompletion(todo['id']),
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
                  '${todo['dueDate']} • ${todo['priority']}',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: AppColors.urgent),
            onPressed: () async {
              final confirm = await Get.dialog<bool>(
                AlertDialog(
                  title: const Text('Hold Up!'),
                  content:
                      Text('Delete "${todo['taskName']}" ?'),
                  actions: [
                    TextButton(
                        onPressed: () => Get.back(result: false),
                        child: const Text('Cancel')),
                    TextButton(
                        onPressed: () => Get.back(result: true),
                        child: const Text('Delete')),
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
