part of '../zxcvbn.dart';

class SeparatorMatch extends Match {
  SeparatorMatch({
    super.pattern = 'separator',
    required super.i,
    required super.j,
    required super.token,
  });
}

class SeparatorMatcher extends Matcher {
  @override
  List<Match> match(String password) {
    throw UnimplementedError();
  }
}
