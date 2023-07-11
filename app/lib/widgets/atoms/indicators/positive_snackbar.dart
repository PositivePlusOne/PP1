// Flutter imports:
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
          margin: const EdgeInsets.symmetric(horizontal: kPaddingSmall),
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
            final color = handler.getBackgroundColor(payload);
            final complimentTextColor = color.complimentTextColor;

            return Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(UniconsLine.bell, color: complimentTextColor),
                    kPaddingSmall.asHorizontalBox,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            payload.title,
                            style: typography.styleBold.copyWith(color: complimentTextColor),
                          ),
                          Text(
                            payload.body,
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
