part of '../zxcvbn.dart';

class RepeatMatch extends Match {
  RepeatMatch({
    super.pattern = 'repeat',
    required super.i,
    required super.j,
    required super.token,
  });
}

class RepeatMatcher extends Matcher {
  @override
  List<Match> match(String password) {
    throw UnimplementedError();
  }
}
