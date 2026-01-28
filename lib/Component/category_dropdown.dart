import 'package:flutter/material.dart';
import 'package:latihan_firestore/Component/colors.dart';

class CategoryDropdown extends StatelessWidget {
  final String? selectedCategory;
  final ValueChanged<String?> onChanged;
  final List<String> categories;

  const CategoryDropdown({
    super.key,
    required this.selectedCategory,
    required this.onChanged,
    this.categories = const ['study', 'work', 'personal', 'school'],
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Category', style: TextStyle(color: AppColors.textPrimary)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: selectedCategory,
          items: categories
              .map((e) => DropdownMenuItem(value: e, child: Text(_label(e))))
              .toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.cardBackground,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.lightGray),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.lightGray),
            ),
          ),
        ),
      ],
    );
  }

  String _label(String v) => v[0].toUpperCase() + v.substring(1);
}
