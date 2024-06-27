[![flutter_password_scoring](https://img.shields.io/pub/v/flutter_password_scoring.svg)](https://pub.dev/packages/flutter_password_scoring)
[![flutter_password_scoring](https://img.shields.io/github/license/inway/dart_zxcvbn)](LICENSE)
[![flutter_password_scoring](https://github.com/inway/dart_zxcvbn/actions/workflows/dart.yml/badge.svg)](https://github.com/inway/dart_zxcvbn/actions/workflows/dart.yml)
[![melos](https://img.shields.io/badge/maintained%20with-melos-f700ff.svg?style=flat-square)](https://github.com/inway/dart_zxcvbn)

# flutter_password_scoring

❗ THIS PACKAGE IS STILL WORK IN PROGRESS ❗

## Description

The primary goal of this package is to support `dart_zxcvbn` in Flutter.

This package supplies two kinds of password scoring handlers. The default one
`PasswordScoringHandler` doesn't use Isolates, so everything runs on main
thread. It is Web friendly (remember no Isolates on Web platform in Flutter),
but it also can block main thread for long time. As an alternative there's also
Isolate based handler which you can use on mobile on native platform.

## Usage

Use `PasswordScoringBuilder` to build your UI. Take a look at example code if
you wan't to customize dictionaries and other options based on `Locale`.

```dart
/// Keep in mind that when using Isolate based handler it's
/// crucial to keep it final in state, so it won't be
/// recreated on every call to [build].
final handler = kIsWeb
    ? PasswordScoringHandler()
    : PasswordScoringIsolateHandler();

PasswordScoringBuilder(
  handler: handler,
  loadingPlaceholder: const Center(
    child: CircularProgressIndicator(),
  ),
  builder: (
    BuildContext context,
    Result? data,
    PasswordScoringHandler handler,
  ) {
  /// Call [handler.update] every time user entered password changes
  return Placeholder();
  },
);
```

## Related packages

| Package                     | Details                                                                                                                                                                |
| --------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| dart_zxcvbn                 | [README](https://github.com/inway/dart_zxcvbn/blob/main/packages/dart_zxcvbn/README.md) \| [pub](https://pub.dev/packages/dart_zxcvbn)                                 |
| dart_zxcvbn_language_common | [README](https://github.com/inway/dart_zxcvbn/blob/main/packages/dart_zxcvbn_language_common/README.md) \| [pub](https://pub.dev/packages/dart_zxcvbn_language_common) |
| dart_zxcvbn_language_en     | [README](https://github.com/inway/dart_zxcvbn/blob/main/packages/dart_zxcvbn_language_en/README.md) \| [pub](https://pub.dev/packages/dart_zxcvbn_language_en)         |
| dart_zxcvbn_language_pl     | [README](https://github.com/inway/dart_zxcvbn/blob/main/packages/dart_zxcvbn_language_pl/README.md) \| [pub](https://pub.dev/packages/dart_zxcvbn_language_pl)         |
| flutter_password_scoring    | [README](https://github.com/inway/dart_zxcvbn/blob/main/packages/flutter_password_scoring/README.md) \| [pub](https://pub.dev/packages/flutter_password_scoring)       |

## License

- see [LICENSE](https://github.com/inway/dart_zxcvbn/LICENSE)
