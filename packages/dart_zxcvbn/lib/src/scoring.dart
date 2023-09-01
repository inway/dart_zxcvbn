part of 'zxcvbn.dart';

double log10(num x) => log(x) / ln10;

/// binomial coefficients
///
/// src: http://blog.plover.com/math/choose.html
double nCk(num n, num k) {
  double count = n.toDouble();
  if (k < count) return 0;
  if (k == 0) return 1;
  double coEff = 1;
  for (int i = 1; i <= k; i++) {
    coEff *= count;
    coEff /= i;
    count--;
  }
  return coEff;
}

double getMinGuesses(Match match, String password) {
  double minGuesses = 1;

  if (match.token.length < password.length) {
    if (match.token.length == 1) {
      minGuesses = MIN_SUBMATCH_GUESSES_SINGLE_CHAR;
    } else {
      minGuesses = MIN_SUBMATCH_GUESSES_MULTI_CHAR;
    }
  }

  return minGuesses;
}

dynamic getScoring(String name, Match match) {
  // TODO return here, after properly implementing scoring to all matchers
  if (_defaultMatchers.containsKey(name)) {
    return _defaultMatchers[name]!().scoring(match);
  }
  // if (
  //   zxcvbnOptions.matchers[name] &&
  //   'scoring' in zxcvbnOptions.matchers[name]
  // ) {
  //   return zxcvbnOptions.matchers[name].scoring(match)
  // }

  return 0;
}

mixin EstimatedGuessesMixin on Match {
  double get guesses;
  double get guessesLog10;
  Map<String, dynamic> get extraData;
}

class EstimatedGuess extends Match with EstimatedGuessesMixin {
  final double guesses;
  final double guessesLog10;
  final Map<String, dynamic> extraData;

  EstimatedGuess({
    required super.pattern,
    required super.i,
    required super.j,
    required super.token,
    required this.guesses,
    required this.guessesLog10,
    required this.extraData,
  });

  EstimatedGuess.fromMatch(
    Match match, {
    required this.guesses,
    required this.guessesLog10,
    required this.extraData,
  }) : super(
          pattern: match.pattern,
          i: match.i,
          j: match.j,
          token: match.token,
        );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EstimatedGuess &&
          pattern == other.pattern &&
          i == other.i &&
          j == other.j &&
          token == other.token &&
          guesses == other.guesses &&
          guessesLog10 == other.guessesLog10 &&
          MapEquality().equals(extraData, other.extraData);

  @override
  int get hashCode =>
      pattern.hashCode ^
      i.hashCode ^
      j.hashCode ^
      token.hashCode ^
      guesses.hashCode ^
      guessesLog10.hashCode ^
      extraData.hashCode;

  @override
  String toString() => 'EstimatedGuesses('
      'pattern: $pattern, '
      'i: $i, '
      'j: $j, '
      'token: $token, '
      'guesses: $guesses, '
      'guessesLog10: $guessesLog10, '
      'extraData: $extraData'
      ')';
}

EstimatedGuessesMixin estimateGuesses(Match match, String password) {
  final Map<String, dynamic> extraData = {};

  // a match's guess estimate doesn't change. cache it.
  // TODO return here, after properly implementing all matchers, because
  //  as for now none of the matcher returns `guesses` property.
  // if (match.guesses != null) {
  //   return match.guesses;
  // }

  final double minGuesses = getMinGuesses(match, password);

  final estimationResult = getScoring(match.pattern, match);
  double guesses = 0;

  if (estimationResult is num) {
    guesses = estimationResult.toDouble();
  } else if (estimationResult is DictionaryScore) {
    guesses = estimationResult.calculation;
    extraData['baseGuesses'] = estimationResult.baseGuesses;
    extraData['uppercaseVariations'] = estimationResult.uppercaseVariations;
    extraData['l33tVariations'] = estimationResult.l33tVariations;
  }

  final double matchGuesses = max(guesses, minGuesses);

  return (match is DictionaryMatch && estimationResult is DictionaryScore)
      ? DictionaryGuess.fromMatch(
          match,
          guesses: matchGuesses,
          guessesLog10: log10(matchGuesses),
          extraData: extraData,
        )
      : EstimatedGuess.fromMatch(
          match,
          guesses: matchGuesses,
          guessesLog10: log10(matchGuesses),
          extraData: extraData,
        );
}

class ScoringHelperOptimal {
  // optimal.m[k][sequenceLength] holds final match in the best length-sequenceLength
  // match sequence covering the
  // password prefix up to k, inclusive.
  // if there is no length-sequenceLength sequence that scores better (fewer guesses) than
  // a shorter match sequence spanning the same prefix,
  // optimal.m[k][sequenceLength] is undefined.
  final List<Map<int, EstimatedGuessesMixin>> m;

