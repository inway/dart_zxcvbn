part of '../zxcvbn.dart';

class DictionaryMatch extends Match {
  final String matchedWord;
  final int rank;
  final String dictionaryName;
  final bool reversed;
  final bool l33t;
  final int? levenshteinDistance;
  final String? levenshteinDistanceEntry;

  DictionaryMatch({
    super.pattern = 'dictionary',
    required super.i,
    required super.j,
    required super.token,
    required this.matchedWord,
    required this.rank,
    required this.dictionaryName,
    required this.reversed,
    required this.l33t,
    this.levenshteinDistance,
    this.levenshteinDistanceEntry,
  });

  DictionaryMatch copyWith({
    int? i,
    int? j,
    String? token,
    String? matchedWord,
    int? rank,
    String? dictionaryName,
    bool? reversed,
    bool? l33t,
    int? levenshteinDistance,
    String? levenshteinDistanceEntry,
  }) =>
      DictionaryMatch(
        i: i ?? this.i,
        j: j ?? this.j,
        token: token ?? this.token,
        matchedWord: matchedWord ?? this.matchedWord,
        rank: rank ?? this.rank,
        dictionaryName: dictionaryName ?? this.dictionaryName,
        reversed: reversed ?? this.reversed,
        l33t: l33t ?? this.l33t,
        levenshteinDistance: levenshteinDistance ?? this.levenshteinDistance,
        levenshteinDistanceEntry:
            levenshteinDistanceEntry ?? this.levenshteinDistanceEntry,
      );

  @override
  String toString() => 'DictionaryMatch('
      'i: $i, '
      'j: $j, '
      'token: $token, '
      'matchedWord: $matchedWord, '
      'rank: $rank, '
      'dictionaryName: $dictionaryName, '
      'reversed: $reversed, '
      'l33t: $l33t, '
      'levenshteinDistance: $levenshteinDistance, '
      'levenshteinDistanceEntry: $levenshteinDistanceEntry'
      ')';
}

class DictionaryGuess extends DictionaryMatch with EstimatedGuessesMixin {
  final double guesses;
  final double guessesLog10;
  final Map<String, dynamic> extraData;

  DictionaryGuess({
    required super.pattern,
    required super.i,
    required super.j,
    required super.token,
    required super.matchedWord,
    required super.rank,
    required super.dictionaryName,
    required super.reversed,
    required super.l33t,
    required super.levenshteinDistance,
    required super.levenshteinDistanceEntry,
    required this.guesses,
    required this.guessesLog10,
    required this.extraData,
  });

  DictionaryGuess.fromMatch(
    DictionaryMatch match, {
    required this.guesses,
    required this.guessesLog10,
    required this.extraData,
  }) : super(
          i: match.i,
          j: match.j,
          token: match.token,
          matchedWord: match.matchedWord,
          rank: match.rank,
          dictionaryName: match.dictionaryName,
          reversed: match.reversed,
          l33t: match.l33t,
          levenshteinDistance: match.levenshteinDistance,
          levenshteinDistanceEntry: match.levenshteinDistanceEntry,
        );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DictionaryGuess &&
          pattern == other.pattern &&
          i == other.i &&
          j == other.j &&
          token == other.token &&
          matchedWord == other.matchedWord &&
          rank == other.rank &&
          dictionaryName == other.dictionaryName &&
          reversed == other.reversed &&
          l33t == other.l33t &&
          levenshteinDistance == other.levenshteinDistance &&
          levenshteinDistanceEntry == other.levenshteinDistanceEntry &&
          guesses == other.guesses &&
          guessesLog10 == other.guessesLog10 &&
          MapEquality().equals(extraData, other.extraData);

  @override
  int get hashCode =>
      pattern.hashCode ^
      i.hashCode ^
      j.hashCode ^
      token.hashCode ^
      matchedWord.hashCode ^
      rank.hashCode ^
      dictionaryName.hashCode ^
      reversed.hashCode ^
      l33t.hashCode ^
      levenshteinDistance.hashCode ^
      levenshteinDistanceEntry.hashCode ^
      guesses.hashCode ^
      guessesLog10.hashCode ^
      extraData.hashCode;

  @override
  String toString() => 'DictionaryGuess('
      'pattern: $pattern, '
      'i: $i, '
      'j: $j, '
      'token: $token, '
      'matchedWord: $matchedWord, '
      'rank: $rank, '
      'dictionaryName: $dictionaryName, '
      'reversed: $reversed, '
      'l33t: $l33t, '
      'levenshteinDistance: $levenshteinDistance, '
      'levenshteinDistanceEntry: $levenshteinDistanceEntry, '
      'guesses: $guesses, '
      'guessesLog10: $guessesLog10, '
      'extraData: $extraData'
      ')';
}

