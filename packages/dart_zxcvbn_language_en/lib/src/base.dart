import 'package:dart_zxcvbn/dart_zxcvbn.dart';
import 'package:intl/intl.dart';

part 'common_words.dart';
part 'firstnames.dart';
part 'lastnames.dart';
part 'translations.dart';
part 'wikipedia.dart';

class LanguageEn implements LanguagePack {
  @override
  AdjacencyGraphs? adjacencyGraphs;

  @override
  Dictionary dictionary = Dictionary({
    'commonWords': _commonWords,
    'firstnames': _firstnames,
    'lastnames': _lastnames,
    'wikipedia': _wikipedia,
  });

  @override
  Translations translations = _translations;
}
