part of '../zxcvbn.dart';

class BruteForceMatch extends Match {
  BruteForceMatch({
    super.pattern = 'bruteforce',
    required super.i,
    required super.j,
    required super.token,
  });
}

/// This is not a real matcher, it's just a placeholder for bruteforce matches
/// that are being handled in dictionary matcher. The sole purpose of this
/// class is to handle bruteforce scoring.
class BruteForceMatcher extends Matcher {
  /// There's no real bruteforce matcher, it's all being handled in dictionary
  /// matcher - so we always return empty match list here.
  @override
  List<Match> match(String password) => [];

  @override
  double scoring(Match match) {
    if (match is! BruteForceMatch) {
      throw AssertionError('match is not a BruteForceMatch');
    }

    double guesses = pow(BRUTEFORCE_CARDINALITY, match.token.length).toDouble();
    if (guesses == double.infinity) {
      guesses = double.maxFinite;
    }

    double minGuesses;
    // small detail: make bruteforce matches at minimum one guess bigger than smallest allowed
    // submatch guesses, such that non-bruteforce submatches over the same [i..j] take precedence.
    if (match.token.length == 1) {
      minGuesses = MIN_SUBMATCH_GUESSES_SINGLE_CHAR + 1;
    } else {
      minGuesses = MIN_SUBMATCH_GUESSES_MULTI_CHAR + 1;
    }

    return max(guesses, minGuesses);
  }

  @override
  feedback(EstimatedGuessesMixin match, bool isSoleMatch) => null;
}
