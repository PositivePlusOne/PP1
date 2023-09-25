// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/gen/app_router.dart';
import 'package:app/widgets/organisms/shared/positive_generic_page.dart';

enum ProfileEditThanksReturnStyle {
  popToEditSettings,
  popToAccountDetails,
}

@RoutePage()
class ProfileEditThanksPage extends ConsumerWidget {
  const ProfileEditThanksPage({
    Key? key,
    required this.title,
    required this.body,
    required this.continueText,
    this.returnStyle = ProfileEditThanksReturnStyle.popToEditSettings,
  }) : super(key: key);

  final String title;
  final String body;
  final String continueText;
  final ProfileEditThanksReturnStyle returnStyle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PositiveGenericPage(
      title: title,
      body: body,
      buttonText: continueText,
      onContinueSelected: () async {
        switch (returnStyle) {
          case ProfileEditThanksReturnStyle.popToEditSettings:
            context.router.popUntil((route) => route.settings.name == const AccountProfileEditSettingsRoute().routeName);
            break;
          case ProfileEditThanksReturnStyle.popToAccountDetails:
            context.router.popUntil((route) => route.settings.name == const AccountDetailsRoute().routeName);
            break;
        }
      },
    );
  }
}
