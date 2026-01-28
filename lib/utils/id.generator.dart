import 'dart:math';
import 'package:latihan_firestore/utils/firestore.realtime.dart';

class IdGenerator {
  static final Random _rand = Random();

  static String generateShortUuid() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final id = List.generate(5, (_) => chars[_rand.nextInt(chars.length)])
        .join();
    return id;
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
