
class Hymn {
  final int number;
  final String title;
  final String author;
  final String languageCode;
  final List<String> verses;

  const Hymn({
    required this.number,
    required this.title,
    required this.author,
    required this.languageCode,
    required this.verses,
  });
}

const Map<String, String> hymnLanguages = {
  'en': 'English',
  'sw': 'Kiswahili',
  'ki': 'Gĩkũyũ (Kikuyu)',
};

const List<Hymn> hymns = [
  Hymn(
    number: 1,
    title: 'Amazing Grace',
    author: 'John Newton',
    languageCode: 'en',
    verses: [
      'Amazing grace! How sweet the sound, '
          'That saved a wretch like me!',
      'I once was lost, but now am found, '
          'Was blind, but now I see.',
      'Through many dangers, toils and snares, '
          'I have already come;',
      'Tis grace hath brought me safe thus far, '
          'And grace will lead me home.',
    ],
  ),

  Hymn(
    number: 1,
    title: 'Wimbo wa mfano',
    author: 'Ongeza jina la mtunzi',
    languageCode: 'sw',
    verses: [
      'Ongeza maneno ya ubeti wa kwanza hapa.',
      'Ongeza maneno ya ubeti wa pili hapa.',
    ],
  ),

  Hymn(
    number: 1,
    title: 'Wĩmbo wa gĩthomo',
    author: 'Andika jina rĩa mwandĩki',
    languageCode: 'ki',
    verses: [
      'Andika maneno ma wĩmbo wa mbere haha.',
    ],
  ),
];
