import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latihan_firestore/Component/buttons.dart';
import 'package:latihan_firestore/Component/angled_header.dart';
import 'package:latihan_firestore/Component/category_dropdown.dart';
import 'package:latihan_firestore/Component/priority_selector.dart'
    as chip_selector;
import 'package:latihan_firestore/Component/app_textfield.dart';
import 'package:latihan_firestore/Component/date_picker_field.dart';
import 'package:latihan_firestore/Component/colors.dart';
import 'package:latihan_firestore/controller/todo_controller.dart';
import 'package:latihan_firestore/utils/responsive.dart';

class TodoFormPage extends StatelessWidget {
  const TodoFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TodoController controller = Get.find<TodoController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: Responsive.pagePadding(context),
        child: Form(
          key: controller.createFormKey,
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
                        controller: controller.createTaskController,
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Please enter a task name'
                            : null,
                        hintText: '',
                        maxLines: 1,
                      ),
                      const SizedBox(height: 16),
                      Obx(
                        () => DatePickerField(
                          label: 'Due Date',
                          selectedDate: controller.createDueDate.value,
                          onDateSelected: controller.updateCreateDueDate,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Obx(
                        () => chip_selector.PrioritySelector(
                          selectedPriority: controller.createPriority.value,
                          onPriorityChanged: controller.updateCreatePriority,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Obx(
                        () => CategoryDropdown(
                          selectedCategory: controller.createCategory.value,
                          onChanged: controller.updateCreateCategory,
                        ),
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
                                    onPressed: controller.cancelCreate,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Obx(
                                    () => CustomButton(
                                      text: 'Add',
                                      icon: controller.isCreateLoading.value
                                          ? null
                                          : Icons.add,
                                      onPressed:
                                          controller.isCreateLoading.value
                                          ? null
                                          : controller.createTodoFromForm,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Obx(
                                () => CustomButton(
                                  text: 'Add',
                                  icon: controller.isCreateLoading.value
                                      ? null
                                      : Icons.add,
                                  onPressed: controller.isCreateLoading.value
                                      ? null
                                      : controller.createTodoFromForm,
                                ),
                              ),
                              const SizedBox(height: 12),
                              CustomButton(
                                text: 'Cancel',
                                isSecondary: true,
                                onPressed: controller.cancelCreate,
                              ),
                            ],
                          );
                        },
                      ),
                      Obx(
                        () => controller.isCreateLoading.value
                            ? const Padding(
                                padding: EdgeInsets.only(top: 20),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.green,
                                  ),
                                ),
                              )
                            : const SizedBox.shrink(),
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
