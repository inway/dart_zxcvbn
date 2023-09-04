part of 'zxcvbn.dart';

class CrackTimesSeconds {
  final double onlineThrottling100PerHour;
  final double onlineNoThrottling10PerSecond;
  final double offlineSlowHashing1e4PerSecond;
  final double offlineFastHashing1e10PerSecond;

  const CrackTimesSeconds({
    required this.onlineThrottling100PerHour,
    required this.onlineNoThrottling10PerSecond,
    required this.offlineSlowHashing1e4PerSecond,
    required this.offlineFastHashing1e10PerSecond,
  });

  factory CrackTimesSeconds.fromJson(Map<String, dynamic> json) =>
      CrackTimesSeconds(
        onlineThrottling100PerHour:
            double.tryParse(json['onlineThrottling100PerHour'].toString()) ??
                0.0,
        onlineNoThrottling10PerSecond:
            double.tryParse(json['onlineNoThrottling10PerSecond'].toString()) ??
                0.0,
        offlineSlowHashing1e4PerSecond: double.tryParse(
                json['offlineSlowHashing1e4PerSecond'].toString()) ??
            0.0,
        offlineFastHashing1e10PerSecond: double.tryParse(
                json['offlineFastHashing1e10PerSecond'].toString()) ??
            0.0,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CrackTimesSeconds &&
          runtimeType == other.runtimeType &&
          onlineThrottling100PerHour == other.onlineThrottling100PerHour &&
          onlineNoThrottling10PerSecond ==
              other.onlineNoThrottling10PerSecond &&
          offlineSlowHashing1e4PerSecond ==
              other.offlineSlowHashing1e4PerSecond &&
          offlineFastHashing1e10PerSecond ==
              other.offlineFastHashing1e10PerSecond;

  @override
  int get hashCode =>
      onlineThrottling100PerHour.hashCode ^
      onlineNoThrottling10PerSecond.hashCode ^
      offlineSlowHashing1e4PerSecond.hashCode ^
      offlineFastHashing1e10PerSecond.hashCode;

  @override
  String toString() => 'CrackTimesSeconds{'
      'onlineThrottling100PerHour: $onlineThrottling100PerHour, '
      'onlineNoThrottling10PerSecond: $onlineNoThrottling10PerSecond, '
      'offlineSlowHashing1e4PerSecond: $offlineSlowHashing1e4PerSecond, '
      'offlineFastHashing1e10PerSecond: $offlineFastHashing1e10PerSecond'
      '}';
}

class CrackTimesDisplay {
  final String onlineThrottling100PerHour;
  final String onlineNoThrottling10PerSecond;
  final String offlineSlowHashing1e4PerSecond;
  final String offlineFastHashing1e10PerSecond;

  const CrackTimesDisplay({
    required this.onlineThrottling100PerHour,
    required this.onlineNoThrottling10PerSecond,
    required this.offlineSlowHashing1e4PerSecond,
    required this.offlineFastHashing1e10PerSecond,
  });

  factory CrackTimesDisplay.fromJson(Map<String, dynamic> json) =>
      CrackTimesDisplay(
        onlineThrottling100PerHour: json['onlineThrottling100PerHour'],
        onlineNoThrottling10PerSecond: json['onlineNoThrottling10PerSecond'],
        offlineSlowHashing1e4PerSecond: json['offlineSlowHashing1e4PerSecond'],
        offlineFastHashing1e10PerSecond:
            json['offlineFastHashing1e10PerSecond'],
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CrackTimesDisplay &&
          runtimeType == other.runtimeType &&
          onlineThrottling100PerHour == other.onlineThrottling100PerHour &&
          onlineNoThrottling10PerSecond ==
              other.onlineNoThrottling10PerSecond &&
          offlineSlowHashing1e4PerSecond ==
              other.offlineSlowHashing1e4PerSecond &&
          offlineFastHashing1e10PerSecond ==
              other.offlineFastHashing1e10PerSecond;

  @override
  int get hashCode =>
      onlineThrottling100PerHour.hashCode ^
      onlineNoThrottling10PerSecond.hashCode ^
      offlineSlowHashing1e4PerSecond.hashCode ^
      offlineFastHashing1e10PerSecond.hashCode;

  @override
  String toString() => 'CrackTimesDisplay{'
      'onlineThrottling100PerHour: $onlineThrottling100PerHour, '
      'onlineNoThrottling10PerSecond: $onlineNoThrottling10PerSecond, '
      'offlineSlowHashing1e4PerSecond: $offlineSlowHashing1e4PerSecond, '
      'offlineFastHashing1e10PerSecond: $offlineFastHashing1e10PerSecond'
      '}';
}

class TimeEstimates {
  late final CrackTimesSeconds crackTimesSeconds;
  late final CrackTimesDisplay crackTimesDisplay;
  late final double score;

