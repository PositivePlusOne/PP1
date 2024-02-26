// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Project imports:
import 'package:app/gen/app_router.dart';
import 'package:app/hooks/lifecycle_hook.dart';
import 'package:app/observers/route_analytics_observer.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/system/system_controller.dart';
import 'package:app/providers/user/relationship_controller.dart';
import 'package:app/providers/user/user_controller.dart';
import 'package:app/services/third_party.dart';
import 'package:app/widgets/behaviours/positive_scroll_behaviour.dart';
import 'package:app/widgets/organisms/home/components/stream_chat_wrapper.dart';
import './extensions/localization_extensions.dart';
import 'constants/application_constants.dart';
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
        useMaterial3: false,
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
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
    final LocalAuthentication localAuthentication = LocalAuthentication();
    final SharedPreferences sharedPreferences = await providerContainer.read(sharedPreferencesProvider.future);
    final AppRouter router = providerContainer.read(appRouterProvider);
    final FirebaseAuth firebaseAuth = providerContainer.read(firebaseAuthProvider);
    final SystemController systemController = providerContainer.read(systemControllerProvider.notifier);

    //? If the user has enabled biometric authentication, they will be prompted in this section otherwise skip
    await sharedPreferences.reload();
    final bool biometricPreferencesAgree = sharedPreferences.getBool(kBiometricsAcceptedKey) == true;
    if (!biometricPreferencesAgree || firebaseAuth.currentUser == null) {
      return;
    }

    //? Check epoch times to make sure the user is not asked for authentication too often based on app constants
    final int? lastCheckedEpoch = sharedPreferences.getInt(kBiometricsAcceptedLastTime);

    //? If we have never set epoch/something else has gone wrong, do not ask the user to authenticate
    if (lastCheckedEpoch == null) {
      return;
    }

    //? Check difference between last checked time and current time, do not auth if the user has authenticated recently
    final int currentEpochTime = DateTime.now().millisecondsSinceEpoch;
    final int timeSinceLastAuthCheck = currentEpochTime - lastCheckedEpoch;
    if (timeSinceLastAuthCheck <= await systemController.getBiometricAuthTimeout()) {
      return;
    }

    //? Authenticate via biometrics if the user is required to
    final bool hasReauthenticated = await localAuthentication.authenticate(localizedReason: "Positive+1 needs to verify it's you");
    await sharedPreferences.setInt(kBiometricsAcceptedLastTime, DateTime.now().millisecondsSinceEpoch);
    if (!hasReauthenticated) {
      final UserController userController = providerContainer.read(userControllerProvider.notifier);
      final ProfileController profileController = providerContainer.read(profileControllerProvider.notifier);
      final RelationshipController relationshipController = providerContainer.read(relationshipControllerProvider.notifier);
      await userController.signOut();
      profileController.resetState();
      relationshipController.resetState();
      await router.replace(LoginRoute(senderRoute: HomeRoute));
    }
  }

  @override
  void onPause() async {
    final SharedPreferences sharedPreferences = await providerContainer.read(sharedPreferencesProvider.future);
    sharedPreferences.setInt(kBiometricsAcceptedLastTime, DateTime.now().millisecondsSinceEpoch);
  }
}
