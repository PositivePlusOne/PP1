// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/extensions/localization_extensions.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/providers/analytics/analytics_controller.dart';
import 'package:app/providers/system/system_controller.dart';
import 'package:app/widgets/atoms/indicators/positive_snackbar.dart';
import '../../services/third_party.dart';

part 'exception_controller.freezed.dart';
part 'exception_controller.g.dart';

@freezed
class ExceptionControllerState with _$ExceptionControllerState {
  const factory ExceptionControllerState({
    Object? currentException,
    String? currentExceptionRoute,
  }) = _ExceptionControllerState;

  factory ExceptionControllerState.initialState() => const ExceptionControllerState();
}

@Riverpod(keepAlive: true)
class ExceptionController extends _$ExceptionController {
  @override
  ExceptionControllerState build() {
    return ExceptionControllerState.initialState();
  }

  Future<void> onFlutterErrorOccured(FlutterErrorDetails details) async {
    final Logger logger = ref.read(loggerProvider);
    final FirebaseCrashlytics crashlytics = ref.read(firebaseCrashlyticsProvider);
    final AnalyticsControllerState analyticsControllerState = ref.read(analyticsControllerProvider);

    if (analyticsControllerState.isCollectingData) {
      crashlytics.recordFlutterError(details);
    }

    try {
      logger.e('onFlutterErrorOccured: $details');
      await handleException(details.exception);
    } catch (ex) {
      logger.e('onFlutterErrorOccured: $ex');
    }
  }

  bool onPlatformDispatcherErrorOccured(Object exception, StackTrace stackTrace) {
    final Logger logger = ref.read(loggerProvider);
    final FirebaseCrashlytics crashlytics = ref.read(firebaseCrashlyticsProvider);
    final AnalyticsControllerState analyticsControllerState = ref.read(analyticsControllerProvider);

    if (analyticsControllerState.isCollectingData) {
      crashlytics.recordError(exception, stackTrace, fatal: true);
    }

    unawaited(handleException(exception).onError((error, stackTrace) {
      logger.e('onPlatformDispatcherErrorOccured: $error');
    }));

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
    final StackTrace stackTrace = StackTrace.current;

    logger.d('handleException: $exception');
    logger.d('handleException: $stackTrace');
    state = state.copyWith(currentException: exception, currentExceptionRoute: router.current.name);

    //* We do not want to loop rebuilds, so FlutterErrors we jump out of.
    if (exception is FlutterError) {
      logger.e('handleException: Skipping FlutterError: ${exception.toString()}');
      return;
    }

    if (exception is FirebaseAuthException) {
      await handleFirebaseAuthException(exception);
    }

    if (exception is FirebaseFunctionsException) {
      await handleFirebaseFunctionsException(exception);
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
    if (systemController.state.showingDebugMessages) {
      errorMessage = exception.toString();
    }

    if (errorMessage.isEmpty) {
      logger.d('handleException: Could not get exception message: $exception');
      return;
    }

    final PositiveErrorSnackBar snackbar = PositiveErrorSnackBar(text: errorMessage);
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  Future<void> handleFirebaseAuthException(FirebaseAuthException error) async {
    switch (error.code) {
      default:
        break;
    }
  }

  Future<void> handleFirebaseFunctionsException(FirebaseFunctionsException exception) async {}
}
