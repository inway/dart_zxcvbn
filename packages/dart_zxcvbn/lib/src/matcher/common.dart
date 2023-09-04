part of '../zxcvbn.dart';

interface class Match {
  /// The name of the matcher
  final String pattern;

  /// The start index of the token found in the password
  final int i;

  /// The end index of the token found in the password
  final int j;

  /// The token found in the password
  final String token;

  Match({
    required this.pattern,
    required this.i,
    required this.j,
    required this.token,
  });

  factory Match.fromJson(Map<String, dynamic> json) => Match(
        pattern: json['pattern'],
        i: json['i'],
        j: json['j'],
        token: json['token'],
      );
}

abstract interface class Matcher {
  List<Match> match(String password);

  /// TODO make this abstract when all matchers are implemented
  dynamic scoring(Match match) {
    throw UnimplementedError('scoring() not implemented on $runtimeType');
  }

  /// TODO make this abstract when all matchers are implemented
  Feedback? feedback(EstimatedGuessesMixin match, bool isSoleMatch) {
    throw UnimplementedError('feedback() not implemented on $runtimeType');
  }
}
