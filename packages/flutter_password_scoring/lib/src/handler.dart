import 'dart:async';
import 'dart:ui';

import 'package:dart_zxcvbn/dart_zxcvbn.dart';

import 'message.dart';

/// This is the request object for password scoring.
///
/// It contains the password to score and optional user inputs and options.
class ScoringRequest {
  ScoringRequest({
    required this.password,
    this.userInputs,
    this.options,
  });

  final String password;
  final List<String>? userInputs;
  final Options? options;
}

/// This is default handler for password scoring. It calls [zxcvbn] method
/// directly in foreground. When possible, use [PasswordScoringIsolateHandler]
/// which uses [Isolate] to offload the work to a separate thread.
class PasswordScoringHandler {
  /// This is the stream controller for the [PasswordScoringMessage].
  ///
  /// It is used to send the password scoring results to the
  /// [PasswordScoringBuilder].
  final StreamController<PasswordScoringMessage> _controller =
      StreamController<PasswordScoringMessage>();

  PasswordScoringHandler({
    this.onInit,
    Locale? locale,
  }) : _locale = locale;

  /// This is the callback that is called when the locale changes.
  final Function(Locale?)? onInit;

  /// The stream controller for the [PasswordScoringMessage].
  ///
  /// This is here to allow any child class to access it.
  StreamController<PasswordScoringMessage> get controller => _controller;

  /// The stream for the [PasswordScoringMessage].
  ///
  /// Accessing this stream will allow you to listen to the
  /// [PasswordScoringMessage] messages, which contain [Result] of last
  /// scoring run.
  Stream<PasswordScoringMessage> get stream => _controller.stream;

  /// This is the current locale of this handler.
  Locale? get locale => _locale;
  Locale? _locale;

  /// This is the setter for the locale.
  ///
  /// It will call [onInit] callback if it is not null and then update the
  /// scoring.
  set locale(Locale? value) {
    // Only react to changes in locale value
    if (_locale != value) {
      _locale = value;

      if (onInit != null) onInit!(_locale);

      _updateScoring();
    }
  }

  /// This variable is used to store the last scoring request.
  ///
  /// It is used when some side settings change, such as [Locale] to re-run
  /// password scoring with new settings.
  late ScoringRequest _lastRequest;

  /// This method is used to initialize handler.
  ///
  /// By default it will call [onInit] callback if it is not null, and send
  /// empty [PasswordScoringMessage] to the stream.
  void init() {
    if (onInit != null) onInit!(_locale);

    controller.sink.add(PasswordScoringMessage());
  }

  /// This method is used to stop the handler.
  ///
  /// In default implementation it will close the stream controller, nothing
  /// more.
  void stop() async {
    _controller.close();
  }

  /// Called every time the password changes.
  ///
  /// It stores last password and then calls real update method.
  void update(
    String password, {
    List<String>? userInputs,
    Options? options,
  }) {
    _lastRequest = ScoringRequest(
      password: password,
      userInputs: userInputs,
      options: options,
    );

    _updateScoring();
  }

  Result _updateScoring() {
    final Result result = zxcvbn(
      _lastRequest.password,
      userInputs: _lastRequest.userInputs,
      options: _lastRequest.options,
    );

    controller.sink.add(PasswordScoringMessage(result: result));

    return result;
  }
}