class DictionaryScore {
  final double baseGuesses;
  final double uppercaseVariations;
  final double l33tVariations;
  final double calculation;

  DictionaryScore({
    required this.baseGuesses,
    required this.uppercaseVariations,
    required this.l33tVariations,
    required this.calculation,
  });

  @override
  String toString() => 'DictionaryScore('
      'baseGuesses: $baseGuesses, '
      'uppercaseVariations: $uppercaseVariations, '
      'l33tVariations: $l33tVariations, '
      'calculation: $calculation'
      ')';
}

abstract interface class DictionaryMatcherBase extends Matcher {
  List<DictionaryMatch> defaultMatch(
    String password, {
    bool useLevenshtein = true,
  }) {
    final List<DictionaryMatch> matches = [];

    final passwordLower = password.toLowerCase();
    final options = zxcvbn.options;

    options.rankedDictionaries.forEach((dictionaryName, rankedDict) {
      final longestDictionaryWordSize =
          options.rankedDictionariesMaxWordSize[dictionaryName] ?? 0;
      final searchWidth = min(password.length, longestDictionaryWordSize);

      for (int i = 0; i < password.length; i++) {
        final searchEnd = min(i + searchWidth, password.length);
        for (int j = i; j < searchEnd; j++) {
          final usedPassword =
              passwordLower.substring(i, min(j + 1, password.length));
          final isInDictionary = rankedDict.containsKey(usedPassword);
          FindLevenshteinDistanceResult? foundLevenshteinDistance;
          bool isFullPassword = i == 0 && j == password.length - 1;

          if (options.useLevenshteinDistance == true &&
              isFullPassword &&
              !isInDictionary &&
              useLevenshtein) {
            foundLevenshteinDistance = findLevenshteinDistance(
              usedPassword,
              rankedDict,
              options.levenshteinThreshold,
            );
          }

          final isLevenshteinMatch = foundLevenshteinDistance != null;

          if (isInDictionary || isLevenshteinMatch) {
            final usedRankPassword = isLevenshteinMatch
                ? foundLevenshteinDistance.levenshteinDistanceEntry!
                : usedPassword;

            final rank = rankedDict[usedRankPassword]!;

            matches.add(
              DictionaryMatch(
                i: i,
                j: j,
                token: usedPassword,
                matchedWord: usedPassword,
                rank: rank,
                dictionaryName: dictionaryName,
                reversed: false,
                l33t: false,
                levenshteinDistance:
                    foundLevenshteinDistance?.levenshteinDistance,
                levenshteinDistanceEntry:
                    foundLevenshteinDistance?.levenshteinDistanceEntry,
              ),
            );
          }
        }
      }
    });

    return matches;
  }

  @override
  DictionaryScore scoring(Match match) {
    if (match is! DictionaryMatch) {
      throw AssertionError('match is not a DictionaryMatch');
    }

    final double baseGuesses =
        match.rank.toDouble(); // keep these as properties for display purposes
    final double uppercaseVariations = _uppercaseVariant(match.token);
    final double l33tVariations = 1; // TODO l33tVariant({ l33t, subs, token });
    final double reversedVariations = match.reversed == true ? 2 : 1;
    double calculation;
    if (match.dictionaryName == 'diceware') {
      // diceware dictionaries are special, so we get a simple scoring of 1/2 of 6^5 (6 digits on 5 dice)
      // to get fix entropy of ~12.9 bits for every entry https://en.wikipedia.org/wiki/Diceware#:~:text=The%20level%20of,bits
      calculation = pow(6, 5) / 2;
    } else {
      calculation = baseGuesses *
          uppercaseVariations *
          l33tVariations *
          reversedVariations;
    }

    return DictionaryScore(
      baseGuesses: baseGuesses,
      uppercaseVariations: uppercaseVariations,
      l33tVariations: l33tVariations,
      calculation: calculation,
    );
  }

  double _uppercaseVariant(String word) {
    // clean words of non alpha characters to remove the reward effekt to
    // capitalize the first letter https://github.com/dropbox/zxcvbn/issues/232
    final String cleanedWord = word.replaceAll(ALPHA_INVERTED, '');
    if (ALL_LOWER_INVERTED.hasMatch(cleanedWord) ||
        cleanedWord.toLowerCase() == cleanedWord) {
      return 1;
    }

    // a capitalized word is the most common capitalization scheme, so it only
    // doubles the search space (uncapitalized + capitalized). all caps and
    // end-capitalized are common enough too, underestimate as 2x factor to be
    // safe.
    final List<RegExp> commonCases = [
      START_UPPER,
      END_UPPER,
      ALL_UPPER_INVERTED
    ];
    final int commonCasesLength = commonCases.length;

    for (int i = 0; i < commonCasesLength; i += 1) {
      final RegExp regex = commonCases[i];
      if (regex.hasMatch(cleanedWord)) {
        return 2;
      }
    }

    // otherwise calculate the number of ways to capitalize U+L
    // uppercase+lowercase letters with U uppercase letters or less. or, if
    // there's more uppercase than lower (for eg. PASSwORD), the number of ways
    // to lowercase U+L letters with L lowercase letters or less.
    return _getVariations(cleanedWord);
  }

