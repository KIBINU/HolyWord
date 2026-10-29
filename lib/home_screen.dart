
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

  static const purple = Color(0xFF8B78F6);

  final List<Widget> _screens = const [
    BibleSelector(),
    HymnsSelector(),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        height: 72,
        backgroundColor: colors.surface,
        indicatorColor: purple.withValues(alpha: 0.20),
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(
              Icons.menu_book_rounded,
              color: purple,
            ),
            label: 'Bible',
          ),
          NavigationDestination(
            icon: Icon(Icons.library_music_outlined),
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
