import 'package:dart_zxcvbn_language_common/dart_zxcvbn_language_common.dart';
import 'package:test/test.dart';
import 'package:dart_zxcvbn/dart_zxcvbn.dart';
import 'package:dart_zxcvbn_language_en/dart_zxcvbn_language_en.dart';

void main() {
  final common = LanguageCommon();
  final languageEn = LanguageEn();

  setUp(() {
    zxcvbn.setOptions(Options(
      dictionary: Dictionary.merge([
        common.dictionary,
        languageEn.dictionary,
      ]),
      graphs: common.adjacencyGraphs,
      translations: languageEn.translations,
    ));
  });

  test('should check without userInputs', () {
    final result = zxcvbn('test');

    expect(result, isA<Result>());
    expect(result.calcTime, isNonNegative);
    expect(result.password, equals('test'));
    expect(result.score, equals(0));
    expect(result.guesses, equals(116));
    expect(result.guessesLog10, equals(2.064457989226918));
    expect(result.sequence, hasLength(1));
    expect(result.sequence[0], isA<DictionaryGuess>());
    expect(
      result.sequence[0],
      equals(
        DictionaryGuess(
          pattern: 'dictionary',
          i: 0,
          j: 3,
          token: 'test',
          dictionaryName: 'passwords',
          l33t: false,
          levenshteinDistance: null,
          levenshteinDistanceEntry: null,
          matchedWord: 'test',
          rank: 115,
          reversed: false,
          guesses: 115.0,
          guessesLog10: 2.0606978403536114,
          extraData: {
            'baseGuesses': 115.0,
            'uppercaseVariations': 1.0,
            'l33tVariations': 1.0,
          },
        ),
      ),
    );
    expect(result.feedback, isA<Feedback>());
    expect(
      result.feedback,
      equals(
        Feedback(
          warning: 'This is a commonly used password.',
          suggestions: ['Add more words that are less common.'],
        ),
      ),
    );
    expect(
      result.crackTimesSeconds,
      equals(
        CrackTimesSeconds(
          onlineThrottling100PerHour: 4176,
          onlineNoThrottling10PerSecond: 11.6,
          offlineSlowHashing1e4PerSecond: 0.0116,
          offlineFastHashing1e10PerSecond: 1.16e-8,
        ),
      ),
    );
    expect(
      result.crackTimesDisplay,
      equals(
        CrackTimesDisplay(
          onlineThrottling100PerHour: '1 hour',
          onlineNoThrottling10PerSecond: '12 seconds',
          offlineSlowHashing1e4PerSecond: 'less than a second',
          offlineFastHashing1e10PerSecond: 'less than a second',
        ),
      ),
    );
  });

  test('should check with userInputs', () {
    /// Original test passed an array of string, number, boolean and array, but
    /// as Dart is type safe with static type checking we can't do that. Instead
    /// we pass an array of strings that match resulting stringification of
    /// parameters in Javascript.
    zxcvbn.setOptions(Options(
      dictionary: Dictionary({
        'userInputs': ['test', '12', 'true', ''],
      }),
    ));
    final result = zxcvbn('test');

    expect(result, isA<Result>());
    expect(result.calcTime, isNonNegative);
    expect(result.password, equals('test'));
    expect(result.score, equals(0));
    expect(result.guesses, equals(2));
    expect(result.guessesLog10, equals(0.30102999566398114));
    expect(result.sequence, hasLength(1));
    expect(result.sequence[0], isA<DictionaryGuess>());
    expect(
      result.sequence[0],
      equals(
        DictionaryGuess(
          pattern: 'dictionary',
          i: 0,
          j: 3,
          token: 'test',
          dictionaryName: 'userInputs',
          l33t: false,
          levenshteinDistance: null,
          levenshteinDistanceEntry: null,
          matchedWord: 'test',
          rank: 1,
          reversed: false,
          guesses: 1.0,
          guessesLog10: 0.0,
          extraData: {
            'baseGuesses': 1.0,
            'uppercaseVariations': 1.0,
            'l33tVariations': 1.0,
          },
        ),
      ),
    );
    expect(result.feedback, isA<Feedback>());
    expect(
      result.feedback,
      equals(
        Feedback(
          warning: languageEn.translations.warnings.userInputs,
          suggestions: [languageEn.translations.suggestions.anotherWord],
        ),
      ),
    );
    expect(
      result.crackTimesSeconds,
      equals(
        CrackTimesSeconds(
          offlineFastHashing1e10PerSecond: 2e-10,
          offlineSlowHashing1e4PerSecond: 0.0002,
          onlineNoThrottling10PerSecond: 0.2,
          onlineThrottling100PerHour: 72,
        ),
      ),
    );
    expect(
      result.crackTimesDisplay,
      equals(
        CrackTimesDisplay(
          offlineFastHashing1e10PerSecond: 'less than a second',
          offlineSlowHashing1e4PerSecond: 'less than a second',
          onlineNoThrottling10PerSecond: 'less than a second',
          onlineThrottling100PerHour: '1 minute',
        ),
      ),
    );
  });

  test('should check with userInputs on the fly', () {
    final result = zxcvbn('onTheFly', userInputs: ['onTheFly']);

    expect(result, isA<Result>());
    expect(result.calcTime, isNonNegative);
    expect(result.password, equals('onTheFly'));
    expect(result.score, equals(0), reason: 'score');
    expect(result.guesses, equals(37), reason: 'guesses');
    expect(result.guessesLog10, equals(1.5682017240669948),
        reason: 'guessesLog10');
    expect(result.sequence, hasLength(1));
    expect(result.sequence[0], isA<DictionaryGuess>());
    expect(
      result.sequence[0],
      equals(
        DictionaryGuess(
          pattern: 'dictionary',
          i: 0,
          j: 7,
          token: 'onTheFly',
          dictionaryName: 'userInputs',
          l33t: false,
          levenshteinDistance: null,
          levenshteinDistanceEntry: null,
          matchedWord: 'onthefly',
          rank: 1,
          reversed: false,
          guesses: 36.0,
          guessesLog10: 1.556302500767287,
          extraData: {
            'baseGuesses': 1.0,
            'uppercaseVariations': 36.0,
            'l33tVariations': 1.0,
          },
        ),
      ),
    );
    expect(result.feedback, isA<Feedback>());
    expect(
      result.feedback,
      equals(
        Feedback(
          warning: languageEn.translations.warnings.userInputs,
          suggestions: [languageEn.translations.suggestions.anotherWord],
        ),
      ),
    );
    expect(
      result.crackTimesSeconds,
      equals(
        CrackTimesSeconds(
          offlineFastHashing1e10PerSecond: 3.7e-9,
          offlineSlowHashing1e4PerSecond: 0.0037,
          onlineNoThrottling10PerSecond: 3.7,
          onlineThrottling100PerHour: 1332,
        ),
      ),
    );
    expect(
      result.crackTimesDisplay,
      equals(
        CrackTimesDisplay(
          offlineFastHashing1e10PerSecond: 'less than a second',
          offlineSlowHashing1e4PerSecond: 'less than a second',
          onlineNoThrottling10PerSecond: '4 seconds',
          onlineThrottling100PerHour: '22 minutes',
        ),
      ),
    );
  });
}
