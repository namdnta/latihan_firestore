import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latihan_firestore/Component/colors.dart';
import 'package:latihan_firestore/Component/navbar.dart';
import 'package:latihan_firestore/Component/card.dart' as legacy_card;
import 'package:latihan_firestore/controller/todo_controller.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TodoController controller = Get.put(TodoController());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Finished'),
        backgroundColor: AppColors.primaryGreen,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final completed = controller.todos.where((t) => t['isDone'] == true);
        if (completed.isEmpty) {
          return const Center(child: Text('No finished tasks yet'));
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: completed
              .map((todo) => legacy_card.TodoCard(todo: todo))
              .toList(),
        );
      }),
      bottomNavigationBar: FloatingNavBar(
        onToHistory: () {},
        onToAdd: () => Get.toNamed('/add'),
        onToMain: () => Get.offAllNamed('/'),
      ),
    );
  }
}