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

  test('#18 Invalid argument(s): match is not a SpatialGuess', () {
    final result = zxcvbn('qwe');

    expect(result, isA<Result>());

    // TODO expectations below should be moved to a separate test in stable
    // version
    expect(result.sequence, hasLength(1));
    expect(result.sequence[0], isA<EstimatedGuess>());
    expect(
      result.sequence[0],
      equals(
        EstimatedGuess(
          pattern: 'spatial',
          i: 0,
          j: 2,
          token: 'qwe',
          guesses: 864.0,
          guessesLog10: 2.9365137424788927,
          extraData: {},
        ),
      ),
    );
    expect(result.feedback, isA<Feedback>());
    expect(
      result.feedback,
      equals(
        Feedback(
          warning: languageEn.translations.warnings.keyPattern,
          suggestions: [
            languageEn.translations.suggestions.anotherWord,
            languageEn.translations.suggestions.longerKeyboardPattern
          ],
        ),
      ),
    );
  });
}
