import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latihan_firestore/Component/card.dart' as legacy_card;
import 'package:latihan_firestore/Component/colors.dart' as colors;
import 'package:latihan_firestore/Component/navbar.dart';
import 'package:latihan_firestore/Component/angled_header.dart';
import 'package:latihan_firestore/controller/todo_controller.dart';
import 'package:latihan_firestore/pages/form_page.dart';
import 'package:latihan_firestore/utils/responsive.dart';

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

        final study = todos.where(
          (t) => (t['category'] ?? '').toString().toLowerCase() == 'study',
        );
        final work = todos.where(
          (t) => (t['category'] ?? '').toString().toLowerCase() == 'work',
        );

        List<Widget> section(
          String title,
          Iterable<Map<String, dynamic>> items,
        ) {
          if (items.isEmpty) return [];
          final list = items.toList();
          final crossAxisCount = Responsive.value(
            context: context,
            mobile: 1,
            tablet: 2,
            desktop: 3,
          );
          return [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 16,
                mainAxisSpacing: 12,
                childAspectRatio: 3.5,
              ),
              itemCount: list.length,
              itemBuilder: (context, index) {
                final todo = list[index];
                return legacy_card.TodoCard(todo: todo);
              },
            ),
          ];
        }

        return ListView(
          padding: Responsive.pagePadding(context),
          children: [
            const AngledHeader(title: 'To Do'),
            Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: Responsive.contentMaxWidth(context),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ...section('Study', study),
                    ...section('Work', work),
                  ],
                ),
              ),
            ),
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
