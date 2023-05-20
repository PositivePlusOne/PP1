// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
    required this.body,
    this.returnStyle = ProfileEditThanksReturnStyle.popToEditSettings,
  }) : super(key: key);

  final String body;
  final ProfileEditThanksReturnStyle returnStyle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = AppLocalizations.of(context)!;
    return PositiveGenericPage(
      title: locale.page_profile_thanks_title,
      body: body,
      buttonText: locale.shared_actions_continue,
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
