import 'package:dart_zxcvbn_language_pl/dart_zxcvbn_language_pl.dart';
import 'package:test/test.dart';

void main() {
  test('should use proper plurals', () {
    final translation = LanguagePl().translations.timeEstimation;

    expect(translation.second(1), equals('1 sekunda'));
    expect(translation.second(2), equals('2 sekundy'));
    expect(translation.second(3), equals('3 sekundy'));
    expect(translation.second(4), equals('4 sekundy'));
    expect(translation.second(5), equals('5 sekund'));
    expect(translation.second(22), equals('22 sekundy'));
  });
}
