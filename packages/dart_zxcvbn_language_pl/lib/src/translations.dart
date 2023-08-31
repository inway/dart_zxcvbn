part of 'base.dart';

Translations _translations = Translations(
  warnings: TranslationWarnings(
    straightRow:
        'Występujące kolejno po sobie znaki na klawiaturze są łatwe do odgadnięcia.',
    keyPattern: 'Krótkie wzory klawiaturowe są łatwe do odgadnięcia.',
    simpleRepeat:
        'Powtarzające się znaki, takie jak „aaa”, są łatwe do odgadnięcia.',
    extendedRepeat:
        'Powtarzające się wzorce znaków, takie jak „abcabcabc”, są łatwe do odgadnięcia.',
    sequences:
        'Typowe sekwencje znaków, takie jak „abc”, są łatwe do odgadnięcia.',
    recentYears: 'Ostatnie lata są łatwe do odgadnięcia',
    dates: 'Daty są łatwe do odgadnięcia.',
    topTen: 'To jest przesadnie często używane hasło.',
    topHundred: 'To jest bardzo często używane hasło.',
    common: 'To jest często używane hasło.',
    similarToCommon: 'To jest podobne do często używanego hasła.',
    wordByItself: 'Pojedyncze słowa są łatwe do odgadnięcia.',
    namesByThemselves:
        'Pojedyncze imiona lub nazwiska są łatwe do odgadnięcia.',
    commonNames: 'Popularne imiona i nazwiska są łatwe do odgadnięcia.',
    userInputs:
        'Nie powinno być żadnych danych osobowych, ani danych dotyczących strony.',
    pwned:
        'To hasło zostało już ujawnione w wyniku naruszenia bezpieczeństwa danych w Internecie.',
  ),
  suggestions: TranslationSuggestions(
    l33t:
        'Unikaj przewidywalnych podstawień liter, takich jak „@” zamiast „a”.',
    reverseWords: 'Unikaj pisowni popularnych słów na wspak.',
    allUppercase:
        'Niektóre litery napisz wielkimi literami, lecz nie wszystkie.',
    capitalization: 'Używaj wielkiej litery, nie tylko na początku.',
    dates: 'Unikaj dat i lat, które są z Tobą powiązane.',
    recentYears: 'Unikaj ostatnich lat.',
    associatedYears: 'Unikaj lat, które są z Tobą powiązane.',
    sequences: 'Unikaj typowych sekwencji znaków.',
    repeated: 'Unikaj powtarzających się słów i znaków.',
    longerKeyboardPattern:
        'Używaj dłuższych wzorów klawiaturowych i wielokrotnie zmieniaj kierunek pisania.',
    anotherWord: 'Dodaj więcej słów, które są mniej popularne.',
    useWords: 'Używaj wielu słów, ale unikaj popularnych fraz.',
    noNeed:
        'Możesz tworzyć silne hasła bez używania symboli, cyfr lub wielkich liter.',
    pwned:
        'Jeśli używasz tego hasła gdzie indziej, powinieneś je zmienić jak najszybciej.',
  ),
  timeEstimation: TranslationTimeEstimationIntl(
    ltSecond: 'mniej niż sekunda',
    second: (int seconds) => Intl.withLocale(
        'pl',
        () => Intl.plural(
              seconds,
              one: '$seconds sekunda',
              two: '$seconds sekundy',
              few: '$seconds sekundy',
              other: '$seconds sekund',
            )),
    minute: (int minutes) => Intl.withLocale(
        'pl',
        () => Intl.plural(
              minutes,
              one: '$minutes minuta',
              two: '$minutes minuty',
              few: '$minutes minuty',
              other: '$minutes minut',
            )),
    hour: (int hours) => Intl.withLocale(
        'pl',
        () => Intl.plural(
              hours,
              one: '$hours godzina',
              two: '$hours godziny',
              few: '$hours godziny',
              other: '$hours godzin',
            )),
    day: (int days) => Intl.withLocale(
        'pl',
        () => Intl.plural(
              days,
              one: '$days dzień',
              two: '$days dni',
              few: '$days dni',
              other: '$days dni',
            )),
    month: (int months) => Intl.withLocale(
        'pl',
        () => Intl.plural(
              months,
              one: '$months miesiąc',
              two: '$months miesiące',
              few: '$months miesiące',
              other: '$months miesięcy',
            )),
    year: (int years) => Intl.withLocale(
        'pl',
        () => Intl.plural(
              years,
              one: '$years rok',
              two: '$years lata',
              few: '$years lata',
              other: '$years lat',
            )),
    centuries: 'wieki',
  ),
);
