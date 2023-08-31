part of 'zxcvbn.dart';

class Result {
  final Feedback feedback;
  final CrackTimesSeconds crackTimesSeconds;
  final CrackTimesDisplay crackTimesDisplay;
  final double score;
  final String password;
  final double guesses;
  final double guessesLog10;
  final List<Match> sequence;
  final int calcTime;

  const Result({
    required this.feedback,
    required this.crackTimesSeconds,
    required this.crackTimesDisplay,
    required this.score,
    required this.password,
    required this.guesses,
    required this.guessesLog10,
    required this.sequence,
    required this.calcTime,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Result &&
          runtimeType == other.runtimeType &&
          feedback == other.feedback &&
          crackTimesSeconds == other.crackTimesSeconds &&
          crackTimesDisplay == other.crackTimesDisplay &&
          score == other.score &&
          password == other.password &&
          guesses == other.guesses &&
          guessesLog10 == other.guessesLog10 &&
          sequence == other.sequence &&
          calcTime == other.calcTime;

  @override
  int get hashCode =>
      feedback.hashCode ^
      crackTimesSeconds.hashCode ^
      crackTimesDisplay.hashCode ^
      score.hashCode ^
      password.hashCode ^
      guesses.hashCode ^
      guessesLog10.hashCode ^
      sequence.hashCode ^
      calcTime.hashCode;

  @override
  String toString() => 'Result{'
      'feedback: $feedback, '
      'crackTimesSeconds: $crackTimesSeconds, '
      'crackTimesDisplay: $crackTimesDisplay, '
      'score: $score, '
      'password: $password, '
      'guesses: $guesses, '
      'guessesLog10: $guessesLog10, '
      'sequence: $sequence, '
      'calcTime: $calcTime'
      '}';
}
