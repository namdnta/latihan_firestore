import 'package:get/get.dart';
import 'package:latihan_firestore/services/history.service.dart';

class HistoryController extends GetxController {
  final HistoryService _historyService = HistoryService();
  var historyLogs = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchHistory();
  }

  void fetchHistory() {
    isLoading.value = true;
    _historyService.streamHistory().listen((logs) {
      historyLogs.value = logs;
      isLoading.value = false;
    });
  }

  // Filter by todoId
  List<Map<String, dynamic>> getHistoryForTodo(String todoId) {
    return historyLogs.where((log) => log['todoId'] == todoId).toList();
  }

  // Filter by action type
  List<Map<String, dynamic>> getHistoryByAction(String action) {
    return historyLogs.where((log) => log['action'] == action).toList();
  }
}
