import 'dart:developer' show log;
import 'package:firebase_database/firebase_database.dart';

class HistoryService {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  /// Log history untuk operasi UPDATE (menerima `Map<dynamic, dynamic>`)
  Future<void> logUpdate({
    required String todoId,
    required Map<dynamic, dynamic> oldData, // ⭐ TERIMA DYNAMIC
    required Map<dynamic, dynamic> newData, // ⭐ TERIMA DYNAMIC
    required String userId,
  }) async {
    try {
      final now = DateTime.now();
      final historyId = now.millisecondsSinceEpoch.toString();

      final historyLog = {
        'action': 'UPDATE',
        'todoId': todoId,
        'oldData': oldData,
        'newData': newData,
        'userId': userId,
        'time': now.millisecondsSinceEpoch,
        'timestamp': now.toIso8601String(),
        'changes': _identifyChanges(oldData, newData),
      };

      await _database.child('history').child(historyId).set(historyLog);

      log('📝 ModifiedHistoryService: Update logged for todo $todoId');
    } catch (e) {
      log('❌ ModifiedHistoryService Error: $e');
    }
  }

  /// Log history untuk operasi DELETE (menerima `Map<dynamic, dynamic>`)
  Future<void> logDelete({
    required String todoId,
    required Map<dynamic, dynamic> deletedData, // ⭐ TERIMA DYNAMIC
    required String userId,
    String? reason,
  }) async {
    try {
      final now = DateTime.now();
      final historyId = now.millisecondsSinceEpoch.toString();

      final historyLog = {
        'action': 'DELETE',
        'todoId': todoId,
        'deletedData': deletedData,
        'userId': userId,
        'time': now.millisecondsSinceEpoch,
        'timestamp': now.toIso8601String(),
        'reason': reason ?? 'User initiated',
      };

      await _database.child('history').child(historyId).set(historyLog);

      log('🗑️ ModifiedHistoryService: Delete logged for todo $todoId');
    } catch (e) {
      log('❌ ModifiedHistoryService Error: $e');
    }
  }

  /// Log history untuk TODO COMPLETION
  Future<void> logCompletion({
    required String todoId,
    required Map<dynamic, dynamic> todoData, // ⭐ TERIMA DYNAMIC
    required String userId,
  }) async {
    try {
      final now = DateTime.now();
      final historyId = now.millisecondsSinceEpoch.toString();

      final historyLog = {
        'action': 'COMPLETED',
        'todoId': todoId,
        'todoData': todoData,
        'userId': userId,
        'time': now.millisecondsSinceEpoch,
        'timestamp': now.toIso8601String(),
      };

      await _database.child('history').child(historyId).set(historyLog);

      log('✅ ModifiedHistoryService: Completion logged for todo $todoId');
    } catch (e) {
      log('❌ ModifiedHistoryService Completion Error: $e');
    }
  }

  /// Log history untuk TODO REOPEN
  Future<void> logReopen({
    required String todoId,
    required Map<dynamic, dynamic> todoData, // ⭐ TERIMA DYNAMIC
    required String userId,
  }) async {
    try {
      final now = DateTime.now();
      final historyId = now.millisecondsSinceEpoch.toString();

      final historyLog = {
        'action': 'REOPENED',
        'todoId': todoId,
        'todoData': todoData,
        'userId': userId,
        'time': now.millisecondsSinceEpoch,
        'timestamp': now.toIso8601String(),
      };

      await _database.child('history').child(historyId).set(historyLog);

      log('↩️ ModifiedHistoryService: Reopen logged for todo $todoId');
    } catch (e) {
      log('❌ ModifiedHistoryService Reopen Error: $e');
    }
  }

  /// Helper: Identifikasi field apa saja yang berubah
  List<String> _identifyChanges(
    Map<dynamic, dynamic> oldData, // ⭐ TERIMA DYNAMIC
    Map<dynamic, dynamic> newData, // ⭐ TERIMA DYNAMIC
  ) {
    final changes = <String>[];

    for (final key in newData.keys) {
      if (oldData.containsKey(key)) {
        if (oldData[key] != newData[key]) {
          changes.add(key.toString());
        }
      } else {
        changes.add(key.toString());
      }
    }

    for (final key in oldData.keys) {
      if (!newData.containsKey(key)) {
        changes.add('$key (removed)');
      }
    }

    return changes;
  }

  /// Stream history
  Stream<List<Map<String, dynamic>>> streamHistory() {
    return _database.child('history').onValue.map((event) {
      final Map<dynamic, dynamic>? data = event.snapshot.value as Map?;
      if (data == null) return [];

      return data.entries.map((entry) {
        final logData = Map<String, dynamic>.from(entry.value);
        return {'historyId': entry.key, ...logData};
      }).toList();
    });
  }
}
