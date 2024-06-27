import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

import 'package:dart_zxcvbn/dart_zxcvbn.dart';
import 'package:dart_zxcvbn_language_common/dart_zxcvbn_language_common.dart';
import 'package:flutter/widgets.dart';

import 'handler.dart';
import 'message.dart';

/// A function that initializes Isolate and returns a [SendPort] as first
/// message. Afterwards it will receive [Locale] or [String] messages and
/// process them to return a [Result] message.
typedef PasswordScoringIsolateHandlerHandler = Future<void> Function(SendPort);

/// This is the default handler function used by [PasswordScoringIsolateHandler].
///
/// It will initialize the [zxcvbn] with the default options and then wait for
/// [Locale] or [String] messages. When it receives a [Locale] message it will
/// update the [Options] of [zxcvbn] and when it receives a [ScoringRequest]
/// message it will calculate the score and send the [Result] message back.
@pragma('vm:entry-point')
Future<void> defaultIsolateHandler(SendPort sendPort) async {
  ReceivePort receivePort = ReceivePort();

  // Always send the [SendPort] as first message
  sendPort.send(receivePort.sendPort);

  // Default handler only supports Common language package
  final langCommon = LanguageCommon();

  zxcvbn.setOptions(Options(
    dictionary: Dictionary.merge([
      langCommon.dictionary,
    ]),
    graphs: langCommon.adjacencyGraphs,
    translations: langCommon.translations,
  ));

  // Used to refresh response when locale changes
  ScoringRequest? lastRequest;

  await for (var message in receivePort) {
    if (message is Locale) {
      // Default handler doesn't support switching locales
    } else if (message is ScoringRequest) {
      lastRequest = message;
    }

    if (lastRequest != null) {
      final Result result = zxcvbn(
        lastRequest.password,
        options: lastRequest.options,
        userInputs: lastRequest.userInputs,
      );
      sendPort.send(result);
    }
  }
}

/// Handler implementation that uses [Isolate] to offload the password scoring
/// to a separate thread.
///
/// This is useful when you want to offload the password scoring to a separate
/// thread to avoid blocking the UI thread.
///
/// Keep in mind that [Isolate] are not supported on all platforms, such as web.
final class PasswordScoringIsolateHandler extends PasswordScoringHandler {
  late final PasswordScoringIsolateHandlerHandler handler;
  final ReceivePort _responseStream = ReceivePort();

  PasswordScoringIsolateHandler({
    super.onInit,
    Locale? locale,
    this.handler = defaultIsolateHandler,
  }) : this._locale = locale;

  @override
  Locale? get locale => _locale;
  Locale? _locale;
  @override
  set locale(Locale? value) {
    if (_locale != value) {
      _locale = value;
      _requestStream?.send(_locale);

      if (onInit != null) onInit!(_locale);
    }
  }

  Isolate? _instance;
  SendPort? _requestStream;
  StreamSubscription? _subscription;

  /// Initializes the [Isolate] and sets up the communication streams.
  ///
  /// It will send the [Locale] to the [Isolate] if it is not null.
  @override
  Future<void> init() async {
    super.init();

    _instance = await Isolate.spawn<SendPort>(
      handler,
      _responseStream.sendPort,
    );

    _subscription = _responseStream.listen((message) {
      if (message is SendPort) {
        _requestStream = message;

        if (locale != null) {
          _requestStream?.send(locale);
        }

        controller.sink.add(PasswordScoringMessage());
      } else if (message is Result) {
        controller.sink.add(PasswordScoringMessage(result: message));
      }
    });
  }

  /// Stops the [Isolate] and calls stop on parent.
  @override
  Future<void> stop() async {
    _subscription?.cancel();
    _responseStream.close();

    _instance?.kill();

    super.stop();
  }

  /// Sends the [ScoringRequest] to the [Isolate] to calculate the score.
  @override
  void update(
    String password, {
    List<String>? userInputs,
    Options? options,
  }) {
    final scoringRequest = ScoringRequest(
      password: password,
      userInputs: userInputs,
      options: options,
    );
    _requestStream?.send(scoringRequest);
  }
}
