part of '../zxcvbn.dart';

class SpatialMatch extends Match {
  final String graph;
  final int turns;
  final int shiftedCount;

  SpatialMatch({
    super.pattern = 'spatial',
    required super.i,
    required super.j,
    required super.token,
    required this.graph,
    required this.turns,
    required this.shiftedCount,
  });
}

class SpatialGuess extends SpatialMatch with EstimatedGuessesMixin {
  final double guesses;
  final double guessesLog10;
  final Map<String, dynamic> extraData;

  SpatialGuess({
    super.pattern,
    required super.i,
    required super.j,
    required super.token,
    required super.graph,
    required super.turns,
    required super.shiftedCount,
    required this.guesses,
    required this.guessesLog10,
    required this.extraData,
  });
}

class SpatialMatcher extends Matcher {
  final RegExp SHIFTED_RX =
      RegExp(r'[~!@#$%^&*()_+QWERTYUIOP{}|ASDFGHJKL:"ZXCVBNM<>?]');

  @override
  List<Match> match(String password) {
    List<Match> matches = [];

    zxcvbn.options.graphs?.entries.forEach((
      graphName,
      graph,
    ) {
      matches.addAll(_helper(
        password,
        graph,
        graphName,
      ));
    });

    return _sorted(matches);
  }

  int _checkIfShifted(String graphName, String password, int index) {
    if (!graphName.contains('keypad') &&
        SHIFTED_RX.hasMatch(password.substring(index, index + 1))) {
      return 1;
    }
    return 0;
  }

  List<Match> _helper(
    String password,
    AdjacencyGraph graph,
    String graphName,
  ) {
    List<Match> matches = [];

    int i = 0;
    int passwordLength = password.length;

    while (i < passwordLength - 1) {
      int j = i + 1;
      int? lastDirection;
      int turns = 0;

      int shiftedCount = _checkIfShifted(graphName, password, i);

      while (true) {
        final String prevChar = password.substring(j - 1, j);
        final List<String?> adjacents = graph.graph[prevChar] ?? [];

        bool found = false;
        int foundDirection = -1;
        int curDirection = -1;

        // consider growing pattern by one character if j hasn't gone over the
        // edge.
        if (j < passwordLength) {
          final String curChar = password.substring(j, j + 1);
          final int adjacentsLength = adjacents.length;

          for (int k = 0; k < adjacentsLength; k++) {
            final String? adjecent = adjacents[k];

            curDirection++;

            if (adjecent != null && adjecent.isNotEmpty) {
              final int adjectentIndex = adjecent.indexOf(curChar);
              if (adjectentIndex != -1) {
                found = true;
                foundDirection = curDirection;

                if (adjectentIndex == 1) {
                  // index 1 in the adjacency means the key is shifted,
                  // 0 unshifted: A vs a, % vs 5, etc.
                  // for example, 'q' is adjacent to the entry '2@'.
                  // @ is shifted w/ index 1, 2 is unshifted.
                  shiftedCount++;
                }

                if (lastDirection != foundDirection) {
                  // adding a turn is correct even in the initial case when
                  // last_direction is null: every spatial pattern starts with a
                  // turn.
                  turns++;
                  lastDirection = foundDirection;
                }

                break;
              }
            }
          }
        }

        // if the current pattern continued, extend j and try to grow again
        if (found) {
          j++;
          // otherwise push the pattern discovered so far, if any...
        } else {
          // don't consider length 1 or 2 chains.
          if (j - i > 2) {
            matches.add(SpatialMatch(
              i: i,
              j: j - 1,
              token: password.substring(i, j),
              graph: graphName,
              turns: turns,
              shiftedCount: shiftedCount,
            ));
          }
          // ...and then start a new search for the rest of the password.
          i = j;
          break;
        }
      }
    }

    return matches;
  }

  @override
  scoring(Match match) {
    if (match is! SpatialMatch) {
      throw ArgumentError('match is not a SpatialMatch');
    }
    final int shiftedCount = match.shiftedCount;
    final String token = match.token;

    double guesses = _estimatePossiblePatterns(match);

    // add extra guesses for shifted keys. (% instead of 5, A instead of a.)
    // math is similar to extra guesses of l33t substitutions in dictionary matches.
    if (shiftedCount > 0) {
      final unShiftedCount = token.length - shiftedCount;
      if (shiftedCount == 0 || unShiftedCount == 0) {
        guesses *= 2;
      } else {
        double shiftedVariations = 0;
        for (int i = 1; i <= min(shiftedCount, unShiftedCount); i++) {
          shiftedVariations += nCk(shiftedCount + unShiftedCount, i);
        }
        guesses *= shiftedVariations;
      }
    }
    return guesses.round();
  }

  double _estimatePossiblePatterns(SpatialMatch match) {
    final String token = match.token;
    final int turns = match.turns;
    final String graphName = match.graph;
    final AdjacencyGraph? graph = zxcvbn.options.graphs?.entries[graphName];

    if (graph == null) {
      throw ArgumentError('graph is null');
    }

    final int startingPosition = graph.graph.length;
    final double averageDegree = _calcAverageDegree(graph);

    double guesses = 0;
    int tokenLength = token.length;
    // # estimate the number of possible patterns w/ tokenLength or less with turns or less.
    for (int i = 2; i <= tokenLength; i++) {
      int possibleTurns = min(turns, i - 1);
      for (int j = 1; j <= possibleTurns; j++) {
        guesses += nCk(i - 1, j - 1) * startingPosition * pow(averageDegree, j);
      }
    }

    return guesses;
  }

  double _calcAverageDegree(AdjacencyGraph graph) {
    double average = 0;
    graph.graph.forEach((key, neighbors) => average += neighbors
        .where((String? entry) => entry != null && entry.isNotEmpty)
        .length);
    average /= graph.graph.length;
    return average;
  }

  @override
  Feedback? feedback(EstimatedGuessesMixin match, bool isSoleMatch) {
    if (match is! SpatialGuess) {
      throw ArgumentError('match is not a SpatialGuess');
    }

    String warning = zxcvbn.options.translations.warnings.keyPattern;
    if (match.turns == 1) {
      warning = zxcvbn.options.translations.warnings.straightRow;
    }

    return Feedback(
      warning: warning,
      suggestions: [
        zxcvbn.options.translations.suggestions.longerKeyboardPattern
      ],
    );
  }
}
