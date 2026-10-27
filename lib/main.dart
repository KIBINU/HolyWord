
import 'package:flutter/material.dart';
import 'home_screen.dart';

void main() {
  runApp(const HolyWordApp());
}

class HolyWordApp extends StatelessWidget {
  const HolyWordApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Holy Word',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF8B78F6),
          brightness: Brightness.dark,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
