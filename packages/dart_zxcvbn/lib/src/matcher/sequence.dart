part of '../zxcvbn.dart';

class SequenceMatch extends Match {
  final String sequenceName;
  final int sequenceSpace;
  final bool ascending;

  SequenceMatch({
    super.pattern = 'sequence',
    required super.i,
    required super.j,
    required super.token,
    required this.sequenceName,
    required this.sequenceSpace,
    required this.ascending,
  });

  @override
  String toString() => 'SequenceMatch('
      'i: $i, '
      'j: $j, '
      'token: $token, '
      'sequenceName: $sequenceName, '
      'sequenceSpace: $sequenceSpace, '
      'ascending: $ascending, '
      ')';
}

class SequenceMatcher extends Matcher {
  final int maxDelta = 5;

  /// Identifies sequences by looking for repeated differences in unicode
  /// codepoint. this allows skipping, such as 9753, and also matches some
  /// extended unicode sequences such as Greek and Cyrillic alphabets.
  ///
  /// for example, consider the input 'abcdb975zy'
  ///
  /// password: a   b   c   d   b    9   7   5   z   y
  /// index:    0   1   2   3   4    5   6   7   8   9
  /// delta:      1   1   1  -2  -41  -2  -2  69   1
  ///
  /// expected result:
  /// [(i, j, delta), ...] = [(0, 3, 1), (5, 7, -2), (8, 9, 1)]
  @override
  List<Match> match(String password) {
    final List<SequenceMatch> result = [];
    if (password.length == 1) return result;

    int i = 0;
    int? lastDelta;
    final int passwordLength = password.length;
    for (int k = 1; k < passwordLength; k++) {
      final delta = password.codeUnitAt(k) - password.codeUnitAt(k - 1);
      if (lastDelta == null) {
        lastDelta = delta;
      }
      if (delta != lastDelta) {
        final j = k - 1;
        update(
          i: i,
          j: j,
          delta: lastDelta,
          password: password,
          result: result,
        );
        i = j;
        lastDelta = delta;
      }
    }

    update(
      i: i,
      j: passwordLength - 1,
      delta: lastDelta,
      password: password,
      result: result,
    );

    return result;
  }

  void update({
    required int i,
    required int j,
    required int? delta,
    required String password,
    required List<SequenceMatch> result,
  }) {
    if (j - i > 1 || delta?.abs() == 1) {
      final int absoluteDelta = delta?.abs() ?? 0;
      if (absoluteDelta > 0 && absoluteDelta <= maxDelta) {
        final token = password.substring(i, j + 1);
        final (sequenceName, sequenceSpace) = getSequence(token);

        result.add(SequenceMatch(
          i: i,
          j: j,
          token: token,
          sequenceName: sequenceName,
          sequenceSpace: sequenceSpace,
          ascending: delta != null ? delta > 0 : false,
        ));
      }
    }
  }

  (String, int) getSequence(String token) {
    // TODO from upstream: conservatively stick with roman alphabet size. (this
    //  could be improved)
    String sequenceName = 'unicode';
    int sequenceSpace = 26;

    if (ALL_LOWER.hasMatch(token)) {
      sequenceName = 'lower';
    } else if (ALL_UPPER.hasMatch(token)) {
      sequenceName = 'upper';
    } else if (ALL_DIGIT.hasMatch(token)) {
      sequenceName = 'digits';
      sequenceSpace = 10;
    }

    return (sequenceName, sequenceSpace);
  }

  @override
  int scoring(Match match) {
    if (match is! SequenceMatch) {
      throw AssertionError('match is not a SequenceMatch');
    }

    final String firstChr = String.fromCharCode(match.token.codeUnitAt(0));
    int baseGuesses = 0;
    final List<String> startingPoints = ['a', 'A', 'z', 'Z', '0', '1', '9'];

    // lower guesses for obvious starting points
    if (startingPoints.contains(firstChr)) {
      baseGuesses = 4;
    } else if (RegExp('\\d').hasMatch(firstChr)) {
      baseGuesses = 10; // digits
    } else {
      // could give a higher base for uppercase,
      // assigning 26 to both upper and lower sequences is more conservative.
      baseGuesses = 26;
    }
    // need to try a descending sequence in addition to every ascending sequence ->
    // 2x guesses
    if (!match.ascending) {
      baseGuesses *= 2;
    }
    return baseGuesses * match.token.length;
  }

  @override
  Feedback feedback(Match match, bool isSoleMatch) => Feedback(
        warning: zxcvbn.options.translations.warnings.sequences,
        suggestions: [zxcvbn.options.translations.suggestions.sequences],
      );
}