  // same structure as optimal.m -- holds the product term Prod(m.guesses for m in sequence).
  // optimal.pi allows for fast (non-looping) updates to the minimization function.
  final List<Map<int, double>> pi;

  // same structure as optimal.m -- holds the overall metric.
  final List<Map<int, double>> g;

  ScoringHelperOptimal({
    required this.m,
    required this.pi,
    required this.g,
  });

  ScoringHelperOptimal.generate(int length)
      : m = List.generate(length, (_) => {}),
        pi = List.generate(length, (_) => {}),
        g = List.generate(length, (_) => {});
}

double factorial(int _num) {
  double rval = 1;
  for (int i = 2; i <= _num; i += 1) rval *= i;
  return rval;
}

class ScoringHelper {
  final String password;
  final bool excludeAdditive;
  final ScoringHelperOptimal optimal;

  ScoringHelper({
    required this.password,
    required this.excludeAdditive,
  }) : optimal = ScoringHelperOptimal.generate(password.length);

  /// helper: considers whether a length-sequenceLength
  /// sequence ending at match m is better (fewer guesses)
  /// than previously encountered sequences, updating state if so.
  void update(Match match, int sequenceLength) {
    final k = match.j;
    final estimatedMatch = estimateGuesses(match, password);
    double pi = estimatedMatch.guesses.toDouble();
    if (sequenceLength > 1) {
      // we're considering a length-sequenceLength sequence ending with match m:
      // obtain the product term in the minimization function by multiplying m's guesses
      // by the product of the length-(sequenceLength-1)
      // sequence ending just before m, at m.i - 1.
      var pi1 = estimatedMatch.i - 1;
      var pi2 = sequenceLength - 1;
      // TODO validate this logic
      pi *= optimal.pi[pi1][pi2] ?? 0;
    }
    // calculate the minimization func
    double g = factorial(sequenceLength) * pi;
    if (!excludeAdditive) {
      g += pow(MIN_GUESSES_BEFORE_GROWING_SEQUENCE, sequenceLength - 1);
    }
    // update state if new best.
    // first see if any competing sequences covering this prefix,
    // with sequenceLength or fewer matches,
    // fare better than this sequence. if so, skip it and return.
    bool shouldSkip = false;
    optimal.g[k].forEach((competingPatternLength, competingMetricMatch) {
      if (competingPatternLength <= sequenceLength) {
        if (competingMetricMatch <= g) {
          shouldSkip = true;
        }
      }
    });

    if (!shouldSkip) {
      optimal.g[k][sequenceLength] = g;
      optimal.m[k][sequenceLength] = estimatedMatch;
      optimal.pi[k][sequenceLength] = pi;
    }
  }

  /// helper: make bruteforce match objects spanning i to j, inclusive.
  BruteForceMatch makeBruteforceMatch(int i, int j) =>
      BruteForceMatch(i: i, j: j, token: password.substring(i, j + 1));

  /// helper: evaluate bruteforce matches ending at passwordCharIndex.
  void bruteforceUpdate(int passwordCharIndex) {
    Match match = makeBruteforceMatch(0, passwordCharIndex);
    update(match, 1);

    for (int i = 1; i <= passwordCharIndex; i++) {
      // generate passwordCharIndex bruteforce matches, spanning from (i=1,
      // j=passwordCharIndex) up to (i=passwordCharIndex, j=passwordCharIndex).
      // see if adding these new matches to any of the sequences in optimal[i-1]
      // leads to new bests.
      match = makeBruteforceMatch(i, passwordCharIndex);
      final tmp = optimal.m[i - 1];

      tmp.forEach((sequenceLength, lastMatch) {
        // corner: an optimal sequence will never have two adjacent bruteforce
        // matches. it is strictly better to have a single bruteforce match
        // spanning the same region: same contribution to the guess product with
        // a lower length. --> safe to skip those cases.
        if (lastMatch.pattern != 'bruteforce') {
          // try adding m to this length-sequenceLength sequence.
          update(match, sequenceLength + 1);
        }
      });
    }
  }

