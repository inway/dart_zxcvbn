import 'dart:math';

import 'package:collection/collection.dart';

part 'adjacency_graphs.dart';
part 'data/const.dart';
part 'data/l33t_table.dart';
part 'dictionary.dart';
part 'feedback.dart';
part 'helpers.dart';
part 'language_pack.dart';
part 'levenshtein.dart';
part 'matcher/bruteforce.dart';
part 'matcher/common.dart';
part 'matcher/date.dart';
part 'matcher/dictionary.dart';
part 'matcher/regex.dart';
part 'matcher/repeat.dart';
part 'matcher/separator.dart';
part 'matcher/sequence.dart';
part 'matcher/spatial.dart';
part 'matching.dart';
part 'options.dart';
part 'result.dart';
part 'time_estimates.dart';
part 'scoring.dart';
part 'translations.dart';

class Zxcvbn {
  final DefaultOptions options = DefaultOptions();

  Zxcvbn._();

  Result _createReturnValue(
    List<Match> resolvedMatches,
    String password,
    int start,
  ) {
    final int calcTime = DateTime.now().millisecondsSinceEpoch - start;
    final MostGuessableMatchSequence matchSequence =
        mostGuessableMatchSequence(password, resolvedMatches);

    final TimeEstimates attackTimes =
        TimeEstimates.estimateAttackTimes(matchSequence.guesses);

    final Feedback feedback =
        Feedback.getFeedback(attackTimes.score, matchSequence.sequence);

    return Result(
      feedback: feedback,
      crackTimesSeconds: attackTimes.crackTimesSeconds,
      crackTimesDisplay: attackTimes.crackTimesDisplay,
      score: attackTimes.score,
      password: password,
      guesses: matchSequence.guesses,
      guessesLog10: matchSequence.guessesLog10,
      sequence: matchSequence.sequence,
      calcTime: calcTime,
    );
  }

  List<Match> _main(String password, List<String>? userInputs) {
    if (userInputs != null) {
      this.options.extendUserInputsDictionary(userInputs);
    }

    Matching matching = Matching();

    return matching.match(password);
  }

  ///
  ///
  Result call(
    String password, {
    List<String>? userInputs,
    Options? options,
  }) {
    if (options != null) {
      setOptions(options);
    }

    int start = DateTime.now().millisecondsSinceEpoch;
    List<Match> matches = _main(password, userInputs);

    return _createReturnValue(matches, password, start);
  }

  ///
  ///
  void setOptions(Options options) => this.options.mergeWith(options);
}

Zxcvbn zxcvbn = Zxcvbn._();