  _getVariations(String cleanedWord) {
    final List<String> wordArray = cleanedWord.split('');
    final upperCaseCount =
        wordArray.where((char) => ONE_UPPER.hasMatch(char)).length;
    final lowerCaseCount =
        wordArray.where((char) => ONE_LOWER.hasMatch(char)).length;

    double variations = 0;
    final int variationLength = min(upperCaseCount, lowerCaseCount);
    for (int i = 1; i <= variationLength; i += 1) {
      variations += nCk(upperCaseCount + lowerCaseCount, i);
    }
    return variations;
  }

  String? getDictionaryWarningPassword(
    DictionaryGuess match,
    bool isSoleMatch,
  ) {
    String? warning;
    if (isSoleMatch && !match.l33t && !match.reversed) {
      if (match.rank <= 10) {
        warning = zxcvbn.options.translations.warnings.topTen;
      } else if (match.rank <= 100) {
        warning = zxcvbn.options.translations.warnings.topHundred;
      } else {
        warning = zxcvbn.options.translations.warnings.common;
      }
    } else if (match.guessesLog10 <= 4) {
      warning = zxcvbn.options.translations.warnings.similarToCommon;
    }

    return warning;
  }

  String? getDictionaryWarningWikipedia(
    DictionaryGuess match,
    bool isSoleMatch,
  ) {
    String? warning;
    if (isSoleMatch) {
      warning = zxcvbn.options.translations.warnings.wordByItself;
    }

    return warning;
  }

  String getDictionaryWarningNames(DictionaryGuess match, bool isSoleMatch) {
    if (isSoleMatch) {
      return zxcvbn.options.translations.warnings.namesByThemselves;
    }
    return zxcvbn.options.translations.warnings.commonNames;
  }

  String? getDictionaryWarning(DictionaryGuess match, bool isSoleMatch) {
    String? warning;
    final String dictName = match.dictionaryName;
    final isAName = dictName == 'lastnames' ||
        dictName.toLowerCase().contains('firstnames');

    if (dictName == 'passwords') {
      warning = getDictionaryWarningPassword(match, isSoleMatch);
    } else if (dictName.contains('wikipedia')) {
      warning = getDictionaryWarningWikipedia(match, isSoleMatch);
    } else if (isAName) {
      warning = getDictionaryWarningNames(match, isSoleMatch);
    } else if (dictName == 'userInputs') {
      warning = zxcvbn.options.translations.warnings.userInputs;
    }

    return warning;
  }

  @override
  Feedback feedback(EstimatedGuessesMixin match, bool isSoleMatch) {
    if (match is! DictionaryGuess) {
      throw ArgumentError('match is not a DictionaryGuess');
    }

    final String? warning = getDictionaryWarning(match, isSoleMatch);
    final List<String> suggestions = [];
    final String word = match.token;

    if ((START_UPPER.hasMatch(word))) {
      suggestions.add(zxcvbn.options.translations.suggestions.capitalization);
    } else if ((ALL_UPPER_INVERTED.hasMatch((word))) &&
        word.toLowerCase() != word) {
      suggestions.add(zxcvbn.options.translations.suggestions.allUppercase);
    }
    if (match.reversed && match.token.length >= 4) {
      suggestions.add(zxcvbn.options.translations.suggestions.reverseWords);
    }
    if (match.l33t) {
      suggestions.add(zxcvbn.options.translations.suggestions.l33t);
    }

    return Feedback(
      warning: warning,
      suggestions: suggestions,
    );
  }
}

class DictionaryMatcher extends DictionaryMatcherBase {
  final ReverseDictionaryMatcher reverse = ReverseDictionaryMatcher();

  @override
  List<DictionaryMatch> match(String password) {
    final List<DictionaryMatch> matches = [];

    matches
      ..addAll(defaultMatch(password))
      ..addAll(reverse.match(password));

    return _sorted(matches);
  }
}

class ReverseDictionaryMatcher extends DictionaryMatcherBase {
  @override
  List<DictionaryMatch> match(String password) {
    final String passwordReversed = password.split('').reversed.join();

    return defaultMatch(passwordReversed)
        .map((match) => match.copyWith(
              i: password.length - 1 - match.j,
              j: password.length - 1 - match.i,
              token: match.token.split('').reversed.join(),
              reversed: true,
            ))
        .toList();
  }
}
