
import 'package:flutter/material.dart';

import 'theme_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: themeController,
      builder: (context, child) {
        final isDark = themeController.isDarkMode;

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Settings',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),

          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Text(
                'APPEARANCE',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  color: Color(0xFF8B78F6),
                ),
              ),

              const SizedBox(height: 12),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF8B78F6)
                                  .withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              isDark
                                  ? Icons.dark_mode_rounded
                                  : Icons.light_mode_rounded,
                              color: const Color(0xFF8B78F6),
                              size: 28,
                            ),
                          ),

                          const SizedBox(width: 16),

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Dark Mode',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),

                                const SizedBox(height: 4),

                                Text(
                                  isDark
                                      ? 'Dark appearance is enabled'
                                      : 'Light appearance is enabled',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Switch.adaptive(
                            value: isDark,
                            activeTrackColor:
                                const Color(0xFF8B78F6),
                            onChanged: (value) {
                              themeController.setDarkMode(value);
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      const Divider(),

                      const SizedBox(height: 12),

                      Row(
                        children: [
                          Expanded(
                            child: _ThemeOption(
                              title: 'Light',
                              icon: Icons.light_mode_rounded,
                              selected: !isDark,
                              onTap: () {
                                themeController.setDarkMode(false);
                              },
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: _ThemeOption(
                              title: 'Dark',
                              icon: Icons.dark_mode_rounded,
                              selected: isDark,
                              onTap: () {
                                themeController.setDarkMode(true);
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'ABOUT',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  color: Color(0xFF8B78F6),
                ),
              ),

              const SizedBox(height: 12),

              Card(
                child: ListTile(
                  leading: const Icon(
                    Icons.menu_book_rounded,
                    color: Color(0xFF8B78F6),
                  ),
                  title: const Text('Holy Word'),
                  subtitle: const Text(
                    'Your Bible reading companion',
                  ),
                  trailing: const Text('v1.0.0'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _ThemeOption({
    required this.title,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected
        ? const Color(0xFF8B78F6)
        : Theme.of(context).colorScheme.onSurfaceVariant;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 12,
        ),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFF8B78F6).withValues(alpha: 0.12)
              : Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected
                ? const Color(0xFF8B78F6)
                : Colors.transparent,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (selected)
              const Padding(
                padding: EdgeInsets.only(top: 4),
                child: Icon(
                  Icons.check_circle,
                  color: Color(0xFF8B78F6),
                  size: 16,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
