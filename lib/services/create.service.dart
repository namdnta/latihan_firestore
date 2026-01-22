import 'dart:developer' show log;
import 'package:latihan_firestore/utils/firestore.realtime.dart';
import 'package:latihan_firestore/utils/id.generator.dart';

class CreateService {
  // Generate unique ID
  Future<String> _generateUniqueId() async {
    String id;
    int attempts = 0;

    do {
      id = IdGenerator.generateShortUuid();
      attempts++;

      final exists = await IdGenerator.isIdExists(id);
      if (!exists) {
        return id;
      }

      log('⚠️ ID $id exists, retry $attempts');
    } while (attempts < 5);

    // Fallback ID
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return timestamp.toString().substring(timestamp.toString().length - 5);
  }

  // CREATE TODO
  Future<Map<String, dynamic>> createTodo({
    required String taskName,
    required String dueDate,
    required String priority,
    required String category,
    String description = '',
  }) async {
    try {
      log('🎯 CreateService: Creating todo...');

      final String id = await _generateUniqueId();
      log('✅ Generated ID: $id');

      final Map<String, dynamic> todoData = {
        'id': id,
        'taskName': taskName,
        'dueDate': dueDate,
        'priority': priority,
        'category': category,
        'description': description,
        'isDone': false,
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      };

      final exists = await IdGenerator.isIdExists(id);
      if (exists) {
        return {
          'success': false,
          'error': 'Duplicate ID',
          'message': 'ID $id already exists',
        };
      }

      await DatabaseService.todoRef(id).set(todoData);
      log('💾 Todo saved: $id');

      return {
        'success': true,
        'id': id,
        'data': todoData,
        'message': 'Todo created successfully',
      };
    } catch (e) {
      log('❌ CreateService Error: $e');
      return {
        'success': false,
        'error': e.toString(),
        'message': 'Failed to create todo',
      };
    }
  }
}
