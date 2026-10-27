
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/bible_content.dart';

class BibleSelector extends StatefulWidget {
  const BibleSelector({super.key});

  @override
  State<BibleSelector> createState() => _BibleSelectorState();
}

class _BibleSelectorState extends State<BibleSelector> {
  static const Color background = Color(0xFF10111B);
  static const Color panel = Color(0xFF1B1D2B);
  static const Color purple = Color(0xFF8B78F6);
  static const Color gold = Color(0xFFE7C77A);
  static const Color white = Color(0xFFF7F5FF);
  static const Color muted = Color(0xFFAAA9BC);

  final ScrollController _bibleScrollController = ScrollController();

  // A unique key for every verse in every version, book and chapter.
  final Map<String, GlobalKey> _verseKeys = {};

  final List<String> versions = const [
    'OG',
    'WEB',
    'BSB',
    'ASV',
    'KJV',
  ];

  final Map<String, int> books = const {
    'Genesis': 50,
    'Exodus': 40,
    'Leviticus': 27,
    'Numbers': 36,
    'Deuteronomy': 34,
    'Joshua': 24,
    'Judges': 21,
    'Ruth': 4,
    '1 Samuel': 31,
    '2 Samuel': 24,
    '1 Kings': 22,
    '2 Kings': 25,
    '1 Chronicles': 29,
    '2 Chronicles': 36,
    'Ezra': 10,
    'Nehemiah': 13,
    'Esther': 10,
    'Job': 42,
    'Psalms': 150,
    'Proverbs': 31,
    'Ecclesiastes': 12,
    'Song of Solomon': 8,
    'Isaiah': 66,
    'Jeremiah': 52,
    'Lamentations': 5,
    'Ezekiel': 48,
    'Daniel': 12,
    'Hosea': 14,
    'Joel': 3,
    'Amos': 9,
    'Obadiah': 1,
    'Jonah': 4,
    'Micah': 7,
    'Nahum': 3,
    'Habakkuk': 3,
    'Zephaniah': 3,
    'Haggai': 2,
    'Zechariah': 14,
    'Malachi': 4,
    'Matthew': 28,
    'Mark': 16,
    'Luke': 24,
    'John': 21,
    'Acts': 28,
    'Romans': 16,
    '1 Corinthians': 16,
    '2 Corinthians': 13,
    'Galatians': 6,
    'Ephesians': 6,
    'Philippians': 4,
    'Colossians': 4,
    '1 Thessalonians': 5,
    '2 Thessalonians': 3,
    '1 Timothy': 6,
    '2 Timothy': 4,
    'Titus': 3,
    'Philemon': 1,
    'Hebrews': 13,
    'James': 5,
    '1 Peter': 5,
    '2 Peter': 3,
    '1 John': 5,
    '2 John': 1,
    '3 John': 1,
    'Jude': 1,
    'Revelation': 22,
  };

  final Map<String, Map<String, String>> localizedBookNames = {
    'KJV': {},
    'WEB': {},
    'BSB': {},
    'ASV': {},
    'OG': {
      'Genesis': 'KĨAMBĨRĨRIA',
    },
  };

  String selectedVersion = 'KJV';
  String selectedBook = 'Genesis';
  int selectedChapter = 1;
  int selectedVerse = 1;

  double readingFontSize = 22;
  String readingFontFamily = 'Georgia';

  bool _isLoadingPreferences = true;

  int get chapterCount => books[selectedBook] ?? 1;

  String bookNameFor(String englishBook) {
    return localizedBookNames[selectedVersion]?[englishBook] ??
        englishBook;
  }

  Map<int, String> get currentChapterVerses {
    return bibleVersions[selectedVersion]?[selectedBook]
            ?[selectedChapter] ??
        <int, String>{};
  }

  // Use the actual verse numbers present in the Bible data.
  List<int> get availableVerseNumbers {
    final numbers = currentChapterVerses.keys.toList()..sort();
    return numbers;
  }

  String _verseKey(int verse) {
    return '$selectedVersion|$selectedBook|$selectedChapter|$verse';
  }

