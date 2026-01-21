import 'package:latihan_firestore/utils/firestore.realtime.dart';
import 'package:uuid/uuid.dart';

class IdGenerator {
  static final Uuid _uuid = Uuid();

  static String generateShortUuid() {
    final fullUuid = _uuid.v4();
    final shortId = fullUuid.replaceAll('-', '').substring(0, 5).toLowerCase();
    return shortId;
  }

  static isIdExists(String id) async {
    try {
      final snapshot = await DatabaseService.todoRef(id).once();
      return snapshot.snapshot.value != null;
    } catch (e) {
      return false;
    }
  }

  Future<String> _generateUniqueId() async {
    String id;
    int attempts = 0;

    do {
      id = IdGenerator.generateShortUuid();
      attempts++;

      final exists = await isIdExists(id);
      if (!exists) {
        return id;
      }

      print('⚠️ ID $id already exists, retrying... (attempt $attempts)');
    } while (attempts < 5);

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    id = timestamp.toString().substring(timestamp.toString().length - 5);
    print('🔄 Using fallback ID: $id');

    return id;
  }
}

//
