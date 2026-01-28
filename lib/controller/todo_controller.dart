// controllers/todo_controller.dart - FINAL CLEAN VERSION
import 'dart:developer' show log;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latihan_firestore/Component/colors.dart';
import 'package:latihan_firestore/services/history.service.dart';
import 'package:latihan_firestore/services/list_service.dart';
import 'package:latihan_firestore/services/update.service.dart';
import 'package:firebase_database/firebase_database.dart';

class TodoController extends GetxController {
  // Instance Service
  final ListService _listService = ListService();
  final UpdateService _updateService = UpdateService();
  final HistoryService _historyService = HistoryService();

  // User info (HANYA userId sebagai RxString)
  final RxString _currentUserId = 'unknown'.obs;

  // Observable list todos
  var todos = <Map<String, dynamic>>[].obs;

  // Loading state
  var isLoading = false.obs;

  // ==================== EDIT PAGE VARIABLES ====================
  final editFormKey = GlobalKey<FormState>();
  final editTitleController = TextEditingController();
  final editDescriptionController = TextEditingController();
  final Rx<String?> editSelectedPriority = Rx<String?>(null);
  final Rx<String?> editSelectedCategory = Rx<String?>(null);
  final Rx<DateTime?> editSelectedDate = Rx<DateTime?>(null);
  final RxBool isEditLoading = false.obs;
  final Rx<Map<String, dynamic>?> editOriginalTodo = Rx<Map<String, dynamic>?>(
    null,
  );