  GlobalKey _keyForVerse(int verse) {
    return _verseKeys.putIfAbsent(
      _verseKey(verse),
      () => GlobalKey(),
    );
  }

  int _firstAvailableVerseFor(
    String version,
    String book,
    int chapter,
  ) {
    final verses =
        bibleVersions[version]?[book]?[chapter] ?? <int, String>{};

    if (verses.isEmpty) return 1;

    final numbers = verses.keys.toList()..sort();
    return numbers.first;
  }

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  @override
  void dispose() {
    _bibleScrollController.dispose();
    super.dispose();
  }

  Future<void> _loadPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final savedBook = prefs.getString('bible_book') ?? 'Genesis';
      final savedVersion = prefs.getString('bible_version') ?? 'KJV';
      final savedChapter = prefs.getInt('bible_chapter') ?? 1;
      final savedVerse = prefs.getInt('bible_verse') ?? 1;
      final savedFontSize = prefs.getDouble('bible_font_size') ?? 22;
      final savedFontFamily =
          prefs.getString('bible_font_family') ?? 'Georgia';

      if (!mounted) return;

      final validBook =
          books.containsKey(savedBook) ? savedBook : 'Genesis';

      final validVersion =
          versions.contains(savedVersion) ? savedVersion : 'KJV';

      final maxChapter = books[validBook] ?? 1;

      final validChapter =
          savedChapter >= 1 && savedChapter <= maxChapter
              ? savedChapter
              : 1;

      final verses = bibleVersions[validVersion]?[validBook]
              ?[validChapter] ??
          <int, String>{};

      final validVerse = verses.containsKey(savedVerse)
          ? savedVerse
          : _firstAvailableVerseFor(
              validVersion,
              validBook,
              validChapter,
            );

