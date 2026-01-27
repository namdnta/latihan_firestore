import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latihan_firestore/Component/card.dart' as legacy_card;
import 'package:latihan_firestore/Component/colors.dart' as colors;
import 'package:latihan_firestore/Component/navbar.dart';
import 'package:latihan_firestore/Component/angled_header.dart';
import 'package:latihan_firestore/controller/todo_controller.dart';
import 'package:latihan_firestore/pages/form_page.dart';

class TodoListPage extends StatelessWidget {
  const TodoListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TodoController controller = Get.put(TodoController());

    return Scaffold(
      backgroundColor: colors.AppColors.background,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final todos = controller.todos.where((t) => t['isDone'] != true);

        final study = todos.where((t) => (t['category'] ?? '').toString().toLowerCase() == 'study');
        final work = todos.where((t) => (t['category'] ?? '').toString().toLowerCase() == 'work');

        List<Widget> section(String title, Iterable<Map<String, dynamic>> items) {
          if (items.isEmpty) return [];
          return [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 14)),
                ],
              ),
            ),
            ...items.map((todo) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: legacy_card.TodoCard(todo: todo),
                )),
          ];
        }

        return ListView(
          children: [
            const AngledHeader(title: 'To Do'),
            ...section('Study', study),
            ...section('Work', work),
          ],
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
