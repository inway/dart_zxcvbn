import 'dart:io';

import 'package:dart_zxcvbn_tools/dart_zxcvbn_tools.dart';

final baseUrl = Uri.parse('https://raw.githubusercontent.com/zxcvbn-ts/zxcvbn/'
    'master/packages/languages/common/src/');

main() async {
  if (true) {
    final data = await fetchWithCache(baseUrl, 'adjacencyGraphs.json');
    final sink = File('lib/src/adjacency_graphs.dart').openWrite();

    sink.writeln("part of 'base.dart';");
    sink.writeln();
    sink.writeln(
        'class LangageCommonAdjacencyGraphs implements AdjacencyGraphs {');
    for (var key in data.keys) {
      sink.writeln('');
      sink.writeln('/// $key');
      sink.writeln('@override');
      sink.writeln('final AdjacencyGraph $key = AdjacencyGraph({');
      for (var key2 in data[key].keys) {
        sink.writeln('${escaped(key2)}: [');
        for (String? value in data[key][key2]) {
          sink.writeln('${escaped(value)},');
        }
        sink.writeln('    ],');
      }
      sink.writeln('  });');
    }
    sink.writeln('}');
    await sink.close();
  }

  await fetchList(
    baseUrl: baseUrl,
    fileName: 'diceware.json',
    targetFile: 'lib/src/diceware.dart',
    variableName: '_diceware',
  );

  await fetchList(
    baseUrl: baseUrl,
    fileName: 'passwords.json',
    targetFile: 'lib/src/passwords.dart',
    variableName: '_passwords',
  );

  // Format all
  var result = await Process.run('dart', ['format', 'lib']);
  stdout.write(result.stdout);
  stderr.write(result.stderr);
}
