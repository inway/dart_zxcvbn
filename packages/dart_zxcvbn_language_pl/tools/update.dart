import 'dart:io';

import 'package:dart_zxcvbn_tools/dart_zxcvbn_tools.dart';

final baseUrl = Uri.parse('https://raw.githubusercontent.com/zxcvbn-ts/zxcvbn/'
    'master/packages/languages/pl/src/');

main() async {
  await fetchList(
    baseUrl: baseUrl,
    fileName: 'commonWords.json',
    targetFile: 'lib/src/common_words.dart',
    variableName: '_commonWords',
  );

  await fetchList(
    baseUrl: baseUrl,
    fileName: 'femaleFirstnames.json',
    targetFile: 'lib/src/female_firstnames.dart',
    variableName: '_femaleFirstnames',
  );

  await fetchList(
    baseUrl: baseUrl,
    fileName: 'femaleLastnames.json',
    targetFile: 'lib/src/female_lastnames.dart',
    variableName: '_femaleLastnames',
  );

  await fetchList(
    baseUrl: baseUrl,
    fileName: 'maleFirstnames.json',
    targetFile: 'lib/src/male_firstnames.dart',
    variableName: '_maleFirstnames',
  );

  await fetchList(
    baseUrl: baseUrl,
    fileName: 'maleLastnames.json',
    targetFile: 'lib/src/male_lastnames.dart',
    variableName: '_maleLastnames',
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
