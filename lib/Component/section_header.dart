import 'package:flutter/material.dart';
import 'package:latihan_firestore/Component/colors.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color backgroundColor;

  const SectionHeader({
    super.key,
    required this.title,
    required this.icon,
    this.backgroundColor = AppColors.primaryGreen,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      color: backgroundColor,
      child: Row(
        children: [
          Icon(icon, color: AppColors.white),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.white,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
