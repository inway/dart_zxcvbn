import 'package:dart_zxcvbn_language_en/dart_zxcvbn_language_en.dart';
import 'package:test/test.dart';

void main() {
  test('should use proper plurals', () {
    final translation = LanguageEn().translations.timeEstimation;

    expect(translation.second(1), equals('1 second'));
    expect(translation.second(2), equals('2 seconds'));
  });
}
