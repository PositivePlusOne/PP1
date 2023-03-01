// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

// Project imports:
import 'package:app/widgets/behaviours/positive_scroll_behaviour.dart';
import 'package:app/widgets/organisms/home/components/chat_stream_wrapper.dart';

class MaterialTestWrapper extends StatelessWidget {
  const MaterialTestWrapper({
    required this.child,
    required this.container,
    super.key,
  });

  final Widget child;
  final ProviderContainer container;

  @override
  Widget build(BuildContext context) {
    return UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        builder: (context, child) => ChatStreamWrapper.wrap(context, child ?? const SizedBox.shrink()),
        routes: {
          '/': (context) => child,
        },
        scrollBehavior: PositiveScrollBehaviour(),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          RefreshLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
      ),
    );
  }
}
