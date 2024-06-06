import 'package:dart_zxcvbn/dart_zxcvbn.dart';
import 'package:flutter/widgets.dart';

import 'handler.dart';
import 'message.dart';

/// Simple wrapper for [StreamBuilder] to simplify usage of
/// [PasswordScoringHelper].
///
/// It will automatically initialize and dispose the choosen
/// [PasswordScoringHandler].
class PasswordScoringBuilder extends StatefulWidget {
  const PasswordScoringBuilder({
    super.key,
    required this.builder,
    required this.handler,
    this.loadingPlaceholder,
  });

  final Widget Function(
    BuildContext,
    Result?,
    PasswordScoringHandler handler,
  ) builder;
  final PasswordScoringHandler handler;
  final Widget? loadingPlaceholder;

  @override
  State<PasswordScoringBuilder> createState() => _PasswordScoringBuilderState();
}

class _PasswordScoringBuilderState extends State<PasswordScoringBuilder> {
  @override
  void initState() {
    super.initState();

    widget.handler.init();
  }

  @override
  void dispose() {
    widget.handler.stop();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);

    if (widget.handler.locale != locale) {
      widget.handler.locale = locale;
    }

    return StreamBuilder(
      stream: widget.handler.stream,
      builder: (
        BuildContext context,
        AsyncSnapshot<PasswordScoringMessage> snapshot,
      ) =>
          snapshot.hasData
              ? widget.builder(
                  context,
                  snapshot.data?.result,
                  widget.handler,
                )
              : (widget.loadingPlaceholder ?? const SizedBox.shrink()),
    );
  }
}
