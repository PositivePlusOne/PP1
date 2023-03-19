// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/extensions/localization_extensions.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/main.dart';
import 'package:app/providers/system/system_controller.dart';
import '../../services/third_party.dart';
import '../user/user_controller.dart';

part 'exception_controller.freezed.dart';
part 'exception_controller.g.dart';

@freezed
class ExceptionControllerState with _$ExceptionControllerState {
  const factory ExceptionControllerState({
    required bool isCrashlyticsListening,
    Object? currentException,
    String? currentExceptionRoute,
  }) = _ExceptionControllerState;

  factory ExceptionControllerState.initialState() => const ExceptionControllerState(
        isCrashlyticsListening: false,
      );
}

@Riverpod(keepAlive: true)
class ExceptionController extends _$ExceptionController {
  @override
  ExceptionControllerState build() {
    return ExceptionControllerState.initialState();
  }

  Future<void> setupCrashlyticListeners() async {
    final Logger logger = ref.read(loggerProvider);
    final FirebaseCrashlytics crashlytics = ref.read(firebaseCrashlyticsProvider);

    if (state.isCrashlyticsListening) {
      logger.d('setupCrashlyticListeners: Already listening to crashlytics');
      return;
    }

    await crashlytics.setCrashlyticsCollectionEnabled(!kDebugMode);

    FlutterError.onError = onFlutterErrorOccured;
    PlatformDispatcher.instance.onError = onPlatformDispatcherErrorOccured;

    logger.d('setupCrashlyticListeners: Listening to crashlytics');
    state = state.copyWith(isCrashlyticsListening: true);
  }

  Future<void> onFlutterErrorOccured(FlutterErrorDetails details) async {
    final FirebaseCrashlytics crashlytics = ref.read(firebaseCrashlyticsProvider);
    crashlytics.recordFlutterError(details);
    await handleException(details.exception);
  }

  bool onPlatformDispatcherErrorOccured(Object exception, StackTrace stackTrace) {
    final FirebaseCrashlytics crashlytics = ref.read(firebaseCrashlyticsProvider);
    // TODO(ryan): Write a check to see if the exception is fatal or not.
    crashlytics.recordError(exception, stackTrace, fatal: true);
    unawaited(handleException(exception));

    return true;
  }

  void resetCurrentException() {
    state = state.copyWith(currentException: null, currentExceptionRoute: null);
  }

  bool isExceptionFatal(Object exception) {
    return true;
  }

  Future<void> handleException(Object? exception) async {
    final Logger logger = ref.read(loggerProvider);
    final AppRouter router = ref.read(appRouterProvider);
    final SystemController systemController = ref.read(systemControllerProvider.notifier);
    final BuildContext? context = ref.read(appRouterProvider).navigatorKey.currentContext;
    final AppLocalizations? localizations = context != null ? AppLocalizations.of(context) : null;

    logger.d('handleException: $exception');
    state = state.copyWith(currentException: exception, currentExceptionRoute: router.current.name);

    //* We do not want to loop rebuilds, so FlutterErrors we jump out of.
    if (exception is FlutterError) {
      logger.e('handleException: Skipping FlutterError: ${exception.toString()}');
      return;
    }

    if (exception is FirebaseAuthException) {
      await handleFirebaseAuthException(exception);
    }

    // Display a message if we can localize the exception
    if (context == null || localizations == null) {
      logger.e('handleException: Could not find context or localizations');
      return;
    }

    // ignore: use_build_context_synchronously
    String errorMessage = localizations.fromObject(exception);
    if (errorMessage.isEmpty) {
      logger.e('handleException: Could not localize exception: $exception');
      return;
    }

    //* In a development build, we want to display the actual error message
    if (systemController.environment == SystemEnvironment.develop) {
      errorMessage = exception.toString();
    }

    // TODO(ryan): Rewrite to use a custom snackbar
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> handleFirebaseAuthException(FirebaseAuthException error) async {
    switch (error.code) {
      case 'requires-recent-login':
        await providerContainer.read(userControllerProvider.notifier).timeoutSession();
        break;
      default:
        break;
    }
  }
}
