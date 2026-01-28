import 'package:flutter/material.dart';
import 'package:latihan_firestore/Component/app_textfield.dart';
import 'package:latihan_firestore/Component/buttons.dart';
import 'package:latihan_firestore/Component/category_dropdown.dart';
import 'package:latihan_firestore/Component/colors.dart';
import 'package:latihan_firestore/Component/priority_selector.dart'
    as chip_selector;
import 'package:latihan_firestore/Component/section_header.dart';
import 'package:latihan_firestore/Component/date_picker_field.dart';
import 'package:latihan_firestore/services/update.service.dart';
import 'package:latihan_firestore/utils/responsive.dart';
import 'package:latihan_firestore/Component/navbar.dart';
import 'package:get/get.dart';
import 'package:latihan_firestore/pages/mainpage.dart';
import 'package:latihan_firestore/pages/form_page.dart';

class EditPage extends StatefulWidget {
  final Map<String, dynamic> todo;

  const EditPage({super.key, required this.todo});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  String? _selectedPriority;
  String? _selectedCategory;
  DateTime? _selectedDate;
  bool _isLoading = false;
  final _updateService = UpdateService();

  @override
  void initState() {
    super.initState();
    _initializeFields();
  }

  void _initializeFields() {
    _titleController.text = widget.todo['taskName'] ?? '';
    _descriptionController.text = widget.todo['description'] ?? '';
    _selectedPriority = widget.todo['priority'];
    _selectedCategory = widget.todo['category'];
    final due = widget.todo['dueDate'];
    if (due is String && due.isNotEmpty) {
      _selectedDate = DateTime.tryParse(due);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _updateTodo() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedPriority == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a priority')));
      return;
    }

    if (_selectedCategory == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a category')));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final id = widget.todo['id'] as String;

      final result = await _updateService.updateTodo(
        id,
        taskName: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        dueDate: _selectedDate?.toIso8601String(),
        priority: _selectedPriority!,
        category: _selectedCategory!,
        isDone: widget.todo['isDone'] == true,
      );

      if (!mounted) return;
      if (result['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Task updated successfully'),
            backgroundColor: AppColors.completed,
          ),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed: ${result['message']}'),
            backgroundColor: AppColors.priorityHigh,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: AppColors.priorityHigh,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          const SizedBox(height: 8),
          const SectionHeader(
            title: 'Edit',
            icon: Icons.edit,
            backgroundColor: AppColors.primaryGreen,
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: SingleChildScrollView(
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
                          const SizedBox(height: 8),
                          AppTextField(
                            label: 'Task Name',
                            hintText: 'Enter task name',
                            controller: _titleController,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter a task name';
                              }
                              return null;
                            },
                            maxLines: 1,
                          ),
                          const SizedBox(height: 20),
                          DatePickerField(
                            label: 'Due Date',
                            selectedDate: _selectedDate,
                            onDateSelected: (date) {
                              setState(() {
                                _selectedDate = date;
                              });
                            },
                          ),
                          const SizedBox(height: 20),
                          chip_selector.PrioritySelector(
                            selectedPriority: _selectedPriority,
                            onPriorityChanged: (priority) {
                              setState(() {
                                _selectedPriority = priority;
                              });
                            },
                          ),
                          const SizedBox(height: 20),
                          CategoryDropdown(
                            selectedCategory: _selectedCategory,
                            onChanged: (category) {
                              setState(() {
                                _selectedCategory = category;
                              });
                            },
                          ),
                          const SizedBox(height: 20),
                          AppTextField(
                            label: 'Description',
                            hintText: 'Add task description...',
                            controller: _descriptionController,
                            maxLines: 3,
                            validator: (value) {
                              return null;
                            },
                          ),
                          const SizedBox(height: 40),
                          LayoutBuilder(
                            builder: (context, constraints) {
                              final isWide = constraints.maxWidth >= 480;
                              final children = <Widget>[
                                Expanded(
                                  child: CustomButton(
                                    text: 'Cancel',
                                    onPressed: () => Navigator.pop(context),
                                    isSecondary: true,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: CustomButton(
                                    text: 'Save',
                                    onPressed: _isLoading ? null : _updateTodo,
                                    icon: _isLoading ? null : Icons.save,
                                  ),
                                ),
                              ];
                              if (isWide) {
                                return Row(children: children);
                              }
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  CustomButton(
                                    text: 'Save',
                                    onPressed: _isLoading ? null : _updateTodo,
                                    icon: _isLoading ? null : Icons.save,
                                  ),
                                  const SizedBox(height: 12),
                                  CustomButton(
                                    text: 'Cancel',
                                    onPressed: () => Navigator.pop(context),
                                    isSecondary: true,
                                  ),
                                ],
                              );
                            },
                          ),
                          if (_isLoading) ...[
                            const SizedBox(height: 20),
                            const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primaryGreen,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: FloatingNavBar(
        onToHistory: () => Get.toNamed('/history'),
        onToAdd: () => Get.to(() => const TodoFormPage()),
        onToMain: () => Get.offAll(() => const TodoListPage()),
      ),
    );
  }
}
