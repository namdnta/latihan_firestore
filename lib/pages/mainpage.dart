import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latihan_firestore/Component/card.dart' as legacy_card;
import 'package:latihan_firestore/Component/colors.dart';
import 'package:latihan_firestore/Component/navbar.dart';
import 'package:latihan_firestore/controller/todo_controller.dart';
import 'package:latihan_firestore/pages/form_page.dart';

class TodoListPage extends StatelessWidget {
  const TodoListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TodoController controller = Get.put(TodoController());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('To Do'),
        backgroundColor: AppColors.primaryGreen,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final todos = controller.todos.where((t) => t['isDone'] != true);

        return ListView(
          padding: const EdgeInsets.all(16),
          children: todos
              .map((todo) => legacy_card.TodoCard(todo: todo))
              .toList(),
        );
      }),
      bottomNavigationBar: FloatingNavBar(
        onToHistory: () => Get.toNamed('/history'),
        onToAdd: () => Get.to(() => const TodoFormPage()),
        onToMain: () {},
      ),
    );
  }
}