  // ==================== CREATE/FORM PAGE VARIABLES ====================
  final createFormKey = GlobalKey<FormState>();
  final createTaskController = TextEditingController();
  final Rx<DateTime?> createDueDate = Rx<DateTime?>(null);
  final RxString createPriority = 'medium'.obs;
  final Rx<String?> createCategory = Rx<String?>(null);
  final RxBool isCreateLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTodosRealtime();
    _initializeUserInfo();
  }

  @override
  void onClose() {
    editTitleController.dispose();
    editDescriptionController.dispose();
    createTaskController.dispose();
    super.onClose();
  }

  void _initializeUserInfo() {
    _currentUserId.value = 'user_${DateTime.now().millisecondsSinceEpoch}';
  }

  void setUserInfo({required String userId}) {
    _currentUserId.value = userId;
    update();
  }

  /// Fetch todos real-time
  void fetchTodosRealtime() {
    isLoading.value = true;

    _listService.streamTodos().listen(
      (List<Map<String, dynamic>> data) {
        todos.value = data;
        isLoading.value = false;
      },
      onError: (error) {
        log('❌ Error fetching todos: $error');
        isLoading.value = false;
      },
    );
  }

  // ==================== EDIT PAGE METHODS ====================

  /// Initialize edit fields with existing todo data
  void initializeEditFields(Map<String, dynamic> todo) {
    editOriginalTodo.value = todo;

    editTitleController.text = todo['taskName'] ?? '';
    editDescriptionController.text = todo['description'] ?? '';
    editSelectedPriority.value = todo['priority'];
    editSelectedCategory.value = todo['category'];

    final due = todo['dueDate'];
    if (due is String && due.isNotEmpty) {
      editSelectedDate.value = DateTime.tryParse(due);
    }
  }

  /// Update edit priority
  void updateEditPriority(String? priority) {
    editSelectedPriority.value = priority;
  }

  /// Update edit category
  void updateEditCategory(String? category) {
    editSelectedCategory.value = category;
  }

  /// Update edit date
  void updateEditDate(DateTime? date) {
    editSelectedDate.value = date;
  }

  /// Clear edit fields
  void clearEditFields() {
    editTitleController.clear();
    editDescriptionController.clear();
    editSelectedPriority.value = null;
    editSelectedCategory.value = null;
    editSelectedDate.value = null;
    editOriginalTodo.value = null;
  }

  /// Validate and update todo from edit page
  Future<void> updateTodoFromEditPage() async {
    if (!editFormKey.currentState!.validate()) return;

    if (editSelectedPriority.value == null) {
      Get.snackbar(
        'Validation Error',
        'Please select a priority',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.priorityHigh,
        colorText: Colors.white,
      );
      return;
    }

    if (editSelectedCategory.value == null) {
      Get.snackbar(
        'Validation Error',
        'Please select a category',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.priorityHigh,
        colorText: Colors.white,
      );
      return;
    }

    if (editOriginalTodo.value == null) {
      Get.snackbar(
        'Error',
        'Todo data not found',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.priorityHigh,
        colorText: Colors.white,
      );
      return;
    }

    isEditLoading.value = true;

    try {
      final id = editOriginalTodo.value!['id'] as String;

      await updateTodo(
        id,
        taskName: editTitleController.text.trim(),
        description: editDescriptionController.text.trim(),
        dueDate: editSelectedDate.value?.toIso8601String(),
        priority: editSelectedPriority.value!,
        category: editSelectedCategory.value!,
        isDone: editOriginalTodo.value!['isDone'] == true,
      );

      Get.back(result: true);
      Get.snackbar(
        'Success',
        'Task updated successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.completed,
        colorText: Colors.white,
      );

      clearEditFields();
    } catch (e) {
      log('❌ TodoController updateTodoFromEditPage Error: $e');
      Get.snackbar(
        'Error',
        'Error: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.priorityHigh,
        colorText: Colors.white,
      );
    } finally {
      isEditLoading.value = false;
    }
  }

  /// Cancel edit and go back
  void cancelEdit() {
    clearEditFields();
    Get.back();
  }

  // ==================== CREATE/FORM PAGE METHODS ====================

  void updateCreateDueDate(DateTime? date) {
    createDueDate.value = date;
  }

  void updateCreatePriority(String priority) {
    createPriority.value = priority;
  }

  void updateCreateCategory(String? category) {
    createCategory.value = category;
  }

  void clearCreateFields() {
    createTaskController.clear();
    createDueDate.value = null;
    createPriority.value = 'medium';
    createCategory.value = null;
  }

  Future<void> createTodoFromForm() async {
    if (!createFormKey.currentState!.validate()) return;

    isCreateLoading.value = true;

    try {
      final result = await _updateService.updateTodo(
        DateTime.now().millisecondsSinceEpoch.toString(),
        taskName: createTaskController.text.trim(),
        dueDate: createDueDate.value?.toIso8601String() ?? '',
        priority: createPriority.value,
        category: createCategory.value ?? 'study',
        isDone: false,
      );

      if (result['success'] == true) {
        Get.back(result: true);
        Get.snackbar(
          'Success',
          'Task created successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.completed,
          colorText: Colors.white,
        );
        clearCreateFields();
      } else {
        Get.snackbar(
          'Error',
          result['message'] ?? 'Failed to create task',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.priorityHigh,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      log('❌ TodoController createTodoFromForm Error: $e');
      Get.snackbar(
        'Error',
        'Error: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.priorityHigh,
        colorText: Colors.white,
      );
    } finally {
      isCreateLoading.value = false;
    }
  }

  void cancelCreate() {
    clearCreateFields();
    Get.back();
  }

  // ============================================================

  Future<void> updateTodo(
    String id, {
    String? taskName,
    String? dueDate,
    String? priority,
    String? category,
    String? description,
    bool? isDone,
  }) async {
    isLoading.value = true;

    try {
      final oldSnapshot = await FirebaseDatabase.instance
          .ref()
          .child('todos')
          .child(id)
          .once();

      if (!oldSnapshot.snapshot.exists) {
        log('❌ TodoController: Todo $id not found');
        isLoading.value = false;
        return;
      }

      final Map<String, dynamic> oldData = Map<String, dynamic>.from(
        oldSnapshot.snapshot.value as Map,
      );

      final bool wasDoneBefore = oldData['isDone'] == true;
      final bool isDoneNow = isDone ?? wasDoneBefore;

      final Map<String, dynamic> updates = {};
      if (taskName != null) updates['taskName'] = taskName;
      if (dueDate != null) updates['dueDate'] = dueDate;
      if (priority != null) updates['priority'] = priority;
      if (category != null) updates['category'] = category;
      if (description != null) updates['description'] = description;
      if (isDone != null) updates['isDone'] = isDone;
      updates['updatedAt'] = DateTime.now().toIso8601String();

      final result = await _updateService.updateTodo(
        id,
        taskName: taskName,
        dueDate: dueDate,
        priority: priority,
        category: category,
        description: description,
        isDone: isDone,
      );

      if (result['success'] == true) {
        final newData = {...oldData, ...updates};

        await _logHistoryBasedOnChange(
          id: id,
          oldData: oldData,
          newData: newData,
          wasDoneBefore: wasDoneBefore,
          isDoneNow: isDoneNow,
        );

        int index = todos.indexWhere((todo) => todo['id'] == id);
        if (index != -1) {
          todos[index] = newData;
          todos.refresh();
        }

        log('✅ TodoController: Todo updated + history logged');
      } else {
        log('❌ Update failed: ${result['message']}');
      }
    } catch (e) {
      log('❌ TodoController Error: $e');
    }

    isLoading.value = false;
  }

  Future<void> _logHistoryBasedOnChange({
    required String id,
    required Map<String, dynamic> oldData,
    required Map<String, dynamic> newData,
    required bool wasDoneBefore,
    required bool isDoneNow,
  }) async {
    if (!wasDoneBefore && isDoneNow) {
      await _historyService.logCompletion(
        todoId: id,
        todoData: newData,
        userId: _currentUserId.value,
      );
      log('🎯 Todo marked as COMPLETED - history logged');
    } else if (wasDoneBefore && !isDoneNow) {
      await _historyService.logReopen(
        todoId: id,
        todoData: newData,
        userId: _currentUserId.value,
      );
      log('↩️ Todo REOPENED - history logged');
    } else if (_hasNonIsDoneChanges(oldData, newData)) {
      await _historyService.logUpdate(
        todoId: id,
        oldData: oldData,
        newData: newData,
        userId: _currentUserId.value,
      );
      log('📝 Regular UPDATE - history logged');
    }
  }

  bool _hasNonIsDoneChanges(
    Map<String, dynamic> oldData,
    Map<String, dynamic> newData,
  ) {
    final keysToCheck = newData.keys.where((key) => key != 'isDone');
    for (final key in keysToCheck) {
      if (oldData[key] != newData[key]) {
        return true;
      }
    }
    return false;
  }

  Future<void> toggleTodoCompletion(String id) async {
    final todoIndex = todos.indexWhere((todo) => todo['id'] == id);
    if (todoIndex == -1) return;

    final currentTodo = todos[todoIndex];
    final bool currentIsDone = currentTodo['isDone'] == true;
    final bool newIsDone = !currentIsDone;

    await updateTodo(id, isDone: newIsDone);
  }

  String get currentUserId => _currentUserId.value;
}
