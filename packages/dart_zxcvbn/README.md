[![dart_zxcvbn](https://img.shields.io/pub/v/dart_zxcvbn.svg)](https://pub.dev/packages/dart_zxcvbn)
[![dart_zxcvbn](https://img.shields.io/github/license/inway/dart_zxcvbn)](LICENSE)
[![dart_zxcvbn](https://github.com/inway/dart_zxcvbn/actions/workflows/dart.yml/badge.svg)](https://github.com/inway/dart_zxcvbn/actions/workflows/dart.yml)
[![melos](https://img.shields.io/badge/maintained%20with-melos-f700ff.svg?style=flat-square)](https://github.com/inway/dart_zxcvbn)

# dart_zxcvbn

❗ THIS PACKAGE IS STILL WORK IN PROGRESS ❗

## Description

This package is a Dart port of
[@zxcvbn-ts/zxcvbn](https://github.com/zxcvbn-ts/zxcvbn), which is a Typescript
rewrite of the original library [zxcvbn](https://github.com/dropbox/zxcvbn) from
[Dropbox](https://github.com/dropbox).

## Usage

```dart
import 'package:dart_zxcvbn/dart_zxcvbn.dart';
import 'package:dart_zxcvbn_language_common/dart_zxcvbn_language_common.dart';
import 'package:dart_zxcvbn_language_en/dart_zxcvbn_language_en.dart';

final common = LanguageCommon();
zxcvbn.setOptions(Options(
  dictionary: Dictionary.merge([
    common.dictionary,
    LanguageEn().dictionary,
  ]),
  graphs: common.adjacencyGraphs,
  translations: LanguageEn().translations,
));

final result = zxcvbn('test');
```

## Related packages

This is a melos managed monorepo containing the following packages:

| Package                     | Details                                                                                                              |
| --------------------------- | -------------------------------------------------------------------------------------------------------------------- |
| dart_zxcvbn                 | [README](packages/dart_zxcvbn/README.md) [pub](https://pub.dev/packages/dart_zxcvbn)                                 |
| dart_zxcvbn_language_common | [README](packages/dart_zxcvbn_language_common/README.md) [pub](https://pub.dev/packages/dart_zxcvbn_language_common) |
| dart_zxcvbn_language_en     | [README](packages/dart_zxcvbn_language_en/README.md) [pub](https://pub.dev/packages/dart_zxcvbn_language_en)         |
| dart_zxcvbn_language_pl     | [README](packages/dart_zxcvbn_language_pl/README.md) [pub](https://pub.dev/packages/dart_zxcvbn_language_pl)         |
| dart_zxcvbn_tools           | [README](packages/dart_zxcvbn_tools/README.md) [pub](https://pub.dev/packages/dart_zxcvbn_tools)                     |
| flutter_password_scoring    | [README](packages/flutter_password_scoring/README.md) [pub](https://pub.dev/packages/flutter_password_scoring)       |

## TODO

- [ ] Async matching
- [ ] date matcher
- [ ] dictionary matcher
  - [x] dictionary (bruteforce) matcher
  - [ ] dictionary (l33t) matcher
  - [x] dictionary (reverse) matcher
- [ ] regex matcher
- [ ] repeat matcher
- [x] sequence matcher
- [x] spatial matcher
- [ ] after implementing all matchers and passing all upstream tests with the
      same results, refactor library and try to remove 'part/part of' in favor of
      'import/export'

## Credits

- Huge thanks goes to creators of
  [@zxcvbn-ts/zxcvbn](https://github.com/zxcvbn-ts/zxcvbn) which is a solid
  foundation for this Dart port
- We use levenshtein implementation from
  [brinkler/levenshtein-dart](https://github.com/brinkler/levenshtein-dart)
  which was released as Public Domain

## License

- see [LICENSE](https://github.com/inway/dart_zxcvbn/LICENSE)
