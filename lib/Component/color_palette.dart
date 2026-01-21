import 'package:flutter/material.dart';
import 'package:latihan_firestore/Component/colors.dart';

class ColorPalette extends StatelessWidget {
  const ColorPalette({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = [
      AppColors.white,
      AppColors.cardBackground,
      AppColors.primaryGreen,
      AppColors.darkGreen,
    ];

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: colors
            .map((c) => Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: c,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: AppColors.lightGray),
                  ),
                ))
            .toList(),
      ),
    );
  }
}
