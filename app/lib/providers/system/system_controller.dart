// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:device_info_plus/device_info_plus.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tuple/tuple.dart';

// Project imports:
import 'package:app/gen/app_router.dart';
import '../../services/third_party.dart';

part 'system_controller.freezed.dart';
part 'system_controller.g.dart';

enum SystemEnvironment { develop, staging, production }

@freezed
class SystemControllerState with _$SystemControllerState {
  const factory SystemControllerState({
    required SystemEnvironment environment,
    required bool showingSemanticsDebugger,
    required bool showingDebugMessages,
  }) = _SystemControllerState;

  factory SystemControllerState.create({
    required SystemEnvironment environment,
  }) =>
      SystemControllerState(
        environment: environment,
        showingSemanticsDebugger: false,
        showingDebugMessages: environment == SystemEnvironment.develop,
      );
}

typedef FirebaseEndpoint = Tuple2<String, int>;

@Riverpod(keepAlive: true)
class SystemController extends _$SystemController {
  static const String kEnvironmentSystemKey = 'ENVIRONMENT';

  static const String kFirebaseAuthEndpointSystemKey = 'FB_AUTH_ENDPOINT';
  static const String kFirebaseFirestoreEndpointSystemKey = 'FB_FIRESTORE_ENDPOINT';
  static const String kFirebaseStorageEndpointSystemKey = 'FB_STORAGE_ENDPOINT';
  static const String kFirebaseFunctionsEndpointSystemKey = 'FB_FUNCTIONS_ENDPOINT';

  SystemEnvironment get environment {
    const String environmentValue = String.fromEnvironment(kEnvironmentSystemKey, defaultValue: 'develop');
    switch (environmentValue) {
      case 'production':
        return SystemEnvironment.production;
      case 'staging':
        return SystemEnvironment.staging;
      default:
        return SystemEnvironment.develop;
    }
  }

  FirebaseEndpoint? get firebaseAuthEndpoint {
    const String endpointValue = String.fromEnvironment(kFirebaseAuthEndpointSystemKey, defaultValue: '');
    final List<String> endpointParts = endpointValue.split(':');
    if (endpointParts.length != 2) {
      return null;
    }

    return FirebaseEndpoint(endpointParts[0], int.tryParse(endpointParts[1]) ?? 0);
  }

  FirebaseEndpoint? get firebaseFunctionsEndpoint {
    const String endpointValue = String.fromEnvironment(kFirebaseFunctionsEndpointSystemKey, defaultValue: '');
    final List<String> endpointParts = endpointValue.split(':');
    if (endpointParts.length != 2) {
      return null;
    }

    return FirebaseEndpoint(endpointParts[0], int.tryParse(endpointParts[1]) ?? 0);
  }

  FirebaseEndpoint? get firebaseFirestoreEndpoint {
    const String endpointValue = String.fromEnvironment(kFirebaseFirestoreEndpointSystemKey, defaultValue: '');
    final List<String> endpointParts = endpointValue.split(':');
    if (endpointParts.length != 2) {
      return null;
    }

    return FirebaseEndpoint(endpointParts[0], int.tryParse(endpointParts[1]) ?? 0);
  }

  FirebaseEndpoint? get firebaseStorageEndpoint {
    const String endpointValue = String.fromEnvironment(kFirebaseStorageEndpointSystemKey, defaultValue: '');
    final List<String> endpointParts = endpointValue.split(':');
    if (endpointParts.length != 2) {
      return null;
    }

    return FirebaseEndpoint(endpointParts[0], int.tryParse(endpointParts[1]) ?? 0);
  }

  @override
  SystemControllerState build() {
    return SystemControllerState.create(environment: environment);
  }

  //* Travels to a page given on development which allows the users to test the app
  Future<void> launchDevelopmentTooling() async {
    final Logger logger = ref.read(loggerProvider);
    logger.d('launchDevelopmentTooling');

    if (state.environment != SystemEnvironment.develop) {
      logger.d('launchDevelopmentTooling: Not in development environment');
      return;
    }

    final AppRouter appRouter = ref.read(appRouterProvider);
    await appRouter.push(const DevelopmentRoute());
  }

  Future<bool> isDeviceAppleSimulator() async {
    final Logger logger = ref.read(loggerProvider);
    final BaseDeviceInfo deviceInfo = await ref.read(deviceInfoProvider.future);

    logger.d('isDeviceAppleSimulator: $deviceInfo');
    return deviceInfo is IosDeviceInfo && deviceInfo.isPhysicalDevice == false;
  }

  Future<void> handleFatalException(String errorMessage) async {
    final Logger logger = ref.read(loggerProvider);
    final AppRouter appRouter = ref.read(appRouterProvider);

    logger.e('handleFatalException: $errorMessage');
    appRouter.removeWhere((route) => true);
    await appRouter.push(ErrorRoute(errorMessage: errorMessage));
  }

  void toggleSemanticsDebugger() {
    final Logger logger = ref.read(loggerProvider);
    logger.d('toggleSemanticsDebugger: ${!state.showingSemanticsDebugger}');

    state = state.copyWith(showingSemanticsDebugger: !state.showingSemanticsDebugger);
  }

  void toggleDebugMessages() {
    final Logger logger = ref.read(loggerProvider);
    logger.d('toggleDebugMessages: ${!state.showingDebugMessages}');

    state = state.copyWith(showingDebugMessages: !state.showingDebugMessages);
  }
}
