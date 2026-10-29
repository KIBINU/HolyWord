
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/bible_content.dart';
import 'theme_controller.dart';

class BibleSelector extends StatefulWidget {
  const BibleSelector({super.key});

  @override
  State<BibleSelector> createState() => _BibleSelectorState();
}

class _BibleSelectorState extends State<BibleSelector> {
  static const Color purple = Color(0xFF8B78F6);
  static const Color gold = Color(0xFFE7C77A);

  final ScrollController _bibleScrollController = ScrollController();
  final Map<String, GlobalKey> _verseKeys = {};

  final List<String> versions = const ['KJV', 'NIV', 'CSB','OG'];

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
    'NIV': {},
    'CSB': {},
    'OG': {
    'Genesis': 'KĨAMBĨRĨRIA',
    'Exodus': 'THAMA',
    'Leviticus': 'MAŨNDŨ MA ALAWII',
    'Numbers': 'NDARI',
    'Deuteronomy': 'GŨCOKERITHIA MAATHANI',
    'Joshua': 'IBUKU RĨA JOSHUA',
    'Judges': 'IBUKU RĨA ATIIRĨRĨRI BŨRŨRI',
    'Ruth': 'IBUKU RĨA RUTHU',
    '1 Samuel': '1 SAMUELI',
    '2 Samuel': '2 SAMUELI',
    '1 Kings': '1 ATHAMAKI',
    '2 Kings': '2 ATHAMAKI',
    '1 Chronicles': '1 MAŨNDŨ MA MATUKŨ MA TENE',
    '2 Chronicles': '2 MAŨNDŨ MA MATUKŨ MA TENE',
    'Ezra': 'IBUKU RĨA EZARA',
    'Nehemiah': 'IBUKU RĨA NEHEMIA',
    'Esther': 'IBUKU RĨA ESITERI',
    'Job': 'IBUKU RĨA AYUBU',
    'Psalms': 'THABURI',
    'Proverbs': 'THIMO',
    'Ecclesiastes': 'KOHELETHU',
    'Song of Solomon': 'RŨĨMBO RŨA SULEIMANI',
    'Isaiah': 'ISAIA',
    'Jeremiah': 'JEREMIA',
    'Lamentations': 'MACAKAYA',
    'Ezekiel': 'EZEKIELI',
    'Daniel': 'IBUKU RĨA DANIELI',
    'Hosea': 'HOSEA',
    'Joel': 'JOELI',
    'Amos': 'AMOSI',
    'Obadiah': 'OBADIA',
    'Jonah': 'JONA',
    'Micah': 'MIKA',
    'Nahum': 'NAHUMU',
    'Habakkuk': 'HABAKUKU',
    'Zephaniah': 'ZEFANIA',
    'Haggai': 'HAGAI',
    'Zechariah': 'ZEKARIA',
    'Malachi': 'MALAKI',
    'Matthew': 'MATHAYO',
    'Mark': 'MARIKO',
    'Luke': 'LUKA',
    'John': 'JOHANA',
    'Acts': 'ATŨMIO',
    'Romans': 'AROMA',
    '1 Corinthians': '1 AKORINTHO',
    '2 Corinthians': '2 AKORINTHO',
    'Galatians': 'AGALATIA',
    'Ephesians': 'AEFESO',
    'Philippians': 'AFILIPI',
    'Colossians': 'AKOLOSAI',
    '1 Thessalonians': '1 ATHESALONIKE',
    '2 Thessalonians': '2 ATHESALONIKE',
    '1 Timothy': '1 TIMOTHEO',
    '2 Timothy': '2 TIMOTHEO',
    'Titus': 'TITO',
    'Philemon': 'FILEMONA',
    'Hebrews': 'AHIBIRANIA',
    'James': 'JAKUBU',
    '1 Peter': '1 PETERO',
    '2 Peter': '2 PETERO',
    '1 John': '1 JOHANA',
    '2 John': '2 JOHANA',
    '3 John': '3 JOHANA',
    'Jude': 'JUDASI',
    'Revelation': 'KŨGUŨRĨRIO',
},

  };

  String selectedVersion = 'KJV';
  String selectedBook = 'Genesis';
  int selectedChapter = 1;
  int selectedVerse = 1;

  double readingFontSize = 22;
  String readingFontFamily = 'Georgia';

  bool _isLoadingPreferences = true;
  bool _showSelectors = true;
  bool _showChapterHeading = true;

  int get chapterCount => books[selectedBook] ?? 1;

  String bookNameFor(String englishBook) {
    return localizedBookNames[selectedVersion]?[englishBook] ??
        englishBook;
  }

  Map<int, String> get currentChapterVerses {
    return bibleVersions[selectedVersion]?[selectedBook]?[selectedChapter] ??
        <int, String>{};
  }

  List<int> get availableVerseNumbers {
    final numbers = currentChapterVerses.keys.toList()..sort();
    return numbers;
  }

  String _verseKey(int verse) {
    return '$selectedVersion|$selectedBook|$selectedChapter|$verse';
  }

  GlobalKey _keyForVerse(int verse) {
    return _verseKeys.putIfAbsent(_verseKey(verse), () => GlobalKey());
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

  // Hide selectors when scrolling down and show them when scrolling up.
  bool _handleScrollNotification(UserScrollNotification notification) {
    if (notification.direction == ScrollDirection.reverse) {
      if (_showSelectors || _showChapterHeading) {
        setState(() {
          _showSelectors = false;
          _showChapterHeading = false;
        });
      }
    } else if (notification.direction == ScrollDirection.forward) {
      if (!_showSelectors || !_showChapterHeading) {
        setState(() {
          _showSelectors = true;
          _showChapterHeading = true;
        });
      }
    }

    return false;
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

      final validBook = books.containsKey(savedBook) ? savedBook : 'Genesis';
      final validVersion =
          versions.contains(savedVersion) ? savedVersion : 'KJV';

      final maxChapter = books[validBook] ?? 1;

      final validChapter =
          savedChapter >= 1 && savedChapter <= maxChapter
              ? savedChapter
              : 1;

      final verses =
          bibleVersions[validVersion]?[validBook]?[validChapter] ??
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
        readingFontSize = savedFontSize.clamp(14.0, 34.0).toDouble();
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

  void _scrollToVerse(int verse, {int attempt = 0}) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;

      final targetContext = _verseKeys[_verseKey(verse)]?.currentContext;

      if (targetContext == null) {
        if (attempt < 3) {
          _scrollToVerse(verse, attempt: attempt + 1);
        }
        return;
      }

      await Scrollable.ensureVisible(
        targetContext,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        alignment: 0.12,
      );
    });
  }

  void _selectBook(String value) {
    final firstVerse = _firstAvailableVerseFor(
      selectedVersion,
      value,
      1,
    );

    setState(() {
      selectedBook = value;
      selectedChapter = 1;
      selectedVerse = firstVerse;
      _showSelectors = true;
      _showChapterHeading = true;
    });

    _savePreferences();
    _scrollToVerse(firstVerse);
  }

  void _selectVersion(String value) {
    final firstVerse = _firstAvailableVerseFor(
      value,
      selectedBook,
      1,
    );

    setState(() {
      selectedVersion = value;
      selectedChapter = 1;
      selectedVerse = firstVerse;
      _showSelectors = true;
      _showChapterHeading = true;
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
      _showSelectors = true;
      _showChapterHeading = true;
    });

    _savePreferences();
    _scrollToVerse(firstVerse);
  }

  void _selectVerse(int value) {
    if (!currentChapterVerses.containsKey(value)) return;

    setState(() {
      selectedVerse = value;
      _showSelectors = true;
      _showChapterHeading = true;
    });

    _savePreferences();
    _scrollToVerse(value);
  }

  void _goToChapter(int chapter) {
    if (chapter >= 1 && chapter <= chapterCount) {
      _selectChapter(chapter);
    }
  }

  // --------------------------------------------------
  // BIBLE SEARCH
  // --------------------------------------------------

  Future<void> _showSearchDialog() async {
    final controller = TextEditingController();
    final colors = Theme.of(context).colorScheme;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final query = controller.text.trim().toLowerCase();

            final results = <Map<String, dynamic>>[];

            if (query.isNotEmpty) {
              for (final bookEntry in books.entries) {
                final book = bookEntry.key;
                final chapters = bibleVersions[selectedVersion]?[book];

                if (chapters == null) continue;

                for (final chapterEntry in chapters.entries) {
                  for (final verseEntry in chapterEntry.value.entries) {
                    final verseText = verseEntry.value;

                    final matchesBook = book.toLowerCase().contains(query);
                    final matchesText =
                        verseText.toLowerCase().contains(query);

                    if (matchesBook || matchesText) {
                      results.add({
                        'book': book,
                        'chapter': chapterEntry.key,
                        'verse': verseEntry.key,
                        'text': verseText,
                      });

                      if (results.length >= 50) break;
                    }
                  }

                  if (results.length >= 50) break;
                }

                if (results.length >= 50) break;
              }
            }

            return AlertDialog(
              backgroundColor: colors.surface,
              title: const Text('Search the Bible'),
              content: SizedBox(
                width: 450,
                height: 420,
                child: Column(
                  children: [
                    TextField(
                      controller: controller,
                      autofocus: true,
                      onChanged: (_) => setDialogState(() {}),
                      decoration: InputDecoration(
                        hintText: 'Enter a word or book name',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: query.isEmpty
                          ? Center(
                              child: Text(
                                'Search within the selected Bible version.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: colors.onSurfaceVariant,
                                ),
                              ),
                            )
                          : results.isEmpty
                              ? const Center(
                                  child: Text('No results found.'),
                                )
                              : ListView.builder(
                                  itemCount: results.length,
                                  itemBuilder: (context, index) {
                                    final result = results[index];

                                    return ListTile(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 0,
                                        vertical: 3,
                                      ),
                                      title: Text(
                                        '${result['book']} '
                                        '${result['chapter']}:'
                                        '${result['verse']}',
                                        style: const TextStyle(
                                          color: purple,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Text(
                                        result['text'] as String,
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      onTap: () {
                                        final book =
                                            result['book'] as String;
                                        final chapter =
                                            result['chapter'] as int;
                                        final verse =
                                            result['verse'] as int;

                                        Navigator.pop(dialogContext);

                                        setState(() {
                                          selectedBook = book;
                                          selectedChapter = chapter;
                                          selectedVerse = verse;
                                          _showSelectors = true;
                                          _showChapterHeading = true;
                                        });

                                        _savePreferences();

                                        WidgetsBinding.instance
                                            .addPostFrameCallback((_) {
                                          if (mounted) {
                                            _scrollToVerse(verse);
                                          }
                                        });
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
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
      },
    );

    controller.dispose();
  }

  // --------------------------------------------------
  // READING SETTINGS
  // --------------------------------------------------

  Future<void> _showSettingsDialog() async {
    double tempFontSize = readingFontSize;
    String tempFontFamily = readingFontFamily;

    const fonts = ['Georgia', 'Roboto', 'Serif', 'Monospace'];

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final colors = Theme.of(context).colorScheme;

            return AlertDialog(
              backgroundColor: colors.surface,
              title: const Text('Reading settings'),
              content: SizedBox(
                width: 350,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Font size',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        const Text('A'),
                        Expanded(
                          child: Slider(
                            value: tempFontSize,
                            min: 14,
                            max: 34,
                            divisions: 20,
                            activeColor: purple,
                            label: tempFontSize.round().toString(),
                            onChanged: (value) {
                              setDialogState(() {
                                tempFontSize = value;
                              });
                            },
                          ),
                        ),
                        const Text(
                          'A',
                          style: TextStyle(fontSize: 24),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Font family',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      initialValue: fonts.contains(tempFontFamily)
                          ? tempFontFamily
                          : 'Georgia',
                      isExpanded: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      items: fonts.map((font) {
                        return DropdownMenuItem<String>(
                          value: font,
                          child: Text(
                            font,
                            style: TextStyle(fontFamily: font),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() {
                            tempFontFamily = value;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: Text(
                        'Sample Bible text',
                        style: TextStyle(
                          fontSize: tempFontSize,
                          fontFamily: tempFontFamily,
                          height: 1.6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: purple,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      readingFontSize = tempFontSize;
                      readingFontFamily = tempFontFamily;
                    });

                    _savePreferences();
                    Navigator.pop(dialogContext);
                  },
                  child: const Text('Apply'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // --------------------------------------------------
  // REUSABLE DROPDOWN SELECTOR
  // --------------------------------------------------

  Widget _selector<T>({
    required String label,
    required T value,
    required List<T> items,
    String Function(T)? displayText,
    required ValueChanged<T?> onChanged,
  }) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 6),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              color: colors.onSurfaceVariant,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: colors.surfaceContainerHighest.withValues(alpha: 0.45),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: colors.outlineVariant.withValues(alpha: 0.5),
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: items.contains(value) ? value : null,
              isExpanded: true,
              isDense: true,
              dropdownColor: colors.surface,
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: purple,
              ),
              style: TextStyle(
                color: colors.onSurface,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              items: items.map((item) {
                return DropdownMenuItem<T>(
                  value: item,
                  child: Text(
                    displayText != null
                        ? displayText(item)
                        : item.toString(),
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  // --------------------------------------------------
  // MAIN SCREEN
  // --------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final background = theme.scaffoldBackgroundColor;
    final panel = colors.surface;
    final primaryText = colors.onSurface;
    final mutedText = colors.onSurfaceVariant;

    if (_isLoadingPreferences) {
      return Scaffold(
        backgroundColor: background,
        body: Center(
          child: CircularProgressIndicator(color: colors.primary),
        ),
      );
    }

    final verses = currentChapterVerses;
    final verseNumbers = availableVerseNumbers;

    final dropdownVerse = verseNumbers.contains(selectedVerse)
        ? selectedVerse
        : (verseNumbers.isNotEmpty ? verseNumbers.first : 1);

    final sortedVerses = verses.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        foregroundColor: primaryText,
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
          AnimatedBuilder(
            animation: themeController,
            builder: (context, child) {
              return Transform.scale(
                scale: 0.8,
                child: Switch.adaptive(
                  value: themeController.isDarkMode,
                  activeTrackColor: purple,
                  onChanged: (value) {
                    themeController.setDarkMode(value);
                  },
                ),
              );
            },
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
            // BOOK, VERSION, CHAPTER AND VERSE SELECTORS
            ClipRect(
              child: AnimatedSize(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                alignment: Alignment.topCenter,
                child: _showSelectors
                    ? Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: _selector<String>(
                                    label: 'BOOK',
                                    value: selectedBook,
                                    items: books.keys.toList(),
                                    displayText: bookNameFor,
                                    onChanged: (value) {
                                      if (value != null) {
                                        _selectBook(value);
                                      }
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
                                      if (value != null) {
                                        _selectVersion(value);
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
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
                                      if (value != null) {
                                        _selectChapter(value);
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: _selector<int>(
                                    label: 'VERSE',
                                    value: dropdownVerse,
                                    items: verseNumbers.isEmpty
                                        ? [1]
                                        : verseNumbers,
                                    onChanged: (value) {
                                      if (value != null) {
                                        _selectVerse(value);
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    : const SizedBox(width: double.infinity),
              ),
            ),

            // LARGE BOOK AND CHAPTER HEADING
            ClipRect(
              child: AnimatedSize(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                alignment: Alignment.topCenter,
                child: _showChapterHeading
                    ? Padding(
                        padding: const EdgeInsets.only(
                          top: 12,
                          bottom: 16,
                        ),
                        child: Column(
                          children: [
                            Text(
                              bookNameFor(selectedBook),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: mutedText,
                                fontFamily: 'Georgia',
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '$selectedChapter',
                              style: TextStyle(
                                color: primaryText,
                                fontFamily: 'Georgia',
                                fontSize: 70,
                                fontWeight: FontWeight.bold,
                                height: 1.15,
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox(width: double.infinity),
              ),
            ),

            // BIBLE READING PANEL
            Expanded(
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(12, 4, 12, 12),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: panel,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: colors.outlineVariant.withValues(alpha: 0.35),
                  ),
                ),
                child: NotificationListener<UserScrollNotification>(
                  onNotification: _handleScrollNotification,
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
                                '${bookNameFor(selectedBook)} '
                                '$selectedChapter',
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
                                color: purple.withValues(alpha: 0.18),
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
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              'No verses have been added for this chapter yet.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: mutedText,
                                fontSize: 16,
                              ),
                            ),
                          )
                        else
                          ...sortedVerses.map<Widget>((entry) {
                            final verseNumber = entry.key;
                            final isSelected =
                                verseNumber == selectedVerse;

                            return Padding(
                              key: _keyForVerse(verseNumber),
                              padding: const EdgeInsets.only(bottom: 16),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(10),
                                onTap: () => _selectVerse(verseNumber),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? purple.withValues(alpha: 0.12)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(10),
                                    border: isSelected
                                        ? Border.all(
                                            color: purple.withValues(
                                              alpha: 0.4,
                                            ),
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
                                              : purple.withValues(
                                                  alpha: 0.18,
                                                ),
                                          borderRadius:
                                              BorderRadius.circular(9),
                                        ),
                                        child: Text(
                                          '$verseNumber',
                                          style: TextStyle(
                                            color: isSelected
                                                ? Colors.white
                                                : purple,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          entry.value,
                                          style: TextStyle(
                                            color: primaryText,
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

                        // PREVIOUS AND NEXT CHAPTER
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
                                  foregroundColor: primaryText,
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
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: Text(
                            'Read • Reflect • Grow',
                            style: TextStyle(
                              color: mutedText,
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
            ),
          ],
        ),
      ),
    );
  }
}
