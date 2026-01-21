// test_services.dart - File terpisah
import 'package:firebase_core/firebase_core.dart';
import 'lib/services/create.service.dart';
import 'lib/services/delete.service.dart';
import 'lib/utils/firestore.realtime.dart';

void main() async {
  print('🧪 SERVICE TEST WITHOUT UI 🧪\n');

  try {
    // 1. Initialize Firebase
    print('1. Initializing Firebase...');
    await Firebase.initializeApp();
    await DatabaseService.initialize();
    await DatabaseService.testConnection();
    print('✅ Firebase ready\n');

    // 2. Test Create Service
    await testCreateService();

    // 3. Test Delete Service
    await testDeleteService();

    print('\n🎉 ALL TESTS PASSED!');
  } catch (e) {
    print('\n❌ TEST FAILED: $e');
  }
}

Future<void> testCreateService() async {
  print('=== CREATE SERVICE TEST ===');

  final createService = CreateService();

  // Test 1: Normal create
  print('\nTest 1: Creating todo with all fields...');
  final result1 = await createService.createTodo(
    taskName: 'Belajar Flutter CRUD',
    dueDate: '2023-12-31',
    priority: 'high',
    category: 'Study',
    description: 'Membuat aplikasi todo list dengan Firebase',
  );

  printResult('Create 1', result1);

  // Test 2: Minimal create
  print('\nTest 2: Creating todo with minimal fields...');
  final result2 = await createService.createTodo(
    taskName: 'Makan siang',
    dueDate: '2023-10-20',
    priority: 'medium',
    category: 'Personal',
  );

  printResult('Create 2', result2);

  // Test 3: Invalid data (empty task name)
  print('\nTest 3: Creating todo with empty task name...');
  final result3 = await createService.createTodo(
    taskName: '',
    dueDate: '2023-12-31',
    priority: 'high',
    category: 'Test',
  );

  printResult('Create 3', result3);
}

Future<void> testDeleteService() async {
  print('\n=== DELETE SERVICE TEST ===');

  final deleteService = DeleteService();
  final createService = CreateService();

  // Create a todo first for deletion test
  print('\nPreparing: Creating todo for deletion test...');
  final createResult = await createService.createTodo(
    taskName: 'DELETE ME',
    dueDate: '2023-12-31',
    priority: 'low',
    category: 'Test',
  );

  if (createResult['success'] != true) {
    print('❌ Failed to create todo for deletion test');
    return;
  }

  final todoId = createResult['id'];
  print('✅ Created todo with ID: $todoId\n');

  // Test 1: Delete existing todo
  print('Test 1: Deleting existing todo...');
  final deleteResult1 = await deleteService.deleteTodo(todoId);
  printResult('Delete 1', deleteResult1);

  // Test 2: Delete non-existent todo
  print('\nTest 2: Deleting non-existent todo...');
  final deleteResult2 = await deleteService.deleteTodo('xxxxx');
  printResult('Delete 2', deleteResult2);

  // Test 3: Create multiple and delete
  print('\nTest 3: Batch create and delete...');

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
      print('  Created: ${result['id']}');
    }
  }

  print('\n  Deleting ${todoIds.length} todos...');
  final batchResult = await deleteService.deleteMultiple(todoIds);
  printResult('Batch Delete', batchResult);
}

void printResult(String testName, Map<String, dynamic> result) {
  print('  $testName:');
  print('    Success: ${result['success'] ? '✅' : '❌'}');
  print('    Message: ${result['message']}');
  if (result['id'] != null) {
    print('    ID: ${result['id']}');
  }
  if (result['error'] != null) {
    print('    Error: ${result['error']}');
  }
}
