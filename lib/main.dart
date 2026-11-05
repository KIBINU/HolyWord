import 'package:flutter/material.dart';

import 'theme_controller.dart';
import 'home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await themeController.loadTheme();

  runApp(const HolyWordApp());
}

class HolyWordApp extends StatelessWidget {
  const HolyWordApp({super.key});

  static const Color purple = Color(0xFF8B78F6);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: themeController,
      builder: (context, child) {
        return MaterialApp(
          title: 'Holy Word',
          debugShowCheckedModeBanner: false,

          theme: ThemeData(
            brightness: Brightness.light,
            colorScheme: ColorScheme.fromSeed(
              seedColor: purple,
              brightness: Brightness.light,
            ),
            useMaterial3: true,
          ),

          darkTheme: ThemeData(
            brightness: Brightness.dark,
            colorScheme: ColorScheme.fromSeed(
              seedColor: purple,
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
          ),

          themeMode: themeController.themeMode,

          home: const HomeScreen(),
        );
      },
    );
  }
}
