import 'dart:developer' show log;
import 'package:latihan_firestore/utils/firestore.realtime.dart';

class DeleteService {
  // DELETE TODO
  Future<Map<String, dynamic>> deleteTodo(String id) async {
    try {
      log('DeleteService: Deleting todo $id...');

      // 1. Check if exists
      final snapshot = await DatabaseService.todoRef(id).once();
      if (snapshot.snapshot.value == null) {
        return {
          'success': false,
          'error': 'Not found',
          'message': 'Todo with ID $id not found',
        };
      }

      // 2. Delete
      await DatabaseService.todoRef(id).remove();
      log('Todo $id deleted');

      return {
        'success': true,
        'id': id,
        'message': 'Todo deleted successfully',
      };
    } catch (e) {
      log('❌ DeleteService Error: $e');
      return {
        'success': false,
        'error': e.toString(),
        'message': 'Failed to delete todo',
      };
    }
  }

  // DELETE MULTIPLE TODOS
  Future<Map<String, dynamic>> deleteMultiple(List<String> ids) async {
    try {
      log('DeleteService: Deleting ${ids.length} todos...');

      int successCount = 0;
      List<String> failedIds = [];

      for (String id in ids) {
        final result = await deleteTodo(id);
        if (result['success'] == true) {
          successCount++;
        } else {
          failedIds.add(id);
        }
      }

      return {
        'success': failedIds.isEmpty,
        'successCount': successCount,
        'failedIds': failedIds,
        'message': 'Deleted $successCount todos, failed: ${failedIds.length}',
      };
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
        'message': 'Failed to delete todos',
      };
    }
  }
}
