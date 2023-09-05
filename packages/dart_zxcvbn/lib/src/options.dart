part of 'zxcvbn.dart';

/// This class is used to define the options for the [Zxcvbn] class.
class Options {
  Options({
    this.matchers,
    this.l33tTable,
    this.dictionary,
    this.translations,
    this.graphs,
    this.useLevenshteinDistance,
    this.levenshteinThreshold,
    this.l33tMaxSubstitutions,
    this.maxLength,
  });

  /// Any additional third-party matchers to use.
  Map<String, Matcher>? matchers = {};

  /// Define an object with l33t substitutions. For example that an "a" can be
  /// exchanged with a "4" or a "@".
  Map<String, List<String>>? l33tTable;

  /// Define dictionary that should be used to check against. The matcher will
  /// search the dictionaries for similar password with l33t speak and reversed
  /// words. The recommended sets are found in [dart_zxcvbn_language_common] and
  /// [dart_zxcvbn_language_en].
  Dictionary? dictionary;

  /// Defines an object with a key value match to translate the feedback given
  /// by this library. The default values are plain keys so that you can use
  /// your own i18n library. Already implemented language can be found with
  /// something like [dart_zxcvbn_language_en].
  Translations? translations;

  /// Defines keyboard layouts as an object which are used to find sequences.
  /// Already implemented layouts can be found in [dart_zxcvbn_language_common]
  AdjacencyGraphsMixin? graphs;

  /// Defines if the levenshtein algorithm should be used. This will be only
  /// used on the complete password and not on parts of it. This will decrease
  /// the calcTime a bit but will significantly improve the password check. The
  /// recommended sets are found in [dart_zxcvbn_language_common] and
  /// [dart_zxcvbn_language_en].
  ///
  /// This is set [false] by default.
  bool? useLevenshteinDistance;

  /// Defines how many characters can be different to match a dictionary word
  /// with the levenshtein algorithm.
  ///
  /// This is set to [2] by default.
  int? levenshteinThreshold;

  /// The l33t matcher will check how many characters can be exchanged with the
  /// l33t table. If they are to many it will decrease the calcTime
  /// significantly. So we cap it at a reasonable value by default which will
  /// probably already seems like a strong password anyway.
  ///
  /// This is set to [512] by default.
  int? l33tMaxSubstitutions;

  /// Defines how many character of the password are checked. A password longer
  /// than the default are considered strong anyway, but it can be increased as
  /// pleased. Be aware that this could open some attack vectors.
  ///
  /// This is set to [256] by default.
  int? maxLength;

  void addMatcher(String name, Matcher matcher) {
    matchers?[name] ??= matcher;
  }
}

/// This class defines the default options for the [Zxcvbn] class.
class DefaultOptions extends Options {
  Dictionary _dictionary = Dictionary({});
  Translations _translations = Translations();
  Map<String, List<String>> _l33tTable = defaultL33tTable;
  // trieNodeRoot: TrieNode = l33tTableToTrieNode(l33tTable, new TrieNode())
  bool _useLevenshteinDistance = false;
  int _levenshteinThreshold = 2;
  int _l33tMaxSubstitutions = 512;
  int _maxLength = 256;

  Map<String, Map<String, int>> rankedDictionaries = {};
  Map<String, int> rankedDictionariesMaxWordSize = {};

  DefaultOptions();

  void mergeWith(Options newOptions) {
    this.dictionary = newOptions.dictionary;
    this.translations = newOptions.translations;
    this.useLevenshteinDistance = newOptions.useLevenshteinDistance;
    this.levenshteinThreshold = newOptions.levenshteinThreshold;
    this.l33tMaxSubstitutions = newOptions.l33tMaxSubstitutions;
    this.maxLength = newOptions.maxLength;
    // TODO
    // this.matchers = newOptions.matchers;
    // this.l33tTable = newOptions.l33tTable;
    this.graphs = newOptions.graphs;
  }

  Dictionary get dictionary => _dictionary;

  set dictionary(Dictionary? dictionary) {
    if (dictionary == null) return;

    _dictionary = dictionary;

    _setRankedDictionaries();
  }

  @override
  Translations get translations => _translations;

  @override
  set translations(Translations? translations) {
    if (translations != null) {
      _translations = translations;
    }
  }

  @override
  Map<String, List<String>> get l33tTable => _l33tTable;

  @override
  bool get useLevenshteinDistance => _useLevenshteinDistance;

  @override
  set useLevenshteinDistance(bool? useLevenshteinDistance) {
    if (useLevenshteinDistance != null) {
      _useLevenshteinDistance = useLevenshteinDistance;
    }
  }

  @override
  int get levenshteinThreshold => _levenshteinThreshold;

  @override
  set levenshteinThreshold(int? levenshteinThreshold) {
    if (levenshteinThreshold != null) {
      _levenshteinThreshold = levenshteinThreshold;
    }
  }

  @override
  int get l33tMaxSubstitutions => _l33tMaxSubstitutions;

  @override
  set l33tMaxSubstitutions(int? l33tMaxSubstitutions) {
    if (l33tMaxSubstitutions != null) {
      _l33tMaxSubstitutions = l33tMaxSubstitutions;
    }
  }

  @override
  int get maxLength => _maxLength;

  @override
  set maxLength(int? maxLength) {
    if (maxLength != null) {
      _maxLength = maxLength;
    }
  }

  ///
  Map<String, int> _buildRankedDictionary(List<String> orderedList) {
    Map<String, int> result = {};
    int count = 1;

    orderedList.forEach((word) {
      result[word] = count;
      count++;
    });

    return result;
  }

  ///
  Map<String, int> _buildSanitizedRankedDictionary(List<String> orderedList) =>
      _buildRankedDictionary(
          orderedList.map((e) => e.toLowerCase()).toList(growable: false));

  ///
  int _getRankedDictionariesMaxWordSize(List<String> list) {
    final lengths = list.map((e) => e.length);

    if (lengths.isEmpty) return 0;
    return lengths.reduce(max);
  }

  ///
  void _setRankedDictionaries() {
    Map<String, Map<String, int>> rankedDictionaries = {};
    Map<String, int> rankedDictionariesMaxWordSize = {};

    dictionary.dictionaries.forEach((name) {
      final list = dictionary.get(name);

      if (list != null) {
        rankedDictionaries[name] = _buildRankedDictionary(list);
        rankedDictionariesMaxWordSize[name] =
            _getRankedDictionariesMaxWordSize(list);
      }
    });

    this.rankedDictionaries = rankedDictionaries;
    this.rankedDictionariesMaxWordSize = rankedDictionariesMaxWordSize;
  }

  ///
  void extendUserInputsDictionary(List<String> userInputs) {
    if (dictionary.get('userInputs') == null) {
      dictionary.set('userInputs', []);
    }

    final userInputsDictionary = dictionary.get('userInputs')!;

    userInputsDictionary.addAll(userInputs);

    rankedDictionaries['userInputs'] =
        _buildSanitizedRankedDictionary(userInputsDictionary);
    rankedDictionariesMaxWordSize['userInputs'] =
        _getRankedDictionariesMaxWordSize(userInputsDictionary);
  }
}
