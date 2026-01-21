import 'package:flutter/material.dart';
import 'package:latihan_firestore/Component/colors.dart';

class PrioritySelector extends StatelessWidget {
  final String? selectedPriority; // 'high' | 'medium' | 'low'
  final ValueChanged<String> onPriorityChanged;

  const PrioritySelector({
    super.key,
    required this.selectedPriority,
    required this.onPriorityChanged,
  });

  @override
  Widget build(BuildContext context) {
    Widget chip(String label, Color color) {
      final isSelected = selectedPriority == label.toLowerCase();
      return ChoiceChip(
        selected: isSelected,
        label: Text(label),
        labelStyle: TextStyle(
          color: isSelected ? AppColors.white : AppColors.textPrimary,
        ),
        selectedColor: color,
        onSelected: (_) => onPriorityChanged(label.toLowerCase()),
        backgroundColor: AppColors.cardBackground,
        side: const BorderSide(color: AppColors.lightGray),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Priority', style: TextStyle(color: AppColors.textPrimary)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            chip('High', AppColors.priorityHigh),
            chip('Medium', AppColors.priorityMedium),
            chip('Low', AppColors.priorityLow),
          ],
        ),
      ],
    );
  }
}
