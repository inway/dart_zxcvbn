part of 'base.dart';

Translations _translations = Translations(
  warnings: TranslationWarnings(
    straightRow: 'Straight rows of keys on your keyboard are easy to guess.',
    keyPattern: 'Short keyboard patterns are easy to guess.',
    simpleRepeat: 'Repeated characters like "aaa" are easy to guess.',
    extendedRepeat:
        'Repeated character patterns like "abcabcabc" are easy to guess.',
    sequences: 'Common character sequences like "abc" are easy to guess.',
    recentYears: 'Recent years are easy to guess.',
    dates: 'Dates are easy to guess.',
    topTen: 'This is a heavily used password.',
    topHundred: 'This is a frequently used password.',
    common: 'This is a commonly used password.',
    similarToCommon: 'This is similar to a commonly used password.',
    wordByItself: 'Single words are easy to guess.',
    namesByThemselves: 'Single names or surnames are easy to guess.',
    commonNames: 'Common names and surnames are easy to guess.',
    userInputs: 'There should not be any personal or page related data.',
    pwned: 'Your password was exposed by a data breach on the Internet.',
  ),
  suggestions: TranslationSuggestions(
    l33t: "Avoid predictable letter substitutions like '@' for 'a'.",
    reverseWords: 'Avoid reversed spellings of common words.',
    allUppercase: 'Capitalize some, but not all letters.',
    capitalization: 'Capitalize more than the first letter.',
    dates: 'Avoid dates and years that are associated with you.',
    recentYears: 'Avoid recent years.',
    associatedYears: 'Avoid years that are associated with you.',
    sequences: 'Avoid common character sequences.',
    repeated: 'Avoid repeated words and characters.',
    longerKeyboardPattern:
        'Use longer keyboard patterns and change typing direction multiple times.',
    anotherWord: 'Add more words that are less common.',
    useWords: 'Use multiple words, but avoid common phrases.',
    noNeed:
        'You can create strong passwords without using symbols, numbers, or uppercase letters.',
    pwned: 'If you use this password elsewhere, you should change it.',
  ),
  timeEstimation: TranslationTimeEstimationIntl(
    ltSecond: 'less than a second',
    second: (int seconds) => Intl.withLocale(
        'en',
        () => Intl.plural(
              seconds,
              one: '$seconds second',
              other: '$seconds seconds',
            )),
    minute: (int minutes) => Intl.withLocale(
        'en',
        () => Intl.plural(
              minutes,
              one: '$minutes minute',
              other: '$minutes minutes',
            )),
    hour: (int hours) => Intl.withLocale(
        'en',
        () => Intl.plural(
              hours,
              one: '$hours hour',
              other: '$hours hours',
            )),
    day: (int days) => Intl.withLocale(
        'en',
        () => Intl.plural(
              days,
              one: '$days day',
              other: '$days days',
            )),
    month: (int months) => Intl.withLocale(
        'en',
        () => Intl.plural(
              months,
              one: '$months month',
              other: '$months months',
            )),
    year: (int years) => Intl.withLocale(
        'en',
        () => Intl.plural(
              years,
              one: '$years year',
              other: '$years years',
            )),
    centuries: 'centuries',
  ),
);
