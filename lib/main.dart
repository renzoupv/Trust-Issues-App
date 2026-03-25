import 'package:flutter/material.dart';
import 'utils/app_theme.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const TrustIssuesApp());
}

class TrustIssuesApp extends StatelessWidget {
  const TrustIssuesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trust Issues',
      debugShowCheckedModeBanner: false, 
      theme: AppTheme.theme,             
      home: const HomeScreen(),          
    );
  }
}