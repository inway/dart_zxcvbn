import 'dart:isolate';

import 'package:dart_zxcvbn/dart_zxcvbn.dart';
import 'package:dart_zxcvbn_language_common/dart_zxcvbn_language_common.dart';
import 'package:dart_zxcvbn_language_en/dart_zxcvbn_language_en.dart';
import 'package:flutter/material.dart';
import 'package:flutter_password_scoring/flutter_password_scoring.dart';

Future<void> handleScoring(SendPort sendPort) async {
  ReceivePort receivePort = ReceivePort();
  sendPort.send(receivePort.sendPort);

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

  await for (var message in receivePort) {
    if (message is Locale) {
      zxcvbn.setOptions(Options(
        translations: message.languageCode == 'en'
            ? langEn.translations
            : langCommon.translations,
      ));
    } else if (message is String) {
      lastPassword = message;
    }

    final result = zxcvbn(lastPassword);

    sendPort.send(result);
  }
}

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: PasswordScoringBuilder(
            handler: handleScoring,
            loadingPlaceholder: const CircularProgressIndicator(),
            builder: (
              BuildContext context,
              Result? data,
              PasswordScoringHelper helper,
            ) {
              final TextTheme theme = Theme.of(context).textTheme;

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(
                        onChanged: helper.update,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      if (data != null)
                        Column(
                          children: [
                            Text('Password: ${data.password}'),
                            Text('Score: ${data.score} / 4'),
                            Text('guessesLog10: ${data.guessesLog10}'),
                            Text('guesses: ${data.guesses}'),
                            if (data.feedback.warning != null)
                              Text(
                                'Warning:',
                                style: theme.titleMedium,
                              ),
                            if (data.feedback.warning != null)
                              Text(data.feedback.warning!),
                            const SizedBox(height: 8),
                            Text(
                              'Suggestions:',
                              style: theme.titleMedium,
                            ),
                            for (var suggestion in data.feedback.suggestions)
                              Text(suggestion),
                          ],
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