  TimeEstimates({
    required this.crackTimesSeconds,
    required this.crackTimesDisplay,
    required this.score,
  });

  TimeEstimates.estimateAttackTimes(double guesses) {
    crackTimesSeconds = CrackTimesSeconds(
      onlineThrottling100PerHour: guesses / (100 / 3600),
      onlineNoThrottling10PerSecond: guesses / 10,
      offlineSlowHashing1e4PerSecond: guesses / 1E+4,
      offlineFastHashing1e10PerSecond: guesses / 1E+10,
    );

    crackTimesDisplay = CrackTimesDisplay(
      onlineThrottling100PerHour: _displayTime(
        crackTimesSeconds.onlineThrottling100PerHour,
      ),
      onlineNoThrottling10PerSecond: _displayTime(
        crackTimesSeconds.onlineNoThrottling10PerSecond,
      ),
      offlineSlowHashing1e4PerSecond: _displayTime(
        crackTimesSeconds.offlineSlowHashing1e4PerSecond,
      ),
      offlineFastHashing1e10PerSecond: _displayTime(
        crackTimesSeconds.offlineFastHashing1e10PerSecond,
      ),
    );

    score = _guessesToScore(guesses);
  }

  double _guessesToScore(double guesses) {
    const DELTA = 5;
    if (guesses < 1e3 + DELTA) {
      // risky password: "too guessable"
      return 0;
    }
    if (guesses < 1e6 + DELTA) {
      // modest protection from throttled online attacks: "very guessable"
      return 1;
    }
    if (guesses < 1e8 + DELTA) {
      // modest protection from unthrottled online attacks: "somewhat guessable"
      return 2;
    }
    if (guesses < 1e10 + DELTA) {
      // modest protection from offline attacks: "safely unguessable"
      // assuming a salted, slow hash function like bcrypt, scrypt, PBKDF2, argon, etc
      return 3;
    }
    // strong protection from offline attacks under same scenario: "very unguessable"
    return 4;
  }

  String _displayTime(double seconds) {
    final TranslationTimeEstimationIntl translations =
        zxcvbn.options.translations.timeEstimation;

    dynamic displayStr = translations.centuries;
    int base = 0;

    final List<(int, dynamic)> times = [
      (1, translations.second),
      (Duration.secondsPerMinute, translations.minute),
      (Duration.secondsPerHour, translations.hour),
      (Duration.secondsPerDay, translations.day),
      (Duration.secondsPerDay * 31, translations.month),
      (Duration.secondsPerDay * 31 * 12, translations.year),
      (Duration.secondsPerDay * 31 * 12 * 100, translations.centuries),
    ];

    int foundIndex = times.indexWhere((element) => seconds < element.$1);

    if (foundIndex == 0) {
      displayStr = translations.ltSecond;
    } else if (foundIndex > 0) {
      final time = times[foundIndex - 1];
      displayStr = time.$2;
      base = (seconds / time.$1).round();
    }

    return displayStr is TranslationTimeEstimationIntlPlurals
        ? displayStr(base)
        : displayStr;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimeEstimates &&
          runtimeType == other.runtimeType &&
          crackTimesSeconds == other.crackTimesSeconds &&
          crackTimesDisplay == other.crackTimesDisplay &&
          score == other.score;

  @override
  int get hashCode =>
      crackTimesSeconds.hashCode ^ crackTimesDisplay.hashCode ^ score.hashCode;

  @override
  String toString() => 'TimeEstimates{\n'
      '\tcrackTimesSeconds: $crackTimesSeconds, \n'
      '\tcrackTimesDisplay: $crackTimesDisplay, \n'
      '\tscore: $score\n'
      '}';
}
