import 'dart:async';
import 'dart:isolate';

import 'package:dart_zxcvbn/dart_zxcvbn.dart';
import 'package:flutter/widgets.dart';

import 'message.dart';

/// A function that initializes Isolate and returns a [SendPort] as first
/// message. Afterwards it will receive [Locale] or [String] messages and
/// process them to return a [Result] message.
typedef PasswordScoringHandler = Future<void> Function(SendPort);

/// Helper class to communicate with the [Isolate] and send/receive messages.
/// It will send [Locale] or [String] messages and receive [Result] messages.
class PasswordScoringHelper {
  static final StreamController<PasswordScoringMessage> _controller =
      StreamController<PasswordScoringMessage>();
  final ReceivePort _responseStream = ReceivePort();

  Locale? _locale;
  Isolate? _instance;
  SendPort? _requestStream;
  StreamSubscription? _subscription;

  PasswordScoringHelper();

  Locale? get locale => _locale;

  set locale(Locale? value) {
    if (_locale != value) {
      _locale = value;
      _requestStream?.send(locale);
    }
  }

  Stream<PasswordScoringMessage> get stream => _controller.stream;

  Future<void> init(PasswordScoringHandler handler) async {
    _instance = await Isolate.spawn<SendPort>(
      handler,
      _responseStream.sendPort,
    );

    _subscription = _responseStream.listen((message) {
      if (message is SendPort) {
        _requestStream = message;

        if (_locale != null) _requestStream?.send(_locale);

        _controller.sink.add(PasswordScoringMessage());
      } else if (message is Result) {
        _controller.sink.add(PasswordScoringMessage(result: message));
      }
    });
  }

  Future<void> stop() async {
    _subscription?.cancel();
    _responseStream.close();
    _controller.close();

    _instance?.kill();
  }

  void update(String password) {
    _requestStream?.send(password);
  }
}
