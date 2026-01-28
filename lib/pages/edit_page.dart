import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latihan_firestore/Component/app_textfield.dart';
import 'package:latihan_firestore/Component/buttons.dart';
import 'package:latihan_firestore/Component/category_dropdown.dart';
import 'package:latihan_firestore/Component/colors.dart';
import 'package:latihan_firestore/Component/priority_selector.dart'
    as chip_selector;
import 'package:latihan_firestore/Component/section_header.dart';
import 'package:latihan_firestore/Component/date_picker_field.dart';
import 'package:latihan_firestore/controller/todo_controller.dart';

class EditPage extends StatelessWidget {
  final Map<String, dynamic> todo;

  const EditPage({super.key, required this.todo});

  @override
  Widget build(BuildContext context) {
    // Get existing TodoController instance
    final TodoController controller = Get.find<TodoController>();

    // Initialize fields with todo data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.initializeEditFields(todo);
    });

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
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: controller.editFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      AppTextField(
                        label: 'Task Name',
                        hintText: 'Enter task name',
                        controller: controller.editTitleController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter a task name';
                          }
                          return null;
                        },
                        maxLines: 1,
                      ),
                      const SizedBox(height: 20),
                      Obx(
                        () => DatePickerField(
                          label: 'Due Date',
                          selectedDate: controller.editSelectedDate.value,
                          onDateSelected: controller.updateEditDate,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Obx(
                        () => chip_selector.PrioritySelector(
                          selectedPriority:
                              controller.editSelectedPriority.value,
                          onPriorityChanged: controller.updateEditPriority,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Obx(
                        () => CategoryDropdown(
                          selectedCategory:
                              controller.editSelectedCategory.value,
                          onChanged: controller.updateEditCategory,
                        ),
                      ),
                      const SizedBox(height: 20),
                      AppTextField(
                        label: 'Description',
                        hintText: 'Add task description...',
                        controller: controller.editDescriptionController,
                        maxLines: 3,
                        validator: (value) {
                          return null;
                        },
                      ),
                      const SizedBox(height: 40),
                      Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              text: 'Cancel',
                              onPressed: controller.cancelEdit,
                              isSecondary: true,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Obx(
                              () => CustomButton(
                                text: 'Save',
                                onPressed: controller.isEditLoading.value
                                    ? null
                                    : controller.updateTodoFromEditPage,
                                icon: controller.isEditLoading.value
                                    ? null
                                    : Icons.save,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Obx(
                        () => controller.isEditLoading.value
                            ? Column(
                                children: const [
                                  SizedBox(height: 20),
                                  Center(
                                    child: CircularProgressIndicator(
                                      color: AppColors.primaryGreen,
                                    ),
                                  ),
                                ],
                              )
                            : const SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: null,
    );
  }
}
