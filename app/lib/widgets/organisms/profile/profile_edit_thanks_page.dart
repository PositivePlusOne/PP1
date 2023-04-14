import 'package:app/gen/app_router.dart';
import 'package:app/widgets/organisms/shared/positive_generic_page.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

@RoutePage()
class ProfileEditThanksPage extends ConsumerWidget {
  final String body;
  const ProfileEditThanksPage({Key? key, required this.body}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = AppLocalizations.of(context)!;
    return PositiveGenericPage(
      title: locale.page_profile_thanks_title,
      body: body,
      buttonText: locale.shared_actions_continue,
      onContinueSelected: () async => context.router.popUntil((route) => route.settings.name == const ProfileEditSettingsRoute().routeName),
    );
  }
}
