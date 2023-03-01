// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freerasp/talsec_app.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

// Project imports:
import 'package:app/gen/app_router.dart';
import 'package:app/observers/route_analytics_observer.dart';
import 'package:app/providers/analytics/analytics_controller.dart';
import 'package:app/providers/search/search_controller.dart';
import 'package:app/providers/system/security_controller.dart';
import 'package:app/providers/system/system_controller.dart';
import 'package:app/providers/user/messaging_controller.dart';
import 'package:app/providers/user/pledge_controller.dart';
import 'package:app/providers/user/user_controller.dart';
import 'package:app/services/third_party.dart';
import 'package:app/widgets/behaviours/positive_scroll_behaviour.dart';
import 'package:app/widgets/organisms/home/components/chat_stream_wrapper.dart';

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

Future<void> setupApplication() async {
  //* Setup required services without concrete implementations
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  //* Setup providers
  await providerContainer.read(asyncPledgeControllerProvider.future);
  await providerContainer.read(asyncSecurityControllerProvider.future);

  final TalsecApp talsecApp = await providerContainer.read(talsecAppProvider.future);
  talsecApp.start();

  final MessagingController messagingController = providerContainer.read(messagingControllerProvider.notifier);
  final SearchController searchController = providerContainer.read(searchControllerProvider.notifier);
  final AnalyticsController analyticsController = providerContainer.read(analyticsControllerProvider.notifier);
  final UserController userController = providerContainer.read(userControllerProvider.notifier);
  final SystemController systemController = providerContainer.read(systemControllerProvider.notifier);

  await messagingController.setupListeners();
  await searchController.setupListeners();
  await analyticsController.flushEvents();
  await userController.setupListeners();

  await systemController.requestPushNotificationPermissions();
  await systemController.setupPushNotificationListeners();
  await systemController.setupCrashlyticListeners();

  //* Verify shared preferences future has been resolved
  await providerContainer.read(sharedPreferencesProvider.future);
}

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppRouter appRouter = ref.read(appRouterProvider);
    return MaterialApp.router(
      builder: (context, child) => ChatStreamWrapper.wrap(context, child ?? const SizedBox.shrink()),
      routerDelegate: appRouter.delegate(
        navigatorObservers: () => [
          RouteAnalyticsObserver(),
        ],
      ),
      routeInformationParser: appRouter.defaultRouteParser(),
      scrollBehavior: PositiveScrollBehaviour(),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        RefreshLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
