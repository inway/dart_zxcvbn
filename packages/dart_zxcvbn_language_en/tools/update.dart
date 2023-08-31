import 'dart:io';

import 'package:dart_zxcvbn_tools/dart_zxcvbn_tools.dart';

final baseUrl = Uri.parse('https://raw.githubusercontent.com/zxcvbn-ts/zxcvbn/'
    'master/packages/languages/en/src/');

main() async {
  await fetchList(
    baseUrl: baseUrl,
    fileName: 'commonWords.json',
    targetFile: 'lib/src/common_words.dart',
    variableName: '_commonWords',
  );

  await fetchList(
    baseUrl: baseUrl,
    fileName: 'firstnames.json',
    targetFile: 'lib/src/firstnames.dart',
    variableName: '_firstnames',
  );

  await fetchList(
    baseUrl: baseUrl,
    fileName: 'lastnames.json',
    targetFile: 'lib/src/lastnames.dart',
    variableName: '_lastnames',
  );

  await fetchList(
    baseUrl: baseUrl,
    fileName: 'wikipedia.json',
    targetFile: 'lib/src/wikipedia.dart',
    variableName: '_wikipedia',
  );

  // Format all
  var result = await Process.run('dart', ['format', 'lib']);
  stdout.write(result.stdout);
  stderr.write(result.stderr);
}
