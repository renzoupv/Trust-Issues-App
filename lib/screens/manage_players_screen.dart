// lib/screens/manage_players_screen.dart
//
// Returned by showDialog() — must be a Dialog widget, not a Scaffold.
// The dark overlay behind it is provided by showDialog's barrierColor.

import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class ManagePlayersScreen extends StatefulWidget {
  final List<String> currentNames;
  const ManagePlayersScreen({super.key, required this.currentNames});

  @override
  State<ManagePlayersScreen> createState() => _ManagePlayersScreenState();
}

class _ManagePlayersScreenState extends State<ManagePlayersScreen> {
  late List<TextEditingController> controllers;
  static const int minPlayers = 3;
  static const int maxPlayers = 20;

  @override
  void initState() {
    super.initState();
    controllers = widget.currentNames
        .map((n) => TextEditingController(text: n))
        .toList();
  }

  @override
  void dispose() {
    for (final c in controllers) c.dispose();
    super.dispose();
  }

  void _onSliderChanged(double newCount) {
    final target = newCount.round();
    setState(() {
      if (target > controllers.length) {
        while (controllers.length < target) {
          controllers.add(
            TextEditingController(text: 'Player ${controllers.length + 1}'),
          );
        }
      } else if (target < controllers.length) {
        while (controllers.length > target) {
          controllers.last.dispose();
          controllers.removeLast();
        }
      }
    });
  }

  void _removePlayer(int index) {
    if (controllers.length <= minPlayers) return;
    setState(() {
      controllers[index].dispose();
      controllers.removeAt(index);
    });
  }

  void _save() {
    final names = controllers.map((c) => c.text.trim()).toList();
    if (names.any((n) => n.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Player names cannot be empty.')),
      );
      return;
    }
    if (names.toSet().length != names.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Each player must have a unique name.')),
      );
      return;
    }
    // Pop with the result — showDialog in HomeScreen receives this value
    Navigator.pop(context, names);
  }

  @override
  Widget build(BuildContext context) {
    // Dialog widget — showDialog already provides the dark barrier behind it
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 560),
        decoration: BoxDecoration(
          color: AppColors.cardWhite,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            // ── Header ──
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 12, 0),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Manage Players',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20, color: AppColors.textGray),
                    onPressed: () => Navigator.pop(context), // dismiss without saving
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),

            // ── Active Players count + Slider ──
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 6, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Active Players: ${controllers.length}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark,
                        ),
                      ),
                      const Text(
                        'Min: 3   Max: 20',
                        style: TextStyle(fontSize: 11, color: AppColors.textGray),
                      ),
                    ],
                  ),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: AppColors.coral,
                      inactiveTrackColor: Colors.grey.shade200,
                      thumbColor: AppColors.coral,
                      overlayColor: AppColors.coral.withOpacity(0.15),
                      trackHeight: 4,
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                    ),
                    child: Slider(
                      value: controllers.length.toDouble(),
                      min: minPlayers.toDouble(),
                      max: maxPlayers.toDouble(),
                      divisions: maxPlayers - minPlayers,
                      onChanged: _onSliderChanged,
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            // ── Player list ──
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: controllers.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 14,
                          backgroundColor: AppColors.coral,
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: controllers[index],
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(vertical: 6),
                            ),
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ),
                        if (controllers.length > minPlayers)
                          GestureDetector(
                            onTap: () => _removePlayer(index),
                            child: const Icon(
                              Icons.remove_circle,
                              color: AppColors.coral,
                              size: 18,
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // ── Save button ──
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.coral,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: _save,
                  child: const Text(
                    'Save Players',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
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