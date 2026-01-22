import 'package:flutter/material.dart';
import 'package:latihan_firestore/Component/colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isSecondary;
  final IconData? icon;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isSecondary = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final bg = isSecondary ? AppColors.cardBackground : AppColors.primaryGreen;
    final fg = isSecondary ? AppColors.textPrimary : AppColors.white;

    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: bg,
        foregroundColor: fg,
        disabledBackgroundColor: AppColors.lightGray,
        disabledForegroundColor: AppColors.textSecondary,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      icon: icon != null ? Icon(icon) : const SizedBox.shrink(),
      label: Text(text),
    );
  }
}

class CustomFloatingActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Object? heroTag;

  const CustomFloatingActionButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.backgroundColor,
    this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: backgroundColor ?? AppColors.cardBackground,
      foregroundColor: AppColors.textPrimary,
      heroTag: heroTag,
      child: Icon(icon),
    );
  }
}
