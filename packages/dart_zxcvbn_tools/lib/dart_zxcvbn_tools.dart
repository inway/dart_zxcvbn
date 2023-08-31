import 'dart:convert';
import 'dart:io';

final String cacheDir = 'tools';

String replaceSpecials(String value) =>
    value.replaceAll('\\', '\\\\').replaceAll("'", "\\'");

String escaped(String? value) => value == null
    ? 'null'
    : value.contains(r'$')
        ? "r'${replaceSpecials(value)}'"
        : "'${replaceSpecials(value)}'";

Future<dynamic> fetchWithCache(Uri baseUrl, String fileName) async {
  final file = File('$cacheDir/$fileName');

  if (!await file.exists()) {
    final fileUrl = baseUrl.resolve(fileName);
    print('Downloading $fileUrl to ${file.path}');
    final request = await HttpClient().getUrl(fileUrl);
    final response = await request.close();
    if (response.statusCode != 200) {
      throw Exception('Failed to download $fileUrl');
    }
    await response.pipe(file.openWrite());
  } else {
    print('Using cached data from ${file.path}');
  }

  final stringData = await file.readAsString();
  final json = jsonDecode(stringData);

  if (json == null) {
    throw Exception('Failed to parse $fileName');
  }

  return json;
}

Future<void> fetchList({
  required Uri baseUrl,
  required String fileName,
  required String targetFile,
  required String variableName,
}) async {
  final data = await fetchWithCache(baseUrl, fileName);
  final sink = File(targetFile).openWrite();

  sink.writeln("part of 'base.dart';");
  sink.writeln();
  sink.writeln('List<String> $variableName = [');
  for (var v in data) {
    sink.writeln('${escaped(v)},');
  }
  sink.writeln('];');
  await sink.close();
}
