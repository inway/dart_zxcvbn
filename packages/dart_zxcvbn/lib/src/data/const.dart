part of '../zxcvbn.dart';

const dateSplits = {
  4: [
    // for length-4 strings, eg 1191 or 9111, two ways to split:
    [1, 2], // 1 1 91 (2nd split starts at index 1, 3rd at index 2)
    [2, 3], // 91 1 1
  ],
  5: [
    [1, 3], // 1 11 91
    [2, 3], // 11 1 91
    //  [2, 3], // 91 1 11    <- duplicate previous one
    [2, 4], // 91 11 1    <- New and must be added as bug fix
  ],
  6: [
    [1, 2], // 1 1 1991
    [2, 4], // 11 11 91
    [4, 5], // 1991 1 1
  ],
  //  1111991
  7: [
    [1, 3], // 1 11 1991
    [2, 3], // 11 1 1991
    [4, 5], // 1991 1 11
    [4, 6], // 1991 11 1
  ],
  8: [
    [2, 4], // 11 11 1991
    [4, 6], // 1991 11 11
  ],
};

const DATE_MAX_YEAR = 2050;
const DATE_MIN_YEAR = 1000;
const DATE_SPLITS = dateSplits;
const double BRUTEFORCE_CARDINALITY = 10;
const MIN_GUESSES_BEFORE_GROWING_SEQUENCE = 10000;
const double MIN_SUBMATCH_GUESSES_SINGLE_CHAR = 10;
const double MIN_SUBMATCH_GUESSES_MULTI_CHAR = 50;
const MIN_YEAR_SPACE = 20;
// \xbf-\xdf is a range for almost all special uppercase letter like Ä and so on
final START_UPPER = RegExp(r'^[A-Z\xbf-\xdf][^A-Z\xbf-\xdf]+$');
final END_UPPER = RegExp(r'^[^A-Z\xbf-\xdf]+[A-Z\xbf-\xdf]$');
// \xdf-\xff is a range for almost all special lowercase letter like ä and so on
final ALL_UPPER = RegExp(r'^[A-Z\xbf-\xdf]+$');
final ALL_UPPER_INVERTED = RegExp(r'^[^a-z\xdf-\xff]+$');
final ALL_LOWER = RegExp(r'^[a-z\xdf-\xff]+$');
final ALL_LOWER_INVERTED = RegExp(r'^[^A-Z\xbf-\xdf]+$');
final ONE_LOWER = RegExp(r'[a-z\xdf-\xff]');
final ONE_UPPER = RegExp(r'[A-Z\xbf-\xdf]');
final ALPHA_INVERTED = RegExp(r'[^A-Za-z\xbf-\xdf]', caseSensitive: true);
final ALL_DIGIT = RegExp(r'^\d+$');
final REFERENCE_YEAR = DateTime.now().year;
final REGEXEN = {'recentYear': RegExp(r'19\d\d|200\d|201\d|202\d')};
/* Separators */
const SEPERATOR_CHARS = const [
  ' ',
  ',',
  ';',
  ':',
  '|',
  '/',
  '\\',
  '_',
  '.',
  '-',
];
final SEPERATOR_CHAR_COUNT = SEPERATOR_CHARS.length;
