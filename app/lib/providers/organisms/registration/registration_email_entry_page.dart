import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/providers/user/new_account_form_controller.dart';
import 'package:app/widgets/molecules/navigation/positive_app_bar.dart';
import 'package:app/widgets/molecules/prompts/positive_hint.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

import '../../../constants/design_constants.dart';
import '../../system/design_controller.dart';

class RegistrationEmailEntryPage extends ConsumerWidget {
  const RegistrationEmailEntryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));

    final NewAccountFormController newAccountFormController = ref.watch(newAccountFormControllerProvider.notifier);

    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    return PositiveScaffold(
      backgroundColor: colors.white,
      hideTrailingDecoration: true,
      trailingWidgets: <Widget>[
        PositiveHint(
          label: 'Hidden by default in the app',
          icon: UniconsLine.eye_slash,
          iconColor: colors.yellow,
        ),
      ],
      children: <Widget>[
        SliverPadding(
          padding: EdgeInsets.only(
            top: mediaQueryData.padding.top + kPaddingMedium,
            left: kPaddingMedium,
            right: kPaddingMedium,
            bottom: kPaddingMedium,
          ),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              <Widget>[
                const PositiveAppBar(),
                const SizedBox(height: kPaddingSection),
                Text(
                  'Your Email',
                  style: typography.styleHero.copyWith(color: colors.black),
                ),
                const SizedBox(height: kPaddingMedium),
                Text(
                  'Let\'s get started',
                  style: typography.styleBody.copyWith(color: colors.black),
                ),
                const SizedBox(height: kPaddingMedium),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Help me!',
                  ),
                ),
                const SizedBox(height: kPaddingMedium),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'And me!',
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
