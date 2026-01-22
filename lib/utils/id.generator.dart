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

}

//
