// Flutter imports:
import 'package:app/dtos/database/common/media.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/extensions/profile_extensions.dart';
import 'package:app/helpers/brand_helpers.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/widgets/atoms/indicators/positive_profile_circular_indicator.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/notifications/notification_payload.dart';
import 'package:app/extensions/color_extensions.dart';
import 'package:app/extensions/number_extensions.dart';
import 'package:app/main.dart';
import 'package:app/providers/system/handlers/notifications/notification_handler.dart';
import '../../../providers/system/design_controller.dart';

class PositiveSnackBar extends SnackBar {
  PositiveSnackBar({super.key, required Widget content, Color? backgroundColor})
      : super(
          margin: const EdgeInsets.only(left: kPaddingSmall, right: kPaddingSmall, bottom: kPaddingSmall),
          behavior: SnackBarBehavior.floating,
          backgroundColor: backgroundColor ?? providerContainer.read(designControllerProvider.select((value) => value.colors)).black,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(30),
            ),
          ),
          content: content,
        );
}

class PositiveErrorSnackBar extends PositiveSnackBar {
  PositiveErrorSnackBar({super.key, required String text})
      : super(
          backgroundColor: providerContainer.read(designControllerProvider.select((value) => value.colors)).red,
          content: Builder(builder: (context) {
            final colors = providerContainer.read(designControllerProvider.select((value) => value.colors));
            final typography = providerContainer.read(designControllerProvider.select((value) => value.typography));

            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(UniconsLine.times_circle, color: colors.white),
                    kPaddingSmall.asHorizontalBox,
                    Expanded(
                      child: Text(
                        text,
                        textAlign: TextAlign.center,
                        style: typography.styleBody,
                      ),
                    ),
                  ],
                ),
              ],
            );
          }),
        );
}

class PositiveNotificationSnackBar extends PositiveSnackBar {
  PositiveNotificationSnackBar({super.key, required NotificationPayload payload, required NotificationHandler handler})
      : super(
          backgroundColor: handler.getBackgroundColor(payload),
          content: Builder(builder: (context) {
            final typography = providerContainer.read(designControllerProvider.select((value) => value.typography));
            final textColor = handler.getForegroundColor(payload);

            final ProfileController profileController = providerContainer.read(profileControllerProvider.notifier);
            final bool hasMultipleProfiles = profileController.hasMultipleProfiles;

            final CacheController cacheController = providerContainer.read(cacheControllerProvider);
            final Profile? receiverProfile = cacheController.get(payload.userId);
            final Media? receiverProfileImage = receiverProfile?.profileImage;

            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                if (hasMultipleProfiles && receiverProfileImage != null) ...<Widget>[
                  PositiveProfileCircularIndicator(profile: receiverProfile, ringColorOverride: textColor),
                ] else ...<Widget>[
                  Icon(UniconsLine.bell, color: textColor),
                ],
                kPaddingSmall.asHorizontalBox,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        payload.title,
                        style: typography.styleBold.copyWith(color: textColor),
                      ),
                      buildMarkdownWidgetFromBody(
                        payload.body,
                        brightness: textColor.computedSystemBrightness,
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
        );
}

class PositiveFollowSnackBar extends PositiveSnackBar {
  PositiveFollowSnackBar({super.key, required String text})
      : super(
          content: Builder(builder: (context) {
            final colors = providerContainer.read(designControllerProvider.select((value) => value.colors));
            final typography = providerContainer.read(designControllerProvider.select((value) => value.typography));

            return Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(UniconsLine.check_circle, color: colors.white),
                    kPaddingSmall.asHorizontalBox,
                    Expanded(
                      child: Text(
                        text,
                        textAlign: TextAlign.center,
                        style: typography.styleBody,
                      ),
                    ),
                  ],
                ),
              ],
            );
          }),
        );
}

class PositiveGenericSnackBar extends PositiveSnackBar {
  PositiveGenericSnackBar({super.key, required String title, String? body, required IconData icon, required Color backgroundColour})
      : super(
          backgroundColor: backgroundColour,
          content: Builder(builder: (context) {
            final typography = providerContainer.read(designControllerProvider.select((value) => value.typography));
            final complimentTextColor = backgroundColour.complimentTextColor;

            return Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(icon, color: complimentTextColor),
                    kPaddingSmall.asHorizontalBox,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: typography.styleBold.copyWith(color: complimentTextColor),
                          ),
                          if (body != null)
                            Text(
                              body,
                              style: typography.styleBody.copyWith(color: complimentTextColor),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            );
          }),
        );
}
