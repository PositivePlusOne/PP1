// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/extensions/dart_extensions.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/system/notifications_controller.dart';
import 'package:app/widgets/atoms/buttons/positive_notifications_button.dart';
import 'package:app/widgets/atoms/indicators/positive_profile_circular_indicator.dart';
import '../gen/app_router.dart';
import '../main.dart';
import '../services/third_party.dart';

String getSafeDisplayNameFromProfile(Profile? profile) {
  return profile?.displayName.asHandle ?? 'Anonymous User';
}

List<Widget> buildCommonProfilePageActions({
  bool disableNotifications = false,
  bool disableAccount = false,
  bool includeSpacer = false,
  Color? color,
  Color? ringColorOverrideProfile,
  Color? badgeColorOverride,
  void Function()? onTapNotifications,
  void Function()? onTapProfile,
}) {
  final List<Widget> children = [];
  final ProfileController profileController = providerContainer.read(profileControllerProvider.notifier);
  final NotificationsController notificationsController = providerContainer.read(notificationsControllerProvider.notifier);
  final bool isUserProfile = profileController.isCurrentlyUserProfile;

  if (profileController.currentProfile == null) {
    return children;
  }

  children.addAll([
    PositiveNotificationsButton(
      color: color,
      isDisabled: disableNotifications,
      includeBadge: isUserProfile && notificationsController.canDisplayNotificationFeedBadge,
      badgeColor: badgeColorOverride,
      onTap: onTapNotifications,
    ),
    if (includeSpacer) const SizedBox(width: kPaddingSmall),
    PositiveProfileCircularIndicator(
      profile: profileController.currentProfile,
      isEnabled: !disableAccount,
      onTap: onTapProfile ?? onProfileAccountActionSelected,
      ringColorOverride: ringColorOverrideProfile,
    ),
  ]);

  return children;
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
