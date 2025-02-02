// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/extensions/widget_extensions.dart';
import 'package:app/providers/user/user_controller.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_style.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import 'package:app/widgets/organisms/account/vms/account_details_view_model.dart';
import '../../../providers/system/design_controller.dart';
import '../../atoms/buttons/positive_back_button.dart';
import '../../molecules/layouts/positive_basic_sliver_list.dart';

@RoutePage()
class AccountConnectSocialPage extends ConsumerWidget {
  const AccountConnectSocialPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.read(designControllerProvider.select((value) => value.typography));
    final UserController userController = ref.read(userControllerProvider.notifier);
    final AppLocalizations localisations = AppLocalizations.of(context)!;

    final AccountDetailsViewModel controller = ref.read(accountDetailsViewModelProvider.notifier);
    final AccountDetailsViewModelState state = ref.watch(accountDetailsViewModelProvider);

    return PositiveScaffold(
      isBusy: state.isBusy,
      headingWidgets: <Widget>[
        PositiveBasicSliverList(
          includeAppBar: true,
          children: <Widget>[
            PositiveBackButton(isDisabled: state.isBusy),
            const SizedBox(height: kPaddingMedium),
            Text(
              localisations.page_account_actions_change_social_connect_title,
              style: typography.styleHeroMedium.copyWith(color: colors.black),
            ),
          ],
        ),
      ],
      footerWidgets: <Widget>[
        if (!userController.isGoogleProviderLinked) ...<Widget>[
          PositiveButton(
            colors: colors,
            onTapped: () => controller.onConnectGoogleUserRequested(context),
            isDisabled: state.isBusy,
            primaryColor: colors.white,
            label: localisations.page_account_actions_change_social_connect_continue_google,
            icon: UniconsLine.google,
            style: PositiveButtonStyle.primary,
          ),
        ],
        if (!userController.isAppleProviderLinked) ...<Widget>[
          PositiveButton(
            colors: colors,
            onTapped: () => controller.onConnectAppleUserRequested(context),
            isDisabled: state.isBusy,
            primaryColor: colors.white,
            label: localisations.page_account_actions_change_social_connect_continue_apple,
            icon: UniconsLine.apple,
            style: PositiveButtonStyle.primary,
          ),
        ],
        //! TODO: Implement Facebook login
        // if (!userController.isFacebookProviderLinked) ...<Widget>[
        //   PositiveButton(
        //     colors: colors,
        //     onTapped: ()=>controller.onConnectFacebookUserRequested( context),
        //     isDisabled: state.isBusy,
        //     primaryColor: colors.white,
        //     label: localisations.page_account_actions_change_social_connect_continue_facebook,
        //     icon: UniconsLine.facebook_f,
        //     style: PositiveButtonStyle.primary,
        //   ),
        // ],
      ].spaceWithVertical(kPaddingMedium),
    );
  }
}
