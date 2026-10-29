
class Hymn {
  final int number;
  final String title;
  final String languageCode;

  // List of verses
  final List<String> verses;

  // Optional chorus (refrain)
  final String? chorus;

  const Hymn({
    required this.number,
    required this.title,
    required this.languageCode,
    required this.verses,
    this.chorus,
  });
}

const Map<String, String> hymnLanguages = {
  'en': 'English',
  'sw': 'Kiswahili',
  'ki': 'Gĩkũyũ (Kikuyu)',
};

const List<Hymn> hymns = [
  // ---------------- ENGLISH HYMN ----------------
  Hymn(
    number: 1,
    title: 'Amazing Grace',
    languageCode: 'en',

    verses: [
      'Amazing grace! How sweet the sound,'
          'That saved a wretch like me!',

      'I once was lost, but now am found,'
          'Was blind, but now I see.',

      'Through many dangers, toils and snares,'
          'I have already come;',

      'Tis grace hath brought me safe thus far,'
          'And grace will lead me home.',
    ],

    chorus: null,
  ),

  // ---------------- KISWAHILI HYMN ----------------
  Hymn(
    number: 1,
    title: 'Wimbo wa mfano',
    languageCode: 'sw',

    verses: [
      'Ongeza maneno ya ubeti wa kwanza hapa.',
      'Ongeza maneno ya ubeti wa pili hapa.',
    ],

    chorus: 'Ongeza maneno ya kiitikio hapa.',
  ),

  // ---------------- GĨKŨYŨ HYMN ----------------
  Hymn(
    number: 2,
    title: 'HE NYUMBA NJEGA THIINI WA ANDU',
    languageCode: 'ki',

   verses: [
      'He nyumba njega thiini wa andu'
          'No ndiari njega ria mbere;'
          'Niho Roho Mutheru aikaraga'
          'A’hotithagie kuhoya',

      ' Muthenya wa kiumia ni m wega;'
          'Ngengere igitana'
          'Njukire na andu akwa othe,'
          'Tukahoe na tugathe Ngai',

      ' Kuri na miitano miingi'
          'ya andu a Caitani,'
          'no uria wa gututwara wega.'
          'ni uria wa gutuonania na Ngai.',

      ' Ni mutharabaini wa Jesu'
          'Ndatwarire murigo wakwa'
          'Wa’thinite ngoro o na mwiri;'
          'Na ngiheomuoyo wa tene.',
    ],
    chorus:'Ukai tuthii tumuggathe'
           'Ngai witu nyumbaini yake,'
           'Ngoro yakwa niikenaga muno'
           'Ni ungano wa andu a Ngai',
  ),
  
  Hymn(
    number: 3,
    title: 'JEHOVA NIWE UTHERI WAKWA',
    languageCode: 'ki',

   verses: [
'Jehova niwe utheri wakwa, Ingitigira u, Jesu e ho? Na hinya wa muoyo wakwa nowe: Uria ungmakia ni, Jesu ho?',
'Riria ndokiriruo ni eki nai Ni getha mandie nyama cia mwiri Thu ciakwa na aria mari na uramu Maatenderukire makigua thi',
'Ita ingijakiriria iraaro Ndingiigua guoya, Jesu ari ho mbaara Ndingiigia nganja, Jesu ari ho',
'Ndi undu umwe nyendete he Ngai Niguo thingataga hingo ciothe; Njikarage hekaruini yake Ndiyonagire uthaka wake.',
'Nyonagiria njira yaku, Ngai Undware na iria njaraganu; Ngie na hinya ndiyumiririe Ngwetagirire wee Jehova Ngai',
    ],
    chorus: null,
  ),

  Hymn(
    number: 5,
    title: 'NITUCEMANITIE',
    languageCode: 'ki',

 verses: [
'Nitucemanitie Guku nyumba yaku; Ugomane na ithui, Mwathani Ngai witu.',
'Tutonyete niki Haha mbere yaku? Ni tuigue na tunyite Ndeto ciaku njega.',
'Nikio tutonyete, Ati tuguthaite, Na tumbure wihia witu; We, Ngai, utuohere.',
'Tutiagiriruo Tukuinamirire: Nituguconoka muno Niwe Ngai munene.',
'Ithe witu mwega Utuiguire tha; Turathime ithuothe, Nitwaguthaitha.',
    ],
    chorus: null,
  ),
];
