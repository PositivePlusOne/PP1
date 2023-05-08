// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';

// Project imports:
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/extensions/color_extensions.dart';
import '../gen/app_router.dart';
import '../main.dart';
import '../providers/system/design_controller.dart';
import '../services/third_party.dart';

Color getSafeProfileColorFromHex(String? color) {
  final DesignColorsModel colors = providerContainer.read(designControllerProvider.select((value) => value.colors));

  if (color == null) {
    return colors.teal;
  }

  try {
    return color.toColorFromHex();
  } catch (e) {
    return colors.teal;
  }
}

Future<void> onProfileAccountActionSelected() async {
  final Logger logger = providerContainer.read(loggerProvider);
  final AppRouter appRouter = providerContainer.read(appRouterProvider);
  final FirebaseAuth firebaseAuth = providerContainer.read(firebaseAuthProvider);
  logger.d('onAccountSelected()');

  if (firebaseAuth.currentUser == null) {
    logger.e('onAccountSelected() - user is null');
    await appRouter.push(const RegistrationAccountRoute());
  } else {
    logger.d('onAccountSelected() - user is not null');
    await appRouter.push(const AccountRoute());
  }
}

Future<void> onProfileNotificationsActionSelected() async {
  final Logger logger = providerContainer.read(loggerProvider);
  final AppRouter appRouter = providerContainer.read(appRouterProvider);

  logger.d('onNotificationsSelected()');
  await appRouter.push(const NotificationsRoute());
}
