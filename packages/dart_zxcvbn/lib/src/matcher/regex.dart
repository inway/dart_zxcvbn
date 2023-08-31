part of '../zxcvbn.dart';

class RegexMatch extends Match {
  RegexMatch({
    super.pattern = 'regex',
    required super.i,
    required super.j,
    required super.token,
  });
}

class RegexMatcher extends Matcher {
  @override
  List<Match> match(String password) {
    throw UnimplementedError();
  }
}
