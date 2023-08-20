// Flutter imports:
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/extensions/dart_extensions.dart';
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

String getSafeDisplayNameFromProfile(Profile? profile) {
  return profile?.displayName.asHandle ?? 'Anonymous User';
}

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

Future<void> onProfileAccountActionSelected({bool shouldReplace = false}) async {
  final Logger logger = providerContainer.read(loggerProvider);
  final AppRouter appRouter = providerContainer.read(appRouterProvider);
  final FirebaseAuth firebaseAuth = providerContainer.read(firebaseAuthProvider);
  logger.d('onAccountSelected()');

  if (firebaseAuth.currentUser == null) {
    logger.e('onAccountSelected() - user is null');
    if (shouldReplace) {
      await appRouter.replace(const RegistrationAccountRoute());
      return;
    }

    await appRouter.push(const RegistrationAccountRoute());
  } else {
    logger.d('onAccountSelected() - user is not null');
    if (shouldReplace) {
      await appRouter.replace(const AccountRoute());
      return;
    }

    await appRouter.push(const AccountRoute());
  }
}

Future<void> onProfileNotificationsActionSelected({bool shouldReplace = false}) async {
  final Logger logger = providerContainer.read(loggerProvider);
  final AppRouter appRouter = providerContainer.read(appRouterProvider);

  logger.d('onNotificationsSelected()');
  if (shouldReplace) {
    await appRouter.replace(const NotificationsRoute());
    return;
  }

  await appRouter.push(const NotificationsRoute());
}
