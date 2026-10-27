
import 'package:flutter/material.dart';

import 'bible_selector.dart';
import 'hymns_selector.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const background = Color(0xFF10111B);
  static const purple = Color(0xFF8B78F6);
  static const muted = Color(0xFFAAA9BC);

  final List<Widget> _screens = const [
    BibleSelector(),
    HymnsSelector(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        height: 72,
        backgroundColor: const Color(0xFF1B1D2B),
        indicatorColor: purple.withOpacity(0.20),
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(
              Icons.menu_book_outlined,
              color: muted,
            ),
            selectedIcon: Icon(
              Icons.menu_book_rounded,
              color: purple,
            ),
            label: 'Bible',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.library_music_outlined,
              color: muted,
            ),
            selectedIcon: Icon(
              Icons.library_music_rounded,
              color: purple,
            ),
            label: 'Hymns',
          ),
        ],
      ),
    );
  }
}
