import 'package:latihan_firestore/services/delete.service.dart';

class DeleteController {
  final DeleteService _deleteService = DeleteService();

  Future<Map<String, dynamic>> deleteTodo(String id) async {
    print('🎛️ DeleteController: Processing delete request for $id');

    // Validation
    if (id.isEmpty) {
      return {
        'success': false,
        'error': 'Validation',
        'message': 'Todo ID is required',
      };
    }

    if (id.length != 5) {
      return {
        'success': false,
        'error': 'Validation',
        'message': 'Todo ID must be 5 characters',
      };
    }

    // Call service
    final result = await _deleteService.deleteTodo(id);

    // Log result
    if (result['success'] == true) {
      print('✅ DeleteController: Todo $id deleted');
    } else {
      print('❌ DeleteController: Failed: ${result['error']}');
    }

    return result;
  }

  Future<Map<String, dynamic>> deleteMultipleTodos(List<String> ids) async {
    print('🎛️ DeleteController: Processing delete for ${ids.length} todos');

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

    // Call service
    final result = await _deleteService.deleteMultiple(validIds);

    print('📊 DeleteController: ${result['message']}');

    return result;
  }

  // Confirm delete dialog helper
  Map<String, dynamic> confirmDelete(String id) {
    return {
      'id': id,
      'message': 'Are you sure you want to delete this todo?',
      'action': 'delete',
    };
  }

  // Confirm multiple delete
  Map<String, dynamic> confirmMultipleDelete(List<String> ids) {
    return {
      'ids': ids,
      'message': 'Are you sure you want to delete ${ids.length} todos?',
      'action': 'delete_multiple',
    };
  }
}
