// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/hooks/lifecycle_hook.dart';
import 'package:app/observers/route_analytics_observer.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/providers/system/system_controller.dart';
import 'package:app/widgets/behaviours/positive_scroll_behaviour.dart';
import 'package:app/widgets/organisms/home/components/stream_chat_wrapper.dart';
import './extensions/localization_extensions.dart';
import 'init.dart';

final ProviderContainer providerContainer = ProviderContainer();

Future<void> main() async {
  await setupApplication();

  runApp(
    UncontrolledProviderScope(
      container: providerContainer,
      child: const App(),
    ),
  );
}

class App extends HookConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppRouter appRouter = ref.read(appRouterProvider);
    final SystemControllerState systemControllerState = ref.watch(systemControllerProvider);
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));

    useLifecycleHook(AppLifecycleState());

    return MaterialApp.router(
      builder: (context, child) {
        final DefaultTextHeightBehavior textHeightChild = DefaultTextHeightBehavior(
          textHeightBehavior: const TextHeightBehavior(applyHeightToFirstAscent: false, applyHeightToLastDescent: false),
          child: child ?? const SizedBox.shrink(),
        );

        // building the app (locale is set) - let's initialise our locale from this top level by caching the localization
        cacheAppLocalizations(context);

        return StreamChatWrapper.wrap(context, textHeightChild);
      },
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: colors.purple),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(height: 1),
          bodyMedium: TextStyle(height: 1),
          bodySmall: TextStyle(height: 1),
        ),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.iOS: NoShadowCupertinoPageTransitionsBuilder(),
            TargetPlatform.android: NoShadowCupertinoPageTransitionsBuilder(),
          },
        ),
      ),
      routerDelegate: appRouter.delegate(
        navigatorObservers: () => [
          RouteAnalyticsObserver(),
        ],
      ),
      routeInformationParser: appRouter.defaultRouteParser(),
      routeInformationProvider: appRouter.routeInfoProvider(),
      scrollBehavior: PositiveScrollBehaviour(),
      showSemanticsDebugger: systemControllerState.showingSemanticsDebugger,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}

class AppLifecycleState with LifecycleMixin {
  @override
  void onResume() async {
    final SystemController systemController = providerContainer.read(systemControllerProvider.notifier);
    systemController.biometricsReverification();
  }

  @override
  void onPause() async {
    final SystemController systemController = providerContainer.read(systemControllerProvider.notifier);
    systemController.updateBiometricsLastVerifiedTime();
  }
}