      setState(() {
        selectedBook = validBook;
        selectedVersion = validVersion;
        selectedChapter = validChapter;
        selectedVerse = validVerse;

        readingFontSize =
            savedFontSize.clamp(14.0, 34.0).toDouble();

        readingFontFamily = savedFontFamily;
      });
    } catch (error) {
      debugPrint('Could not load Bible preferences: $error');
    } finally {
      if (mounted) {
        setState(() => _isLoadingPreferences = false);

        _scrollToVerse(selectedVerse);
      }
    }
  }

  Future<void> _savePreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setString('bible_book', selectedBook);
      await prefs.setString('bible_version', selectedVersion);
      await prefs.setInt('bible_chapter', selectedChapter);
      await prefs.setInt('bible_verse', selectedVerse);
      await prefs.setDouble('bible_font_size', readingFontSize);
      await prefs.setString('bible_font_family', readingFontFamily);
    } catch (error) {
      debugPrint('Could not save Bible preferences: $error');
    }
  }

  // The SingleChildScrollView builds all verse widgets, so the target
  // GlobalKey can be found even when the verse is far down the chapter.
  void _scrollToVerse(int verse, {int attempt = 0}) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;

      final targetContext = _verseKeys[_verseKey(verse)]?.currentContext;

      if (targetContext == null) {
        if (attempt < 3) {
          _scrollToVerse(verse, attempt: attempt + 1);
        } else {
          debugPrint(
            'Could not find $selectedBook '
            '$selectedChapter:$verse ($selectedVersion). '
            'Check bible_content.dart for this verse.',
          );
        }
        return;
      }

      await Scrollable.ensureVisible(
        targetContext,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
        alignment: 0.12,
        alignmentPolicy: ScrollPositionAlignmentPolicy.explicit,
      );
    });
  }

  void _selectBook(String value) {
    final firstVerse =
        _firstAvailableVerseFor(selectedVersion, value, 1);

    setState(() {
      selectedBook = value;
      selectedChapter = 1;
      selectedVerse = firstVerse;
    });

    _savePreferences();
    _scrollToVerse(firstVerse);
  }

  void _selectVersion(String value) {
    final firstVerse =
        _firstAvailableVerseFor(value, selectedBook, 1);

    setState(() {
      selectedVersion = value;
      selectedChapter = 1;
      selectedVerse = firstVerse;
    });

    _savePreferences();
    _scrollToVerse(firstVerse);
  }

  void _selectChapter(int value) {
    final firstVerse = _firstAvailableVerseFor(
      selectedVersion,
      selectedBook,
      value,
    );

    setState(() {
      selectedChapter = value;
      selectedVerse = firstVerse;
    });

    _savePreferences();
    _scrollToVerse(firstVerse);
  }

  void _selectVerse(int value) {
    if (!currentChapterVerses.containsKey(value)) {
      debugPrint(
        'Verse $value is missing from '
        '$selectedBook $selectedChapter ($selectedVersion).',
      );
      return;
    }

    setState(() {
      selectedVerse = value;
    });

    _savePreferences();
    _scrollToVerse(value);
  }

  void _goToChapter(int chapter) {
    if (chapter < 1 || chapter > chapterCount) return;
    _selectChapter(chapter);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingPreferences) {
      return const Scaffold(
        backgroundColor: background,
        body: Center(
          child: CircularProgressIndicator(color: purple),
        ),
      );
    }

    final verses = currentChapterVerses;
    final verseNumbers = availableVerseNumbers;

    final dropdownVerse = verseNumbers.contains(selectedVerse)
        ? selectedVerse
        : (verseNumbers.isNotEmpty ? verseNumbers.first : 1);

    // IMPORTANT: sort entries before mapping them to Widgets.
    // Do not cascade .sort() and .map() onto the spread expression.
    final sortedVerses = verses.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        foregroundColor: white,
        elevation: 0,
        title: const Text(
          'HOLY WORD',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            letterSpacing: 2,
            fontSize: 17,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Search Bible',
            onPressed: _showSearchDialog,
            icon: const Icon(Icons.search),
          ),
          IconButton(
            tooltip: 'Reading settings',
            onPressed: _showSettingsDialog,
            icon: const Icon(Icons.settings_outlined),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: _selector<String>(
                      label: 'BOOK',
                      value: selectedBook,
                      items: books.keys.toList(),
                      displayText: bookNameFor,
                      onChanged: (value) {
                        if (value != null) _selectBook(value);
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: _selector<String>(
                      label: 'VERSION',
                      value: selectedVersion,
                      items: versions,
                      onChanged: (value) {
                        if (value != null) _selectVersion(value);
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: _selector<int>(
                      label: 'CHAPTER',
                      value: selectedChapter,
                      items: List.generate(
                        chapterCount,
                        (index) => index + 1,
                      ),
                      onChanged: (value) {
                        if (value != null) _selectChapter(value);
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _selector<int>(
                      label: 'VERSE',
                      value: dropdownVerse,
                      items: verseNumbers.isEmpty ? [1] : verseNumbers,
                      onChanged: (value) {
                        if (value != null) _selectVerse(value);
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              bookNameFor(selectedBook),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: muted,
                fontFamily: 'Georgia',
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '$selectedChapter',
              style: const TextStyle(
                color: white,
                fontFamily: 'Georgia',
                fontSize: 70,
                fontWeight: FontWeight.bold,
                height: 1.15,
              ),
            ),
            const SizedBox(height: 18),
            Expanded(
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: panel,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.06),
                  ),
                ),

                // Use a SingleChildScrollView with a Column instead of
                // ListView so all verse GlobalKeys have contexts.
                child: SingleChildScrollView(
                  controller: _bibleScrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 4,
                            height: 25,
                            decoration: BoxDecoration(
                              color: gold,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              '${bookNameFor(selectedBook)} $selectedChapter',
                              style: const TextStyle(
                                color: gold,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: purple.withOpacity(0.18),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              selectedVersion,
                              style: const TextStyle(
                                color: purple,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      if (verses.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(16),
                          child: Text(
                            'No verses have been added for this chapter yet.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: muted,
                              fontSize: 16,
                            ),
                          ),
                        )
                      else
                        ...sortedVerses.map<Widget>((entry) {
                          final verseNumber = entry.key;
                          final isSelected =
                              verseNumber == selectedVerse;
                          final verseKey = _keyForVerse(verseNumber);

                          return Padding(
                            key: verseKey,
                            padding: const EdgeInsets.only(bottom: 16),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(10),
                              onTap: () => _selectVerse(verseNumber),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? purple.withOpacity(0.12)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(10),
                                  border: isSelected
                                      ? Border.all(
                                          color: purple.withOpacity(0.4),
                                        )
                                      : null,
                                ),
                                child: Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 30,
                                      height: 30,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? purple
                                            : purple.withOpacity(0.18),
                                        borderRadius:
                                            BorderRadius.circular(9),
                                      ),
                                      child: Text(
                                        '$verseNumber',
                                        style: TextStyle(
                                          color:
                                              isSelected ? white : purple,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        entry.value,
                                        style: TextStyle(
                                          color: white,
                                          fontFamily: readingFontFamily,
                                          fontSize: readingFontSize,
                                          height: 1.8,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: selectedChapter > 1
                                  ? () => _goToChapter(
                                      selectedChapter - 1,
                                    )
                                  : null,
                              icon: const Icon(Icons.chevron_left),
                              label: const Text('Previous chapter'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: white,
                                side: const BorderSide(color: purple),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: FilledButton.icon(
                              onPressed: selectedChapter < chapterCount
                                  ? () => _goToChapter(
                                      selectedChapter + 1,
                                    )
                                  : null,
                              icon: const Icon(Icons.chevron_right),
                              label: const Text('Next chapter'),
                              style: FilledButton.styleFrom(
                                backgroundColor: purple,
                                foregroundColor: white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Center(
                        child: Text(
                          'Read • Reflect • Grow',
                          style: TextStyle(
                            color: muted,
                            fontStyle: FontStyle.italic,
                            fontFamily: 'Georgia',
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showSearchDialog() async {
    final searchController = TextEditingController();
    String query = '';

    try {
      await showDialog<void>(
        context: context,
        builder: (dialogContext) {
          return StatefulBuilder(
            builder: (context, setDialogState) {
              final versionContent =
                  bibleVersions[selectedVersion] ?? {};

              final results = <Map<String, dynamic>>[];
              final normalizedQuery = query.trim().toLowerCase();

              if (normalizedQuery.isNotEmpty) {
                for (final bookEntry in versionContent.entries) {
                  for (final chapterEntry
                      in bookEntry.value.entries) {
                    for (final verseEntry
                        in chapterEntry.value.entries) {
                      if (verseEntry.value
                          .toLowerCase()
                          .contains(normalizedQuery)) {
                        results.add({
                          'book': bookEntry.key,
                          'chapter': chapterEntry.key,
                          'verse': verseEntry.key,
                          'text': verseEntry.value,
                        });
                      }
                    }
                  }
                }
              }

              return AlertDialog(
                backgroundColor: panel,
                title: const Text(
                  'Search the Bible',
                  style: TextStyle(color: white),
                ),
                content: SizedBox(
                  width: 500,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: searchController,
                        autofocus: true,
                        style: const TextStyle(color: white),
                        decoration: InputDecoration(
                          hintText: 'Enter a word or phrase',
                          hintStyle: const TextStyle(color: muted),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: purple,
                          ),
                          filled: true,
                          fillColor: const Color(0xFF242638),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onChanged: (value) {
                          setDialogState(() => query = value);
                        },
                      ),
                      const SizedBox(height: 12),
                      if (normalizedQuery.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(16),
                          child: Text(
                            'Search within the verses available for the selected version.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: muted),
                          ),
                        )
                      else if (results.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(16),
                          child: Text(
                            'No matching verses found in the available content.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: muted),
                          ),
                        )
                      else
                        SizedBox(
                          height: 320,
                          child: ListView.separated(
                            shrinkWrap: true,
                            itemCount: results.length,
                            separatorBuilder: (_, __) =>
                                const Divider(
                              color: Color(0xFF34364B),
                            ),
                            itemBuilder: (context, index) {
                              final result = results[index];
                              final resultBook =
                                  result['book'] as String;
                              final resultChapter =
                                  result['chapter'] as int;
                              final resultVerse =
                                  result['verse'] as int;

                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  '${bookNameFor(resultBook)} '
                                  '$resultChapter:$resultVerse',
                                  style: const TextStyle(
                                    color: gold,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  result['text'] as String,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(color: white),
                                ),
                                onTap: () {
                                  setState(() {
                                    selectedBook = resultBook;
                                    selectedChapter = resultChapter;
                                    selectedVerse = resultVerse;
                                  });

                                  _savePreferences();

                                  Navigator.of(dialogContext).pop();

                                  _scrollToVerse(resultVerse);
                                },
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () =>
                        Navigator.of(dialogContext).pop(),
                    child: const Text(
                      'Close',
                      style: TextStyle(color: purple),
                    ),
                  ),
                ],
              );
            },
          );
        },
      );
    } finally {
      searchController.dispose();
    }
  }

  Future<void> _showSettingsDialog() async {
    double temporaryFontSize = readingFontSize;
    String temporaryFontFamily = readingFontFamily;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: panel,
              title: const Text(
                'Reading settings',
                style: TextStyle(color: white),
              ),
              content: SizedBox(
                width: 360,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Text size',
                      style: TextStyle(
                        color: gold,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.text_fields,
                          color: muted,
                        ),
                        Expanded(
                          child: Slider(
                            value: temporaryFontSize,
                            min: 14,
                            max: 34,
                            divisions: 10,
                            activeColor: purple,
                            label:
                                temporaryFontSize.round().toString(),
                            onChanged: (value) {
                              setDialogState(() {
                                temporaryFontSize = value;
                              });
                            },
                          ),
                        ),
                        Text(
                          temporaryFontSize.round().toString(),
                          style: const TextStyle(color: white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Reading font',
                      style: TextStyle(
                        color: gold,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: temporaryFontFamily,
                      dropdownColor: const Color(0xFF242638),
                      style: const TextStyle(color: white),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFF242638),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'Georgia',
                          child: Text('Georgia'),
                        ),
                        DropdownMenuItem(
                          value: 'Roboto',
                          child: Text('Roboto'),
                        ),
                        DropdownMenuItem(
                          value: 'serif',
                          child: Text('Serif'),
                        ),
                        DropdownMenuItem(
                          value: 'sans-serif',
                          child: Text('Sans serif'),
                        ),
                        DropdownMenuItem(
                          value: 'arial black',
                          child: Text('Arial black'),
                        ),
                        DropdownMenuItem(
                          value: 'Algerian',
                          child: Text('Algerian'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() {
                            temporaryFontFamily = value;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Sample scripture text',
                      style: TextStyle(
                        color: white,
                        fontFamily: temporaryFontFamily,
                        fontSize: temporaryFontSize,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () =>
                      Navigator.of(dialogContext).pop(),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: muted),
                  ),
                ),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: purple,
                  ),
                  onPressed: () {
                    setState(() {
                      readingFontSize = temporaryFontSize;
                      readingFontFamily = temporaryFontFamily;
                    });

                    _savePreferences();
                    Navigator.of(dialogContext).pop();
                  },
                  child: const Text('Apply settings'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _selector<T>({
    required String label,
    required T value,
    required List<T> items,
    required ValueChanged<T?> onChanged,
    String Function(T item)? displayText,
  }) {
    final safeItems =
        items.contains(value) ? items : <T>[...items, value];

    return DropdownButtonFormField<T>(
      value: value,
      isExpanded: true,
      dropdownColor: const Color(0xFF242638),
      icon: const Icon(
        Icons.keyboard_arrow_down,
        color: purple,
      ),
      style: const TextStyle(
        color: white,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: purple,
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
        filled: true,
        fillColor: panel,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Color(0xFF34364B),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: purple,
            width: 1.5,
          ),
        ),
      ),
      items: safeItems.map((item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Text(
            displayText != null ? displayText(item) : '$item',
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
