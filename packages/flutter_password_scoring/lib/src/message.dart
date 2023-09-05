import 'package:dart_zxcvbn/dart_zxcvbn.dart';

/// Wrapper for [Result] to be used in [StreamBuilder].
class PasswordScoringMessage {
  final Result? result;

  PasswordScoringMessage({this.result});
}
