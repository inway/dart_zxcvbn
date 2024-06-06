import 'package:dart_zxcvbn/dart_zxcvbn.dart';
import 'package:flutter/material.dart' hide Feedback;

class ResultTable extends StatelessWidget {
  const ResultTable({super.key, required this.result});

  final Result result;

  @override
  Widget build(BuildContext context) {
    final TextTheme theme = Theme.of(context).textTheme;

    final List<Widget> children = [];

    children.add(
      Table(
        columnWidths: const <int, TableColumnWidth>{
          0: IntrinsicColumnWidth(),
          1: FlexColumnWidth(),
        },
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: <(String, String)>[
          ('password:', result.password),
          ('guessesLog10:', result.guessesLog10.toString()),
          ('score:', result.score.toString()),
          ('function runtime (ms):', result.calcTime.toString()),
        ]
            .map(
              (row) => TableRow(
                children: [
                  TableCell(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      child: Text(row.$1),
                    ),
                  ),
                  TableCell(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      child: Text(row.$2),
                    ),
                  ),
                ],
              ),
            )
            .toList(),
      ),
    );

    children.add(
      Text(
        'guess times:',
        style: theme.titleMedium,
      ),
    );

    children.add(
      Table(
        columnWidths: const <int, TableColumnWidth>{
          0: IntrinsicColumnWidth(),
          1: IntrinsicColumnWidth(),
          2: FlexColumnWidth(),
        },
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: <(String, String, String)>[
          (
            '100 / hour:',
            result.crackTimesDisplay.onlineThrottling100PerHour,
            '(throttled online attack)'
          ),
          (
            '10 / second:',
            result.crackTimesDisplay.onlineNoThrottling10PerSecond,
            '(unthrottled online attack)'
          ),
          (
            '10k / second:',
            result.crackTimesDisplay.offlineSlowHashing1e4PerSecond,
            '(offline attack, slow hash, many cores)'
          ),
          (
            '10B / second:',
            result.crackTimesDisplay.offlineFastHashing1e10PerSecond,
            '(offline attack, fast hash, many cores)'
          ),
        ]
            .map(
              (row) => TableRow(
                children: [
                  TableCell(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      child: Text(row.$1),
                    ),
                  ),
                  TableCell(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      child: Text(row.$2),
                    ),
                  ),
                  TableCell(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      child: Text(row.$3),
                    ),
                  ),
                ],
              ),
            )
            .toList(),
      ),
    );

    if (result.feedback.warning != null) {
      children.addAll([
        Text(
          'warning:',
          style: theme.titleMedium,
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 2,
          ),
          child: Text(result.feedback.warning!),
        ),
      ]);
    }

    if (result.feedback.suggestions.isNotEmpty) {
      children.addAll([
        Text(
          'suggestions:',
          style: theme.titleMedium,
        ),
        for (var suggestion in result.feedback.suggestions)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 2,
            ),
            child: Text('- $suggestion'),
          ),
      ]);
    }

    if (result.sequence.isNotEmpty) {
      children.add(Text('match sequence:', style: theme.titleMedium));

      for (var match in result.sequence) {
        children.add(
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 2,
            ),
            child: Text("'${match.token}'"),
          ),
        );

        children.add(
          Table(
            columnWidths: const <int, TableColumnWidth>{
              0: IntrinsicColumnWidth(),
              1: FlexColumnWidth(),
            },
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: <(String, String)>[
              ('runtimeType:', match.runtimeType.toString()),
              ('pattern:', match.pattern),
              if (match is DictionaryGuess) ...[
                ('dictionaryName:', match.dictionaryName),
                ('rank:', match.rank.toString()),
                ('reversed:', match.reversed.toString()),
                ('guessesLog10:', match.guessesLog10.toString()),
                ('l33t:', match.l33t.toString()),
                ('un-l33ted:', match.matchedWord.toString()),
              ],
              if (match is EstimatedGuess) ...[
                ('guesses:', match.guesses.toString()),
                ('guessesLog10:', match.guessesLog10.toString()),
              ],
              if (match is SpatialGuess) ...[
                ('guesses:', match.guesses.toString()),
                ('guessesLog10:', match.guessesLog10.toString()),
              ],
            ]
                .map(
                  (row) => TableRow(
                    children: [
                      TableCell(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          child: Text(row.$1),
                        ),
                      ),
                      TableCell(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          child: Text(row.$2),
                        ),
                      ),
                    ],
                  ),
                )
                .toList(),
          ),
        );
      }
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );
  }
}
