import 'dart:isolate';

import 'package:dart_zxcvbn/dart_zxcvbn.dart';
import 'package:dart_zxcvbn_language_common/dart_zxcvbn_language_common.dart';
import 'package:dart_zxcvbn_language_en/dart_zxcvbn_language_en.dart';
import 'package:dart_zxcvbn_language_pl/dart_zxcvbn_language_pl.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_password_scoring/flutter_password_scoring.dart';

import 'results_table.dart';

// This example will use all currently available language packages
final langCommon = LanguageCommon();
final langEn = LanguageEn();
final langPl = LanguagePl();

const List<Locale> supportedLocales = [
  Locale('en'),
  Locale('pl'),
];

/// This function will return [Options] based on the supplied [Locale].
Options getLocaleOptions([Locale? locale]) => Options(
      dictionary: Dictionary.merge([
        langCommon.dictionary,
        if (locale?.languageCode == 'en') langEn.dictionary,
        if (locale?.languageCode == 'pl') langPl.dictionary,
      ]),
      graphs: locale?.languageCode == 'en'
          ? langEn.adjacencyGraphs
          : locale?.languageCode == 'pl'
              ? langPl.adjacencyGraphs
              : langCommon.adjacencyGraphs,
      translations: locale?.languageCode == 'en'
          ? langEn.translations
          : locale?.languageCode == 'pl'
              ? langPl.translations
              : langCommon.translations,
    );

/// This is the [Isolate] handler implementation that will update [dart_zxcvbn]
/// options based on the supplied [Locale].
///
/// See [PasswordScoringIsolateHandler] default implementation
/// [defaultIsolateHandler] for more information.
Future<void> localeAwareHandler(SendPort sendPort) async {
  ReceivePort receivePort = ReceivePort();
  sendPort.send(receivePort.sendPort);

  zxcvbn.setOptions(getLocaleOptions());

  // Used to refresh response for last password when locale changes
  ScoringRequest? lastRequest;

  await for (var message in receivePort) {
    if (message is Locale) {
      zxcvbn.setOptions(getLocaleOptions(message));
    } else if (message is ScoringRequest) {
      lastRequest = message;
    }

    if (lastRequest != null) {
      final Result result = zxcvbn(
        lastRequest.password,
        options: lastRequest.options,
        userInputs: lastRequest.userInputs,
      );
      sendPort.send(result);
    }
  }
}

/// This is the [onInit] callback implementation that will update [dart_zxcvbn]
/// options based on the supplied [Locale].
void localeAwareInit(Locale? locale) {
  zxcvbn.setOptions(
    getLocaleOptions(locale),
  );
}

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  Locale locale = supportedLocales.first;
  List<String> userInputs = [];

  late final PasswordScoringHandler handler;

  @override
  void initState() {
    super.initState();

    handler = kIsWeb
        ? PasswordScoringHandler(onInit: localeAwareInit)
        : PasswordScoringIsolateHandler(handler: localeAwareHandler);
  }

  @override
  Widget build(BuildContext context) {
    const seedColor = Color.fromARGB(255, 130, 0, 169);

    final lightThemeData = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorSchemeSeed: seedColor,
    );
    final darkThemeData = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorSchemeSeed: seedColor,
    );

    const fieldInsets = EdgeInsets.symmetric(
      horizontal: 0,
      vertical: 16,
    );

    return MaterialApp(
      darkTheme: darkThemeData,
      theme: lightThemeData,
      locale: locale,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: supportedLocales,
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: fieldInsets,
                    child: TextField(
                      onChanged: (String value) {
                        setState(() {
                          userInputs = value.split(',');
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'User inputs',
                        helperText: 'Comma separated list of user inputs',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: DropdownMenu<Locale>(
                          initialSelection: locale,
                          label: const Text('Locale'),
                          expandedInsets: fieldInsets,
                          onSelected: (Locale? value) {
                            if (value == null) return;

                            setState(() {
                              locale = value;
                            });
                          },
                          dropdownMenuEntries: supportedLocales
                              .map((Locale value) => DropdownMenuEntry<Locale>(
                                  value: value, label: value.languageCode))
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  PasswordScoringBuilder(
                    handler: handler,
                    loadingPlaceholder: const CircularProgressIndicator(),
                    builder: (
                      BuildContext context,
                      Result? data,
                      PasswordScoringHandler handler,
                    ) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextField(
                            onChanged: (String password) {
                              handler.update(
                                password,
                                userInputs: userInputs,
                              );
                            },
                            decoration: const InputDecoration(
                              labelText: 'Password',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 32),
                          if (data != null) ResultTable(result: data),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
