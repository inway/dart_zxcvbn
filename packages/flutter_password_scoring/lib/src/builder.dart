import 'package:dart_zxcvbn/dart_zxcvbn.dart';
import 'package:flutter/widgets.dart';

import 'helper.dart';
import 'message.dart';

/// Simple wrapper for [StreamBuilder] to simplify the usage of
/// [PasswordScoringHelper].
///
/// It takes cate of initiaizing the [PasswordScoringHelper] and disposing it
/// when the widget is disposed. It also watches for changes in the [Locale] and
/// sends it to the [PasswordScoringHandler].
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
    PasswordScoringHelper helper,
  ) builder;
  final PasswordScoringHandler handler;
  final Widget? loadingPlaceholder;

  @override
  State<PasswordScoringBuilder> createState() => _PasswordScoringBuilderState();
}

class _PasswordScoringBuilderState extends State<PasswordScoringBuilder> {
  final PasswordScoringHelper _passwordScoringHelper = PasswordScoringHelper();

  @override
  void initState() {
    super.initState();

    _passwordScoringHelper.init(widget.handler);
  }

  @override
  void dispose() {
    _passwordScoringHelper.stop();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);

    if (_passwordScoringHelper.locale != locale) {
      _passwordScoringHelper.locale = locale;
    }

    return StreamBuilder(
      stream: _passwordScoringHelper.stream,
      builder: (
        BuildContext context,
        AsyncSnapshot<PasswordScoringMessage> snapshot,
      ) =>
          snapshot.hasData
              ? widget.builder(
                  context,
                  snapshot.data?.result,
                  _passwordScoringHelper,
                )
              : widget.loadingPlaceholder ?? const SizedBox.shrink(),
    );
  }
}
