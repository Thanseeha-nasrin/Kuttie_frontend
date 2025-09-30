// lib/main.dart
import 'package:flutter/material.dart';
import 'screens/leaderboard_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kids Leaderboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        scaffoldBackgroundColor: const Color(0xFFFDF6E4),
      ),
      home: const LeaderboardScreen(),
    );
  }
}
