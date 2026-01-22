// controllers/todo_controller.dart - FINAL CLEAN VERSION
import 'dart:developer' show log;
import 'package:get/get.dart';
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

  @override
  void onInit() {
    super.onInit();
    fetchTodosRealtime();
    _initializeUserInfo();
  }

  /// Initialize user info
  void _initializeUserInfo() {
    // Contoh: bisa ambil dari GetStorage
    // final box = GetStorage();
    // _currentUserId.value = box.read('userId') ?? 'unknown';

    // Untuk testing, set dummy userId
    _currentUserId.value = 'user_${DateTime.now().millisecondsSinceEpoch}';
  }

  /// Set user info manual (dipanggil dari auth)
  void setUserInfo({required String userId}) {
    // ⭐ TIDAK ADA userEmail
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

  /// Update todo dengan History Logging
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
      // 1. Get data lama sebelum update
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

      // 2. Check perubahan isDone
      final bool wasDoneBefore = oldData['isDone'] == true;
      final bool isDoneNow = isDone ?? wasDoneBefore;

      // 3. Prepare updates
      final Map<String, dynamic> updates = {};
      if (taskName != null) updates['taskName'] = taskName;
      if (dueDate != null) updates['dueDate'] = dueDate;
      if (priority != null) updates['priority'] = priority;
      if (category != null) updates['category'] = category;
      if (description != null) updates['description'] = description;
      if (isDone != null) updates['isDone'] = isDone;
      updates['updatedAt'] = DateTime.now().toIso8601String();

      // 4. Call service untuk update
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

        // 5. Log history berdasarkan jenis perubahan
        await _logHistoryBasedOnChange(
          id: id,
          oldData: oldData,
          newData: newData,
          wasDoneBefore: wasDoneBefore,
          isDoneNow: isDoneNow,
        );

        // 6. Update local list
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

  /// Helper: Log history berdasarkan jenis perubahan
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
    }

    else if (wasDoneBefore && !isDoneNow) {
      await _historyService.logReopen(
        todoId: id,
        todoData: newData,
        userId: _currentUserId.value,
      );
      log('↩️ Todo REOPENED - history logged');
    }
    // C. Log regular update untuk field lain (selain isDone)
    else if (_hasNonIsDoneChanges(oldData, newData)) {
      await _historyService.logUpdate(
        todoId: id,
        oldData: oldData,
        newData: newData,
        userId: _currentUserId.value,
      );
      log('📝 Regular UPDATE - history logged');
    }
  }

  /// Helper: Cek apakah ada perubahan selain isDone
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

  /// Toggle completion status (mark as done/undone)
  Future<void> toggleTodoCompletion(String id) async {
    final todoIndex = todos.indexWhere((todo) => todo['id'] == id);
    if (todoIndex == -1) return;

    final currentTodo = todos[todoIndex];
    final bool currentIsDone = currentTodo['isDone'] == true;
    final bool newIsDone = !currentIsDone;

    await updateTodo(id, isDone: newIsDone);
  }

  /// Getter untuk userId (jika diperlukan)
  String get currentUserId => _currentUserId.value;
}
