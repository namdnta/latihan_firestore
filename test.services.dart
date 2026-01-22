// test_services.dart - File terpisah
import 'dart:developer' show log;
import 'package:firebase_core/firebase_core.dart';
import 'lib/services/create.service.dart';
import 'lib/services/delete.service.dart';
import 'lib/utils/firestore.realtime.dart';

void main() async {
  log('🧪 SERVICE TEST WITHOUT UI 🧪\n');

  try {
    // 1. Initialize Firebase
    log('1. Initializing Firebase...');
    await Firebase.initializeApp();
    await DatabaseService.initialize();
    await DatabaseService.testConnection();
    log('✅ Firebase ready\n');

    // 2. Test Create Service
    await testCreateService();

    // 3. Test Delete Service
    await testDeleteService();

    log('\n🎉 ALL TESTS PASSED!');
  } catch (e) {
    log('\n❌ TEST FAILED: $e');
  }
}

Future<void> testCreateService() async {
  log('=== CREATE SERVICE TEST ===');

  final createService = CreateService();

  // Test 1: Normal create
  log('\nTest 1: Creating todo with all fields...');
  final result1 = await createService.createTodo(
    taskName: 'Belajar Flutter CRUD',
    dueDate: '2023-12-31',
    priority: 'high',
    category: 'Study',
    description: 'Membuat aplikasi todo list dengan Firebase',
  );

  printResult('Create 1', result1);

  // Test 2: Minimal create
  log('\nTest 2: Creating todo with minimal fields...');
  final result2 = await createService.createTodo(
    taskName: 'Makan siang',
    dueDate: '2023-10-20',
    priority: 'medium',
    category: 'Personal',
  );

  printResult('Create 2', result2);

  // Test 3: Invalid data (empty task name)
  log('\nTest 3: Creating todo with empty task name...');
  final result3 = await createService.createTodo(
    taskName: '',
    dueDate: '2023-12-31',
    priority: 'high',
    category: 'Test',
  );

  printResult('Create 3', result3);
}

Future<void> testDeleteService() async {
  log('\n=== DELETE SERVICE TEST ===');

  final deleteService = DeleteService();
  final createService = CreateService();

  // Create a todo first for deletion test
  log('\nPreparing: Creating todo for deletion test...');
  final createResult = await createService.createTodo(
    taskName: 'DELETE ME',
    dueDate: '2023-12-31',
    priority: 'low',
    category: 'Test',
  );

  if (createResult['success'] != true) {
    log('❌ Failed to create todo for deletion test');
    return;
  }

  final todoId = createResult['id'];
  log('✅ Created todo with ID: $todoId\n');

  // Test 1: Delete existing todo
  log('Test 1: Deleting existing todo...');
  final deleteResult1 = await deleteService.deleteTodo(todoId);
  printResult('Delete 1', deleteResult1);

  // Test 2: Delete non-existent todo
  log('\nTest 2: Deleting non-existent todo...');
  final deleteResult2 = await deleteService.deleteTodo('xxxxx');
  printResult('Delete 2', deleteResult2);

  // Test 3: Create multiple and delete
  log('\nTest 3: Batch create and delete...');

  final List<String> todoIds = [];
  for (int i = 1; i <= 3; i++) {
    final result = await createService.createTodo(
      taskName: 'Batch Test $i',
      dueDate: '2023-12-${10 + i}',
      priority: i == 1
          ? 'high'
          : i == 2
          ? 'medium'
          : 'low',
      category: 'Batch',
    );

    if (result['success'] == true) {
      todoIds.add(result['id']);
      log('  Created: ${result['id']}');
    }
  }

  log('\n  Deleting ${todoIds.length} todos...');
  final batchResult = await deleteService.deleteMultiple(todoIds);
  printResult('Batch Delete', batchResult);
}

void printResult(String testName, Map<String, dynamic> result) {
  log('  $testName:');
  log('    Success: ${result['success'] ? '✅' : '❌'}');
  log('    Message: ${result['message']}');
  if (result['id'] != null) {
    log('    ID: ${result['id']}');
  }
  if (result['error'] != null) {
    log('    Error: ${result['error']}');
  }
}
