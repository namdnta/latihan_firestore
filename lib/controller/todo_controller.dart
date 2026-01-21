import 'package:get/get.dart';
import 'package:latihan_firestore/services/list_service.dart';
import 'package:latihan_firestore/services/update.service.dart';

class TodoController extends GetxController {
  // Instance Service
  final ListService _listService = ListService();
  final UpdateService _updateService = UpdateService();

  // Observable list todos
  var todos = <Map<String, dynamic>>[].obs;

  // Loading state
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTodosRealtime();
  }

  /// Fetch todos 
  void fetchTodosRealtime() {
    _listService.streamTodos().listen((List<Map<String, dynamic>> data) {
      todos.value = data;
    });
  }

  /// Update todo berdasarkan ID
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
      // optional: update lokal list langsung
      int index = todos.indexWhere((todo) => todo['id'] == id);
      if (index != -1) {
        todos[index] = {
          ...todos[index],
          ...{
            if (taskName != null) 'taskName': taskName,
            if (dueDate != null) 'dueDate': dueDate,
            if (priority != null) 'priority': priority,
            if (category != null) 'category': category,
            if (description != null) 'description': description,
            if (isDone != null) 'isDone': isDone,
            'updatedAt': DateTime.now().toIso8601String(),
          },
        };
        todos.refresh();
      }
    } else {
      print('❌ Update failed: ${result['message']}');
    }

    isLoading.value = false;
  }
}