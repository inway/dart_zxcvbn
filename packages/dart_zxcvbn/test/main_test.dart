import 'package:dart_zxcvbn_language_common/dart_zxcvbn_language_common.dart';
import 'package:test/test.dart';
import 'package:dart_zxcvbn/dart_zxcvbn.dart';
import 'package:dart_zxcvbn_language_en/dart_zxcvbn_language_en.dart';

void main() {
  final common = LanguageCommon();
  zxcvbn.setOptions(Options(
    dictionary: Dictionary.merge([
      common.dictionary,
      LanguageEn().dictionary,
    ]),
    graphs: common.adjacencyGraphs,
    translations: LanguageEn().translations,
  ));

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
}
