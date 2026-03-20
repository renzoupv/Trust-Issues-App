// lib/main.dart
//
// The entry point of the app.
// Keeps this file as minimal as possible — just sets up the app shell and theme.
// All actual content lives in the screens/ folder.

import 'package:flutter/material.dart';
import 'utils/app_theme.dart';
import 'screens/home_screen.dart';

void main() {
  // runApp() takes our root widget and draws it on the screen
  runApp(const TrustIssuesApp());
}

class TrustIssuesApp extends StatelessWidget {
  const TrustIssuesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trust Issues',
      debugShowCheckedModeBanner: false, // Hides the "DEBUG" banner in the top corner
      theme: AppTheme.theme,             // All colors and styles from app_theme.dart
      home: const HomeScreen(),          // First screen the user sees
    );
  }
}