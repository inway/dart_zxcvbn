part of '../zxcvbn.dart';

class SpatialMatch extends Match {
  SpatialMatch({
    super.pattern = 'spatial',
    required super.i,
    required super.j,
    required super.token,
  });
}

class SpatialMatcher extends Matcher {
  @override
  List<Match> match(String password) {
    throw UnimplementedError();
  }
}
