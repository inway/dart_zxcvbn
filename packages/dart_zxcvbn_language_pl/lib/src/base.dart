import 'package:dart_zxcvbn/dart_zxcvbn.dart';
import 'package:intl/intl.dart';

part 'common_words.dart';
part 'female_firstnames.dart';
part 'male_firstnames.dart';
part 'female_lastnames.dart';
part 'male_lastnames.dart';
part 'translations.dart';
part 'wikipedia.dart';

class LanguagePl implements LanguagePack {
  @override
  AdjacencyGraphs? adjacencyGraphs;

  @override
  Dictionary dictionary = Dictionary({
    'commonWords': _commonWords,
    'femaleFirstnames': _femaleFirstnames,
    'maleFirstnames': _maleFirstnames,
    'femaleLastnames': _femaleLastnames,
    'maleLastnames': _maleLastnames,
    'wikipedia': _wikipedia,
  });

  @override
  Translations translations = _translations;
}
