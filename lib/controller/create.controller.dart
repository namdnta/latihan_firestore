import 'package:latihan_firestore/services/create.service.dart';

class CreateController {
  final CreateService _createService = CreateService();

  Future<Map<String, dynamic>> createTodo({
    required String taskName,
    required String dueDate,
    required String priority,
    required String category,
    String description = '',
  }) async {
    print('🎛️ CreateController: Processing create request...');

    // Validation
    if (taskName.isEmpty) {
      return {
        'success': false,
        'error': 'Validation',
        'message': 'Task name is required',
      };
    }

    if (dueDate.isEmpty) {
      return {
        'success': false,
        'error': 'Validation',
        'message': 'Due date is required',
      };
    }

    if (priority.isEmpty) {
      return {
        'success': false,
        'error': 'Validation',
        'message': 'Priority is required',
      };
    }

    if (category.isEmpty) {
      return {
        'success': false,
        'error': 'Validation',
        'message': 'Category is required',
      };
    }

    // Call service
    final result = await _createService.createTodo(
      taskName: taskName,
      dueDate: dueDate,
      priority: priority,
      category: category,
      description: description,
    );

    // Log result
    if (result['success'] == true) {
      print('✅ CreateController: Todo created! ID: ${result['id']}');
    } else {
      print('❌ CreateController: Failed: ${result['error']}');
    }

    return result;
  }

  // Validate due date format (YYYY-MM-DD)
  bool validateDueDate(String date) {
    final regex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
    return regex.hasMatch(date);
  }

  // Validate priority (low, medium, high)
  bool validatePriority(String priority) {
    return ['low', 'medium', 'high'].contains(priority.toLowerCase());
  }
}
