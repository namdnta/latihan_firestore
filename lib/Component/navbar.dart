import 'package:flutter/material.dart';
import 'package:latihan_firestore/Component/buttons.dart';
import 'package:latihan_firestore/Component/colors.dart';

class FloatingNavBar extends StatelessWidget {
  final VoidCallback onToHistory;
  final VoidCallback onToMain;
  final VoidCallback onToAdd;

  const FloatingNavBar({
    super.key,
    required this.onToHistory,
    required this.onToMain,
    required this.onToAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppColors.cardBackground,
        border: Border(
          top: BorderSide(color: AppColors.lightGray, width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CustomFloatingActionButton(
            icon: Icons.list_alt,
            onPressed: onToMain,
            heroTag: null,
            backgroundColor: AppColors.primaryGreen,
          ),
          CustomFloatingActionButton(
            icon: Icons.add,
            onPressed: onToAdd,
            heroTag: null,
          ),
          CustomFloatingActionButton(
            icon: Icons.check_circle,
            onPressed: onToHistory,
            heroTag: null,
            backgroundColor: AppColors.completed,
          ),
        ],
      ),
    );
  }
}
