import 'package:dart_zxcvbn/dart_zxcvbn.dart';

part 'adjacency_graphs.dart';
part 'diceware.dart';
part 'passwords.dart';

class LanguageCommon implements LanguagePack {
  @override
  AdjacencyGraphsMixin adjacencyGraphs = LangageCommonAdjacencyGraphs();

  @override
  Dictionary dictionary = Dictionary({
    'passwords': _passwords,
    'diceware': _diceware,
  });

  @override
  Translations? translations;
}
