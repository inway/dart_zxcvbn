part of 'zxcvbn.dart';

class TranslationWarnings {
  final String straightRow;
  final String keyPattern;
  final String simpleRepeat;
  final String extendedRepeat;
  final String sequences;
  final String recentYears;
  final String dates;
  final String topTen;
  final String topHundred;
  final String common;
  final String similarToCommon;
  final String wordByItself;
  final String namesByThemselves;
  final String commonNames;
  final String userInputs;
  final String pwned;

  const TranslationWarnings({
    this.straightRow = 'straightRow',
    this.keyPattern = 'keyPattern',
    this.simpleRepeat = 'simpleRepeat',
    this.extendedRepeat = 'extendedRepeat',
    this.sequences = 'sequences',
    this.recentYears = 'recentYears',
    this.dates = 'dates',
    this.topTen = 'topTen',
    this.topHundred = 'topHundred',
    this.common = 'common',
    this.similarToCommon = 'similarToCommon',
    this.wordByItself = 'wordByItself',
    this.namesByThemselves = 'namesByThemselves',
    this.commonNames = 'commonNames',
    this.userInputs = 'userInputs',
    this.pwned = 'pwned',
  });
}

class TranslationSuggestions {
  final String l33t;
  final String reverseWords;
  final String allUppercase;
  final String capitalization;
  final String dates;
  final String recentYears;
  final String associatedYears;
  final String sequences;
  final String repeated;
  final String longerKeyboardPattern;
  final String anotherWord;
  final String useWords;
  final String noNeed;
  final String pwned;

  const TranslationSuggestions({
    this.l33t = 'l33t',
    this.reverseWords = 'reverseWords',
    this.allUppercase = 'allUppercase',
    this.capitalization = 'capitalization',
    this.dates = 'dates',
    this.recentYears = 'recentYears',
    this.associatedYears = 'associatedYears',
    this.sequences = 'sequences',
    this.repeated = 'repeated',
    this.longerKeyboardPattern = 'longerKeyboardPattern',
    this.anotherWord = 'anotherWord',
    this.useWords = 'useWords',
    this.noNeed = 'noNeed',
    this.pwned = 'pwned',
  });
}

/// @deprecated Use [TranslationTimeEstimationIntl] instead.
class TranslationTimeEstimation {
  final String ltSecond;
  final String second;
  final String seconds;
  final String minute;
  final String minutes;
  final String hour;
  final String hours;
  final String day;
  final String days;
  final String month;
  final String months;
  final String year;
  final String years;
  final String centuries;

  const TranslationTimeEstimation({
    this.ltSecond = 'ltSecond',
    this.second = 'second',
    this.seconds = 'seconds',
    this.minute = 'minute',
    this.minutes = 'minutes',
    this.hour = 'hour',
    this.hours = 'hours',
    this.day = 'day',
    this.days = 'days',
    this.month = 'month',
    this.months = 'months',
    this.year = 'year',
    this.years = 'years',
    this.centuries = 'centuries',
  });
}

typedef String TranslationTimeEstimationIntlPlurals(int value);

class TranslationTimeEstimationIntl {
  final String ltSecond;
  final TranslationTimeEstimationIntlPlurals second;
  final TranslationTimeEstimationIntlPlurals minute;
  final TranslationTimeEstimationIntlPlurals hour;
  final TranslationTimeEstimationIntlPlurals day;
  final TranslationTimeEstimationIntlPlurals month;
  final TranslationTimeEstimationIntlPlurals year;
  final String centuries;

  TranslationTimeEstimationIntl({
    this.ltSecond = 'ltSecond',
    TranslationTimeEstimationIntlPlurals? second,
    TranslationTimeEstimationIntlPlurals? minute,
    TranslationTimeEstimationIntlPlurals? hour,
    TranslationTimeEstimationIntlPlurals? day,
    TranslationTimeEstimationIntlPlurals? month,
    TranslationTimeEstimationIntlPlurals? year,
    this.centuries = 'centuries',
  })  : this.second = second ?? ((int value) => 'second'),
        this.minute = minute ?? ((int value) => 'minute'),
        this.hour = hour ?? ((int value) => 'hour'),
        this.day = day ?? ((int value) => 'day'),
        this.month = month ?? ((int value) => 'month'),
        this.year = year ?? ((int value) => 'year');
}

class Translations {
  final TranslationWarnings warnings;
  final TranslationSuggestions suggestions;
  final TranslationTimeEstimationIntl timeEstimation;

  Translations({
    this.warnings = const TranslationWarnings(),
    this.suggestions = const TranslationSuggestions(),
    TranslationTimeEstimationIntl? timeEstimation,
  }) : this.timeEstimation = timeEstimation ?? TranslationTimeEstimationIntl();
}
