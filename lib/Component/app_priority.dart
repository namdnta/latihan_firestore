import 'package:flutter/material.dart';
import 'package:latihan_firestore/Component/colors.dart' show AppColors;

class PrioritySelector extends StatelessWidget {
  final String value;
  final Function(String) onChanged;

  const PrioritySelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  Color _getColor(String p) {
    switch (p) {
      case 'high':
        return AppColors.priorityHigh;
      case 'medium':
        return AppColors.priorityMedium;
      default:
        return AppColors.priorityLow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: ['high', 'medium', 'low'].map((p) {
        final isActive = value == p;
        return Expanded(
          child: GestureDetector(
            onTap: () => onChanged(p),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: isActive ? _getColor(p) : AppColors.cardBackground,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                p.toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isActive
                      ? AppColors.textLight
                      : AppColors.textSecondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
