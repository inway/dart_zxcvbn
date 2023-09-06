[![flutter_password_scoring](https://img.shields.io/pub/v/flutter_password_scoring.svg)](https://pub.dev/packages/flutter_password_scoring)
[![flutter_password_scoring](https://img.shields.io/github/license/inway/dart_zxcvbn)](LICENSE)
[![flutter_password_scoring](https://github.com/inway/dart_zxcvbn/actions/workflows/dart.yml/badge.svg)](https://github.com/inway/dart_zxcvbn/actions/workflows/dart.yml)
[![melos](https://img.shields.io/badge/maintained%20with-melos-f700ff.svg?style=flat-square)](https://github.com/inway/dart_zxcvbn)

# flutter_password_scoring

❗ THIS PACKAGE IS STILL WORK IN PROGRESS ❗

## Description

The primary goal of this package is to support `dart_zxcvbn` in Flutter.

To achieve this and, as much as possible, not block the main thread and avoid
dropped frames, we create an `Isolate` in which the `dart_zxcvbn` library is
initialized and where further user password evaluations take place. Responses
from the library are passed to the `PasswordScoringBuilder` (which acts as a
facade for `StreamBuilder`), and that's where the widget tree is constructed.

## Usage

1. Declare default handler for scorer isolate somewhere in your code - it has to
   be global function or static member of some class!

   ```dart
   import 'dart:isolate';

   import 'package:dart_zxcvbn/dart_zxcvbn.dart';
   import 'package:dart_zxcvbn_language_common/dart_zxcvbn_language_common.dart';
   import 'package:dart_zxcvbn_language_en/dart_zxcvbn_language_en.dart';

   Future<void> handleScoring(SendPort sendPort) async {
     ReceivePort receiverPort = ReceivePort();
     sendPort.send(receiverPort.sendPort);

     final langCommon = LanguageCommon();
     final langEn = LanguageEn();

     zxcvbn.setOptions(Options(
       dictionary: Dictionary.merge([
         langCommon.dictionary,
         langEn.dictionary,
       ]),
       graphs: langCommon.adjacencyGraphs,
       translations: langCommon.translations,
     ));

     // Used to refresh response when locale changes
     String lastPassword = '';

     await for (var message in receiverPort) {
       if (message is Locale) {
         zxcvbn.setOptions(Options(
           translations: message.languageCode == 'en'
               ? langEn.translations
               : langCommon.translations,
         ));
       }

       lastPassword = message is String ? message : lastPassword;
       if (lastPassword.isNotEmpty) {
         final result = zxcvbn(lastPassword);

         sendPort.send(result);
       }
     }
   }
   ```

2. Use `PasswordScoringBuilder` to build your UI

   ```dart
   PasswordScoringBuilder(
     handler: handleScoring,
     loadingPlaceholder: const Center(
       child: CircularProgressIndicator(),
     ),
     builder: (
       BuildContext context,
       Result? data,
       PasswordScoringHelper helper,
     ) {
      return Placeholder();
     },
   );
   ```

## Related packages

| Package                     | Details                                                                                                                 |
| --------------------------- | ----------------------------------------------------------------------------------------------------------------------- |
| dart_zxcvbn                 | [README](packages/dart_zxcvbn/README.md) \| [pub](https://pub.dev/packages/dart_zxcvbn)                                 |
| dart_zxcvbn_language_common | [README](packages/dart_zxcvbn_language_common/README.md) \| [pub](https://pub.dev/packages/dart_zxcvbn_language_common) |
| dart_zxcvbn_language_en     | [README](packages/dart_zxcvbn_language_en/README.md) \| [pub](https://pub.dev/packages/dart_zxcvbn_language_en)         |
| dart_zxcvbn_language_pl     | [README](packages/dart_zxcvbn_language_pl/README.md) \| [pub](https://pub.dev/packages/dart_zxcvbn_language_pl)         |
| flutter_password_scoring    | [README](packages/flutter_password_scoring/README.md) \| [pub](https://pub.dev/packages/flutter_password_scoring)       |

## License

- see [LICENSE](https://github.com/inway/dart_zxcvbn/LICENSE)
