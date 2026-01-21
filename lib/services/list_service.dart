import 'package:firebase_database/firebase_database.dart';
import 'package:latihan_firestore/utils/firestore.realtime.dart';

class ListService {
  /// Stream semua todo dari Realtime Database
  Stream<List<Map<String, dynamic>>> streamTodos() {
    return DatabaseService.todosStream.map((DatabaseEvent event) {
      final snapshot = event.snapshot;

      if (!snapshot.exists || snapshot.value == null) {
        return <Map<String, dynamic>>[];
      }

      final Map<dynamic, dynamic> rawData =
          snapshot.value as Map<dynamic, dynamic>;

      return rawData.entries.map<Map<String, dynamic>>((entry) {
        final Map<String, dynamic> todo = Map<String, dynamic>.from(
          entry.value,
        );

        // pastikan ID selalu ada
        todo['id'] ??= entry.key;

        return todo;
      }).toList();
    });
  }

  /// Ambil todo sekali (non-stream)
  Future<List<Map<String, dynamic>>> fetchTodosOnce() async {
    final event = await DatabaseService.todosRef.once();

    if (!event.snapshot.exists || event.snapshot.value == null) {
      return [];
    }

    final Map<dynamic, dynamic> rawData =
        event.snapshot.value as Map<dynamic, dynamic>;

    return rawData.entries.map<Map<String, dynamic>>((entry) {
      final Map<String, dynamic> todo = Map<String, dynamic>.from(entry.value);

      todo['id'] ??= entry.key;
      return todo;
    }).toList();
  }
}
