
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

  static const Color _background = Color(0xFF101027);
  static const Color _surface = Color(0xFF191936);
  static const Color _purple = Color(0xFF8B5CF6);
  static const Color _gold = Color(0xFFFFD166);

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
          hymn.author.toLowerCase().contains(query) ||
          hymn.number.toString() == query ||
          hymn.verses.any(
            (verse) => verse.toLowerCase().contains(query),
          );
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _changeLanguage(String? languageCode) {
    if (languageCode == null) return;

    setState(() {
      _selectedLanguageCode = languageCode;
      _query = '';
      _searchController.clear();
    });
  }

  void _openHymn(Hymn hymn) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: _surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  22,
                  12,
                  22,
                  MediaQuery.of(context).viewInsets.bottom + 24,
                ),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.75,
                  child: Column(
                    children: [
                      Container(
                        width: 45,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      const SizedBox(height: 22),
                      Text(
                        'HYMN ${hymn.number}',
                        style: const TextStyle(
                          color: _gold,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        hymn.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'By ${hymn.author}',
                        style: const TextStyle(
                          color: Colors.white60,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.text_decrease,
                            color: Colors.white70,
                          ),
                          Expanded(
                            child: Slider(
                              value: _fontSize,
                              min: 14,
                              max: 32,
                              divisions: 9,
                              activeColor: _purple,
                              onChanged: (value) {
                                setState(() {
                                  _fontSize = value;
                                });
                                setSheetState(() {});
                              },
                            ),
                          ),
                          const Icon(
                            Icons.text_increase,
                            color: Colors.white70,
                          ),
                        ],
                      ),
                      const Divider(color: Colors.white12),
                      Expanded(
                        child: ListView.separated(
                          itemCount: hymn.verses.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 22),
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                Text(
                                  'Verse ${index + 1}',
                                  style: const TextStyle(
                                    color: _gold,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  hymn.verses[index],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: _fontSize,
                                    height: 1.7,
                                  ),
                                ),
                              ],
                            );
                          },
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

    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        backgroundColor: _background,
        elevation: 0,
        title: const Row(
          children: [
            Icon(Icons.music_note, color: _gold),
            SizedBox(width: 10),
            Text(
              'Holy Hymns',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 12),
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
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Explore hymns and worship in your language.',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: DropdownButtonFormField<String>(
                value: _selectedLanguageCode,
                dropdownColor: _surface,
                decoration: InputDecoration(
                  labelText: 'Hymn language',
                  prefixIcon: const Icon(
                    Icons.language,
                    color: _gold,
                  ),
                  filled: true,
                  fillColor: _surface,
                  border: OutlineInputBorder(
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

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _query = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search hymns, lyrics, or number...',
                  prefixIcon: const Icon(Icons.search),
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
                  fillColor: _surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            Expanded(
              child: results.isEmpty
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.library_music_outlined,
                              size: 55,
                              color: Colors.white38,
                            ),
                            SizedBox(height: 12),
                            Text(
                              'No hymns found',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              'Try another search or language.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white60,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(
                        18,
                        4,
                        18,
                        20,
                      ),
                      itemCount: results.length,
                      itemBuilder: (context, index) {
                        final hymn = results[index];

                        return Card(
                          color: _surface,
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(14),
                            leading: Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                color: _purple.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(14),
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
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                hymn.author,
                                style: const TextStyle(
                                  color: Colors.white60,
                                ),
                              ),
                            ),
                            trailing: const Icon(
                              Icons.play_circle_outline,
                              color: _gold,
                              size: 30,
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
