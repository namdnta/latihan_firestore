// controllers/delete_controller.dart - FINAL VERSION
import 'dart:developer' show log;
import 'package:latihan_firestore/services/delete.service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:latihan_firestore/services/history.service.dart';

class DeleteController {
  final DeleteService _deleteService = DeleteService();
  final HistoryService _historyService = HistoryService();

  Future<Map<String, dynamic>> deleteTodo(String id) async {
    log('🎛️ DeleteController: Processing delete request for $id');

    try {
      // 1. Get data sebelum dihapus (untuk history)
      final snapshot = await FirebaseDatabase.instance
          .ref()
          .child('todos')
          .child(id)
          .once();

      if (!snapshot.snapshot.exists) {
        return {
          'success': false,
          'error': 'Not Found',
          'message': 'Todo with ID $id not found',
        };
      }

      final Map<String, dynamic> deletedData = Map<String, dynamic>.from(
        snapshot.snapshot.value as Map,
      );

      // 2. Validation
      if (id.isEmpty || id.length != 5) {
        return {
          'success': false,
          'error': 'Validation',
          'message': 'Todo ID must be 5 characters',
        };
      }

      // 3. Call service
      final result = await _deleteService.deleteTodo(id);

      // 4. Log history jika berhasil
      if (result['success'] == true) {
        await _historyService.logDelete(
          todoId: id,
          deletedData: deletedData,
          userId: _getCurrentUserId(),
          reason: 'User deleted from app',
        );

        log('✅ DeleteController: Todo $id deleted + history logged');
      } else {
        log(
          '❌ DeleteController: Failed: ${result['error'] ?? "Unknown error"}',
        ); // ⭐ FIX NULL
      }

      return result;
    } catch (e) {
      log('❌ DeleteController Error: $e');
      return {
        'success': false,
        'error': 'Exception',
        'message': 'Error deleting todo: $e',
      };
    }
  }

  Future<Map<String, dynamic>> deleteMultipleTodos(List<String> ids) async {
    log('🎛️ DeleteController: Processing delete for ${ids.length} todos');

    // Validation
    if (ids.isEmpty) {
      return {
        'success': false,
        'error': 'Validation',
        'message': 'No IDs provided',
      };
    }

    // Filter valid IDs
    final validIds = ids
        .where((id) => id.isNotEmpty && id.length == 5)
        .toList();

    if (validIds.isEmpty) {
      return {
        'success': false,
        'error': 'Validation',
        'message': 'No valid IDs provided',
      };
    }

    // Get all data sebelum dihapus untuk history
    final List<Map<String, dynamic>> todosToDelete = [];

    for (final id in validIds) {
      final snapshot = await FirebaseDatabase.instance
          .ref()
          .child('todos')
          .child(id)
          .once();

      if (snapshot.snapshot.exists) {
        final todoData = Map<String, dynamic>.from(
          snapshot.snapshot.value as Map,
        );
        todosToDelete.add({'id': id, 'data': todoData});
      }
    }

    // Call service
    final result = await _deleteService.deleteMultiple(validIds);

    // Log history untuk yang berhasil dihapus
    if (result['success'] == true) {
      final userId = _getCurrentUserId();

      for (final todo in todosToDelete) {
        await _historyService.logDelete(
          todoId: todo['id'],
          deletedData: todo['data'],
          userId: userId,
          reason: 'Batch delete operation',
        );
      }

      log('📊 DeleteController: ${result['message']} + history logged');
    } else {
      log('📊 DeleteController: ${result['message']}');
    }

    return result;
  }

  // Helper untuk mendapatkan userId
  String _getCurrentUserId() {
    // ⭐ IMPLEMENTASI SESUAI AUTH SYSTEM ANDA
    // Contoh dengan Firebase Auth:
    // return FirebaseAuth.instance.currentUser?.uid ?? 'anonymous_user';

    // Untuk sementara, pakai timestamp-based userId
    return 'user_${DateTime.now().millisecondsSinceEpoch}';
  }

  // Confirm delete dialog helper
  Map<String, dynamic> confirmDelete(String id) {
    return {
      'id': id,
      'message': 'Are you sure you want to delete this todo?',
      'action': 'delete',
      'requiresConfirmation': true,
    };
  }

  // Confirm multiple delete
  Map<String, dynamic> confirmMultipleDelete(List<String> ids) {
    return {
      'ids': ids,
      'message': 'Are you sure you want to delete ${ids.length} todos?',
      'action': 'delete_multiple',
      'requiresConfirmation': true,
    };
  }
}
