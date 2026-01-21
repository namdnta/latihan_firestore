import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class DatabaseService {
  static late FirebaseDatabase _database;

  static Future<void> initialize() async {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp();
    }

    _database = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL:
          'https://latihan-firestore-b951f-default-rtdb.firebaseio.com/',
    );

    print('✅ DatabaseService initialized at: ${_database.databaseURL}');
  }

  static DatabaseReference get todosRef {
    return _database.ref().child('todos');
  }

  static DatabaseReference todoRef(String id) {
    return todosRef.child(id);
  }

  static Stream<DatabaseEvent> get todosStream {
    return todosRef.onValue;
  }

  static Future<bool> testConnection() async {
    try {
      await _database.ref().child('.info/connected').once();
      print('✅ Database connection test: PASSED');
      return true;
    } catch (e) {
      print('❌ Database connection test: FAILED - $e');
      return false;
    }
  }

  static void enablePersistence({int cacheSizeMB = 10}) {
    _database.setPersistenceEnabled(true);
    _database.setPersistenceCacheSizeBytes(cacheSizeMB * 1024 * 1024);
    print('💾 Persistence enabled (${cacheSizeMB}MB cache)');
  }

  static Future<void> clearCache() async {
    await _database.ref().keepSynced(false);
    print('🧹 Database cache cleared');
  }

  static Query priorityQuery(String priority) {
    return todosRef.orderByChild('priority').equalTo(priority);
  }

  static Query categoryQuery(String category) {
    return todosRef.orderByChild('category').equalTo(category);
  }

  static Query completedQuery(bool isCompleted) {
    return todosRef.orderByChild('isCompleted').equalTo(isCompleted);
  }

  static Future<void> deleteAllTodos() async {
    await todosRef.remove();
    print('🗑️ All todos deleted');
  }

  static Future<void> markAllAsCompleted() async {
    final snapshot = await todosRef.once();
    if (snapshot.snapshot.value == null) return;

    final Map<dynamic, dynamic> todos =
        snapshot.snapshot.value as Map<dynamic, dynamic>;

    for (var key in todos.keys) {
      await todoRef(key.toString()).update({
        'isDone': true,
        'updatedAt': DateTime.now().toIso8601String(),
      });
    }

    print('✅ All todos marked as completed');
  }
}
//