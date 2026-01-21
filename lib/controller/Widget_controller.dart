import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class WidgetController extends GetxController {
  final isWideScreen = false.obs;

  void updateLayout(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    isWideScreen.value = width >= 720;
  }
}
