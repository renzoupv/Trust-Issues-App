// lib/screens/time_limit_screen.dart
//
// Returned by showDialog() — must be a Dialog widget, not a Scaffold.

import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class TimeLimitScreen extends StatefulWidget {
  final int? currentMinutes;
  const TimeLimitScreen({super.key, required this.currentMinutes});

  @override
  State<TimeLimitScreen> createState() => _TimeLimitScreenState();
}

class _TimeLimitScreenState extends State<TimeLimitScreen> {
  late int selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.currentMinutes ?? 1;
  }

  @override
  Widget build(BuildContext context) {
    final options = List.generate(10, (i) => i + 1);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 500),
        decoration: BoxDecoration(
          color: AppColors.cardWhite,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            // ── Header ──
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 12, 4),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Select Time Limit',
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
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Choose a time limit between 1-10 minutes',
                  style: TextStyle(fontSize: 11, color: AppColors.textGray),
                ),
              ),
            ),

            // ── Options list ──
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final value = options[index];
                  final isSelected = value == selectedValue;
                  final label = '$value Minute${value == 1 ? '' : 's'}';

                  return GestureDetector(
                    onTap: () => setState(() => selectedValue = value),
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 3),
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFFFFF9C4) : Colors.transparent,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            label,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                              color: AppColors.textDark,
                            ),
                          ),
                          if (isSelected)
                            const Icon(Icons.check, color: AppColors.green, size: 18),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // ── Black CONFIRM button — pops with the selected value ──
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.darkButton,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context, selectedValue),
                  child: const Text(
                    'CONFIRM',
                    style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}