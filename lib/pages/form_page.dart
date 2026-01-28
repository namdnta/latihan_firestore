import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latihan_firestore/Component/buttons.dart';
import 'package:latihan_firestore/Component/angled_header.dart';
import 'package:latihan_firestore/Component/category_dropdown.dart';
import 'package:latihan_firestore/Component/priority_selector.dart'
    as chip_selector;
import 'package:latihan_firestore/Component/app_textfield.dart';
import 'package:latihan_firestore/Component/date_picker_field.dart';
import 'package:latihan_firestore/controller/create.controller.dart';
import 'package:latihan_firestore/utils/responsive.dart';

class TodoFormPage extends StatefulWidget {
  const TodoFormPage({super.key});

  @override
  State<TodoFormPage> createState() => _TodoFormPageState();
}

class _TodoFormPageState extends State<TodoFormPage> {
  final _controller = CreateController();
  final _formKey = GlobalKey<FormState>();

  final _taskCtrl = TextEditingController();
  DateTime? _dueDate;
  String _priority = 'medium';
  String? _category;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: Responsive.pagePadding(context),
        child: Form(
          key: _formKey,
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: Responsive.contentMaxWidth(context),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AngledHeader(title: 'New Task'),
                  const SizedBox(height: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppTextField(
                        label: 'Task Name',
                        controller: _taskCtrl,
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Please enter a task name'
                            : null,
                        hintText: '',
                        maxLines: 1,
                      ),
                      const SizedBox(height: 16),
                      DatePickerField(
                        label: 'Due Date',
                        selectedDate: _dueDate,
                        onDateSelected: (d) => setState(() => _dueDate = d),
                      ),
                      const SizedBox(height: 16),
                      chip_selector.PrioritySelector(
                        selectedPriority: _priority,
                        onPriorityChanged: (p) => setState(() => _priority = p),
                      ),
                      const SizedBox(height: 16),
                      CategoryDropdown(
                        selectedCategory: _category,
                        onChanged: (c) => setState(() => _category = c),
                      ),
                      const SizedBox(height: 24),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final isWide = constraints.maxWidth >= 480;
                          if (isWide) {
                            return Row(
                              children: [
                                Expanded(
                                  child: CustomButton(
                                    text: 'Cancel',
                                    isSecondary: true,
                                    onPressed: () => Get.back(),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: CustomButton(
                                    text: 'Add',
                                    icon: Icons.add,
                                    onPressed: () async {
                                      if (!_formKey.currentState!.validate()) {
                                        return;
                                      }
                                      final result = await _controller
                                          .createTodo(
                                            taskName: _taskCtrl.text,
                                            dueDate:
                                                _dueDate?.toIso8601String() ??
                                                '',
                                            priority: _priority,
                                            category: _category ?? 'study',
                                          );
                                      if (result['success'] == true) {
                                        Get.back(result: true);
                                      } else {
                                        Get.snackbar(
                                          'Error',
                                          result['message'] ?? 'Failed',
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ],
                            );
                          }
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              CustomButton(
                                text: 'Add',
                                icon: Icons.add,
                                onPressed: () async {
                                  if (!_formKey.currentState!.validate()) {
                                    return;
                                  }
                                  final result = await _controller.createTodo(
                                    taskName: _taskCtrl.text,
                                    dueDate: _dueDate?.toIso8601String() ?? '',
                                    priority: _priority,
                                    category: _category ?? 'study',
                                  );
                                  if (result['success'] == true) {
                                    Get.back(result: true);
                                  } else {
                                    Get.snackbar(
                                      'Error',
                                      result['message'] ?? 'Failed',
                                    );
                                  }
                                },
                              ),
                              const SizedBox(height: 12),
                              CustomButton(
                                text: 'Cancel',
                                isSecondary: true,
                                onPressed: () => Get.back(),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
