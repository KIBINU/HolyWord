
import 'package:flutter/material.dart';
import 'data/hymns_content.dart';

class HymnsSelector extends StatefulWidget {
  const HymnsSelector({super.key});

  @override
  State<HymnsSelector> createState() => _HymnsSelectorState();
}

class _HymnsSelectorState extends State<HymnsSelector> {
  final TextEditingController _searchController =
      TextEditingController();

  String _query = '';
  String _selectedLanguageCode = 'en';
  double _fontSize = 20;

  static const Color _purple = Color(0xFF8B5CF6);
  static const Color _gold = Color(0xFFFFD166);

  // Filter hymns by language and search query.
  List<Hymn> get filteredHymns {
    final query = _query.trim().toLowerCase();

    final languageHymns = hymns
        .where(
          (hymn) =>
              hymn.languageCode == _selectedLanguageCode,
        )
        .toList();

    if (query.isEmpty) {
      return languageHymns;
    }

    return languageHymns.where((hymn) {
      return hymn.title.toLowerCase().contains(query) ||
          hymn.number.toString() == query ||
          hymn.verses.any(
            (verse) => verse.toLowerCase().contains(query),
          ) ||
          (hymn.chorus?.toLowerCase().contains(query) ?? false);
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Change the selected hymn language.
  void _changeLanguage(String? languageCode) {
    if (languageCode == null) return;

    setState(() {
      _selectedLanguageCode = languageCode;
      _query = '';
      _searchController.clear();
    });
  }

  // Open the hymn reader.
  void _openHymn(Hymn hymn) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            final colors = Theme.of(context).colorScheme;

            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              color: colors.surface,
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  22,
                  12,
                  22,
                  MediaQuery.of(context).viewInsets.bottom + 24,
                ),
                child: SizedBox(
                  height:
                      MediaQuery.of(context).size.height * 0.78,
                  child: Column(
                    children: [
                      // Bottom sheet handle
                      Container(
                        width: 45,
                        height: 5,
                        decoration: BoxDecoration(
                          color: colors.onSurface.withValues(
                            alpha: 0.2,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),

                      const SizedBox(height: 22),

                      // App heading
                      const Text(
                        'HOLY HYMNS',
                        style: TextStyle(
                          color: _gold,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Hymn number
                      Text(
                        'HYMN ${hymn.number}',
                        style: const TextStyle(
                          color: _purple,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Hymn title
                      Text(
                        hymn.title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: colors.onSurface,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Language
                      Text(
                        hymnLanguages[hymn.languageCode] ??
                            hymn.languageCode,
                        style: TextStyle(
                          color: colors.onSurfaceVariant,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Font size adjustment
                      Row(
                        children: [
                          Icon(
                            Icons.text_decrease,
                            color: colors.onSurfaceVariant,
                          ),

                          Expanded(
                            child: Slider(
                              value: _fontSize,
                              min: 14,
                              max: 32,
                              divisions: 9,
                              activeColor: _purple,
                              label: _fontSize.round().toString(),
                              onChanged: (value) {
                                setState(() {
                                  _fontSize = value;
                                });

                                setSheetState(() {});
                              },
                            ),
                          ),

                          Icon(
                            Icons.text_increase,
                            color: colors.onSurfaceVariant,
                          ),
                        ],
                      ),

                      const Divider(height: 24),

                      // Scrollable verses and chorus
                      Expanded(
                        child: ListView(
                          padding: const EdgeInsets.only(
                            bottom: 20,
                          ),
                          children: [
                            ...List.generate(
                              hymn.verses.length,
                              (index) {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: 24,
                                  ),
                                  child: Column(
                                    children: [
                                      // Verse heading
                                      Text(
                                        'VERSE ${index + 1}',
                                        style: const TextStyle(
                                          color: _gold,
                                          fontWeight:
                                              FontWeight.bold,
                                          letterSpacing: 1.5,
                                        ),
                                      ),

                                      const SizedBox(height: 10),

                                      // Verse lyrics
                                      Text(
                                        hymn.verses[index],
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: colors.onSurface,
                                          fontSize: _fontSize,
                                          height: 1.7,
                                        ),
                                      ),

                                      const SizedBox(height: 20),

                                      // Show chorus immediately
                                      // after the first verse.
                                      if (index == 0 &&
                                          hymn.chorus != null &&
                                          hymn.chorus!
                                              .trim()
                                              .isNotEmpty)
                                        Container(
                                          width: double.infinity,
                                          padding:
                                              const EdgeInsets.all(18),
                                          decoration: BoxDecoration(
                                            color: _purple.withValues(
                                              alpha: 0.12,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(
                                              16,
                                            ),
                                            border: Border.all(
                                              color:
                                                  _purple.withValues(
                                                alpha: 0.35,
                                              ),
                                            ),
                                          ),
                                          child: Column(
                                            children: [
                                              const Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .center,
                                                children: [
                                                  Icon(
                                                    Icons.music_note,
                                                    color: _gold,
                                                    size: 20,
                                                  ),
                                                  SizedBox(width: 8),
                                                  Text(
                                                    'CHORUS',
                                                    style: TextStyle(
                                                      color: _gold,
                                                      fontWeight:
                                                          FontWeight
                                                              .bold,
                                                      fontSize: 16,
                                                      letterSpacing: 2,
                                                    ),
                                                  ),
                                                ],
                                              ),

                                              const SizedBox(
                                                height: 12,
                                              ),

                                              Text(
                                                hymn.chorus!,
                                                textAlign:
                                                    TextAlign.center,
                                                style: TextStyle(
                                                  color:
                                                      colors.onSurface,
                                                  fontSize: _fontSize,
                                                  height: 1.7,
                                                  fontStyle:
                                                      FontStyle.italic,
                                                  fontWeight:
                                                      FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final results = filteredHymns;
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        foregroundColor: colors.onSurface,
        elevation: 0,
        title: const Row(
          children: [
            Icon(Icons.music_note, color: _gold),
            SizedBox(width: 10),
            Text(
              'Holy Hymns',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),

      body: SafeArea(
        child: Column(
          children: [
            // Welcome banner
            Padding(
              padding: const EdgeInsets.fromLTRB(
                18, 8, 18, 12,
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF5B35B1),
                      Color(0xFF30205F),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sing praises',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Explore hymns and worship in your language.',
                      style: TextStyle(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Language selection
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
              ),
              child: DropdownButtonFormField<String>(
                initialValue: _selectedLanguageCode,
                dropdownColor: colors.surface,
                style: TextStyle(
                  color: colors.onSurface,
                ),
                decoration: InputDecoration(
                  labelText: 'Hymn language',
                  labelStyle: TextStyle(
                    color: colors.onSurfaceVariant,
                  ),
                  prefixIcon: const Icon(
                    Icons.language,
                    color: _gold,
                  ),
                  filled: true,
                  fillColor: colors.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: hymnLanguages.entries.map((entry) {
                  return DropdownMenuItem<String>(
                    value: entry.key,
                    child: Text(entry.value),
                  );
                }).toList(),
                onChanged: _changeLanguage,
              ),
            ),

            const SizedBox(height: 12),

            // Search field
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
              ),
              child: TextField(
                controller: _searchController,
                style: TextStyle(
                  color: colors.onSurface,
                ),
                onChanged: (value) {
                  setState(() {
                    _query = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search hymns, lyrics, or number...',
                  hintStyle: TextStyle(
                    color: colors.onSurfaceVariant,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: colors.onSurfaceVariant,
                  ),
                  suffixIcon: _query.isEmpty
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();

                            setState(() {
                              _query = '';
                            });
                          },
                        ),
                  filled: true,
                  fillColor: colors.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Hymn results
            Expanded(
              child: results.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.library_music_outlined,
                              size: 55,
                              color: colors.onSurfaceVariant,
                            ),

                            const SizedBox(height: 12),

                            Text(
                              'No hymns found',
                              style: TextStyle(
                                color: colors.onSurface,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 6),

                            Text(
                              'Try another search or language.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: colors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(
                        18, 4, 18, 20,
                      ),
                      itemCount: results.length,
                      itemBuilder: (context, index) {
                        final hymn = results[index];

                        return Card(
                          color: colors.surface,
                          margin: const EdgeInsets.only(
                            bottom: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(16),
                          ),
                          child: ListTile(
                            contentPadding:
                                const EdgeInsets.all(14),

                            leading: Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                color: _purple.withValues(
                                  alpha: 0.2,
                                ),
                                borderRadius:
                                    BorderRadius.circular(14),
                              ),
                              child: Center(
                                child: Text(
                                  '${hymn.number}',
                                  style: const TextStyle(
                                    color: _gold,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),

                            title: Text(
                              hymn.title,
                              style: TextStyle(
                                color: colors.onSurface,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            subtitle: Padding(
                              padding: const EdgeInsets.only(
                                top: 5,
                              ),
                              child: Text(
                                hymn.chorus != null &&
                                        hymn.chorus!.trim().isNotEmpty
                                    ? 'Includes chorus • ${hymn.verses.length} verses'
                                    : '${hymn.verses.length} verses',
                                style: TextStyle(
                                  color: colors.onSurfaceVariant,
                                ),
                              ),
                            ),

                            trailing: const Icon(
                              Icons.menu_book_rounded,
                              color: _gold,
                              size: 28,
                            ),

                            onTap: () => _openHymn(hymn),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
