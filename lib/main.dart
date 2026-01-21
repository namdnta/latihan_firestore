import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latihan_firestore/pages/mainpage.dart';
import 'package:latihan_firestore/pages/form_page.dart';
import 'package:latihan_firestore/pages/history_page.dart';
import 'package:latihan_firestore/utils/firestore.realtime.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await DatabaseService.initialize();
  await DatabaseService.testConnection();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Latihan Firestore',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const TodoListPage(),
      routes: {
        '/add': (_) => const TodoFormPage(),
        '/history': (_) => const HistoryPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