  /// helper: step backwards through optimal.m starting at the end,
  /// constructing the final optimal match sequence.
  List<EstimatedGuessesMixin> unwind(int passwordLength) {
    final List<EstimatedGuessesMixin> optimalMatchSequence = [];
    int k = passwordLength - 1;
    // find the final best sequence length and score
    int sequenceLength = 0; // TODO was: optimal.m[k].length;

    double g = double.infinity;
    // This is to mimic javascript behavior when accessing an array by negative
    // key which returns undefined - opposite to dart which throws an exception.
    final Map<int, double>? temp = k.isNegative ? null : optimal.g[k];

    if (temp != null) {
      temp.forEach((candidateSequenceLength, candidateMetricMatch) {
        if (candidateMetricMatch < g) {
          sequenceLength = candidateSequenceLength;
          g = candidateMetricMatch;
        }
      });
    }
    while (k >= 0) {
      // TODO check null safety
      final EstimatedGuessesMixin match = optimal.m[k][sequenceLength]!;
      optimalMatchSequence.insert(0, match);
      k = match.i - 1;
      sequenceLength--;
    }

    return optimalMatchSequence;
  }
}

class MostGuessableMatchSequence {
  final String password;
  final double guesses;
  final double guessesLog10;
  final List<EstimatedGuessesMixin> sequence;

  MostGuessableMatchSequence({
    required this.password,
    required this.guesses,
    required this.guessesLog10,
    required this.sequence,
  });

  @override
  String toString() => 'MostGuessableMatchSequence('
      'password: $password, '
      'guesses: $guesses, '
      'guessesLog10: $guessesLog10, '
      'sequence: $sequence'
      ')';
}

/// ------------------------------------------------------------------------------
/// search --- most guessable match sequence
/// ------------------------------------------------------------------------------
///
/// takes a sequence of overlapping matches, returns the non-overlapping
/// sequence with minimum guesses. the following is a O(l_max * (n + m)) dynamic
/// programming algorithm for a length-n password with m candidate matches.
/// l_max is the maximum optimal sequence length spanning each prefix of the
/// password. In practice it rarely exceeds 5 and the search terminates rapidly.
///
/// the optimal "minimum guesses" sequence is here defined to be the sequence
/// that minimizes the following function:
///
///    g = sequenceLength! * Product(m.guesses for m in sequence) +
///    D^(sequenceLength - 1)
///
/// where sequenceLength is the length of the sequence.
///
/// the factorial term is the number of ways to order sequenceLength patterns.
///
/// the D^(sequenceLength-1) term is another length penalty, roughly capturing
/// the idea that an attacker will try lower-length sequences first before
/// trying length-sequenceLength sequences.
///
/// for example, consider a sequence that is date-repeat-dictionary.
///  - an attacker would need to try other date-repeat-dictionary combinations,
///    hence the product term.
///  - an attacker would need to try repeat-date-dictionary,
///    dictionary-repeat-date, ..., hence the factorial term.
///  - an attacker would also likely try length-1 (dictionary) and length-2
///    (dictionary-date) sequences before length-3. assuming at minimum D
///    guesses per pattern type, D^(sequenceLength-1) approximates Sum(D^i for i
///    in [1..sequenceLength-1]
///
/// ------------------------------------------------------------------------------
MostGuessableMatchSequence mostGuessableMatchSequence(
    String password, List<Match> matches,
    [bool excludeAdditive = false]) {
  final ScoringHelper scoringHelper = ScoringHelper(
    password: password,
    excludeAdditive: excludeAdditive,
  );

  final int passwordLength = password.length;
  final List<List<Match>> matchesByCoordinateJ =
      List.generate(passwordLength, (_) => []);

  matches.forEach((match) {
    matchesByCoordinateJ[match.j].add(match);
  });
  // small detail: for deterministic output, sort each sublist by i.
  matchesByCoordinateJ.forEach((matchesForIndex) {
    matchesForIndex.sort((a, b) => a.i.compareTo(b.i));
  });

  for (int k = 0; k < passwordLength; k++) {
    matchesByCoordinateJ[k].forEach((match) {
      if (match.i > 0) {
        scoringHelper.optimal.m[match.i - 1].keys.forEach((sequenceLength) {
          scoringHelper.update(match, sequenceLength + 1);
        });
      } else {
        scoringHelper.update(match, 1);
      }
    });

    scoringHelper.bruteforceUpdate(k);
  }

  final optimalMatchSequence = scoringHelper.unwind(passwordLength);
  final optimalSequenceLength = optimalMatchSequence.length;
  // TODO validate null checks
  final double guesses = password.isEmpty
      ? 1
      : scoringHelper.optimal.g[passwordLength - 1][optimalSequenceLength]!;

  return MostGuessableMatchSequence(
    password: password,
    guesses: guesses,
    guessesLog10: log10(guesses),
    sequence: optimalMatchSequence,
  );
}
