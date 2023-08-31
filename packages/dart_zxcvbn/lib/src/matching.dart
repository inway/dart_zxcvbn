part of 'zxcvbn.dart';

final Map<String, Matcher Function()> _defaultMatchers = {
  'bruteforce': () => BruteForceMatcher(),
  // 'date': () => DateMatcher(),
  'dictionary': () => DictionaryMatcher(),
  // regex: regexMatcher,
  // repeat: repeatMatcher,
  'sequence': () => SequenceMatcher(),
  // spatial: spatialMatcher,
  // separator: separatorMatcher,
};

class Matching {
  /// Original implementation in TS uses class names as values, but in Dart
  /// to instantiate a class by it's type (to my knowledge) you need to use
  /// [dart:mirrors] which has negative impact on library size and performance.
  ///
  /// So instead of using classes as values, we use functions that return
  /// instances of classes - to always have fresh matcher instance.
  final Map<String, Matcher Function()> matchers = _defaultMatchers;

  List<Match> match(String password) {
    List<Match> matches = [];

    // TODO allow extensions through options
    matchers.forEach((name, creator) {
      Matcher matcher = creator();

      final List<Match> result = matcher.match(password);
      matches.addAll(result);
      // value(password);
    });

    return _sorted(matches);
  }
}
