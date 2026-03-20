// lib/screens/select_category_screen.dart
//
// Returned by showDialog() — must be a Dialog widget, not a Scaffold.

import 'package:flutter/material.dart';
import '../data/word_categories.dart';
import '../utils/app_theme.dart';

class SelectCategoryScreen extends StatelessWidget {
  final String currentCategory;
  const SelectCategoryScreen({super.key, required this.currentCategory});

  @override
  Widget build(BuildContext context) {
    final categories = WordCategories.categoryNames;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardWhite,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            // ── Header ──
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 12, 12),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Select Category',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20, color: AppColors.textGray),
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),

            // ── Category options ──
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                children: categories.map((cat) {
                  final isSelected = cat == currentCategory;
                  return GestureDetector(
                    // Pop with the selected category — HomeScreen receives it
                    onTap: () => Navigator.pop(context, cat),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.coral : AppColors.offWhite,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _iconFor(cat),
                            color: isSelected ? Colors.white : _iconColorFor(cat),
                            size: 24,
                          ),
                          const SizedBox(width: 14),
                          Text(
                            cat,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: isSelected ? Colors.white : AppColors.textDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _iconFor(String cat) {
    switch (cat) {
      case 'Foods & Drinks':   return Icons.local_bar;
      case 'Everyday Objects': return Icons.shopping_bag_outlined;
      case 'Animals':          return Icons.pets;
      default:                 return Icons.category;
    }
  }

  Color _iconColorFor(String cat) {
    switch (cat) {
      case 'Foods & Drinks':   return Colors.orange;
      case 'Everyday Objects': return AppColors.textDark;
      case 'Animals':          return AppColors.textGray;
      default:                 return AppColors.coral;
    }
  }
}