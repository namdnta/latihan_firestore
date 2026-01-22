import 'dart:developer' show log;
import 'package:latihan_firestore/utils/firestore.realtime.dart';

class UpdateService {
  /// Update todo berdasarkan ID
  Future<Map<String, dynamic>> updateTodo(
    String id, {
    String? taskName,
    String? dueDate,
    String? priority,
    String? category,
    String? description,
    bool? isDone,
  }) async {
    try {
      final Map<String, dynamic> updates = {
        if (taskName != null) 'taskName': taskName,
        if (dueDate != null) 'dueDate': dueDate,
        if (priority != null) 'priority': priority,
        if (category != null) 'category': category,
        if (description != null) 'description': description,
        if (isDone != null) 'isDone': isDone,
        'updatedAt': DateTime.now().toIso8601String(),
      };

      await DatabaseService.todoRef(id).update(updates);

      return {
        'success': true,
        'id': id,
        'message': 'Todo updated successfully',
      };
    } catch (e) {
      log('❌ UpdateService Error: $e');
      return {
        'success': false,
        'error': e.toString(),
        'message': 'Failed to update todo',
      };
    }
  }
}
