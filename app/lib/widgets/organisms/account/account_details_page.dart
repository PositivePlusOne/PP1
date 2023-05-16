// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/providers/user/user_controller.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_style.dart';
import 'package:app/widgets/atoms/input/positive_text_field_icon.dart';
import 'package:app/widgets/molecules/input/positive_rich_text.dart';
import 'package:app/widgets/molecules/layouts/positive_basic_sliver_list.dart';
import 'package:app/widgets/molecules/navigation/positive_navigation_bar.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import 'package:app/widgets/organisms/account/vms/account_details_view_model.dart';
import '../../atoms/buttons/positive_button.dart';
import '../../atoms/input/positive_fake_text_field_button.dart';
import '../../molecules/containers/positive_transparent_sheet.dart';
import '../../molecules/navigation/positive_app_bar.dart';

@RoutePage()
class AccountDetailsPage extends ConsumerWidget {
  const AccountDetailsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));
    final AppRouter router = ref.read(appRouterProvider);

    final AccountDetailsViewModel viewModel = ref.read(accountDetailsViewModelProvider.notifier);
    final ProfileControllerState profileState = ref.watch(profileControllerProvider);

    final UserController userController = ref.read(userControllerProvider.notifier);
    ref.watch(userControllerProvider);

    final Profile? profile = profileState.userProfile;
    final String name = profile?.name ?? '';
    final String emailAddress = profile?.email ?? '';
    final String phoneNumber = profile?.phoneNumber ?? '';

    final MediaQueryData mediaQueryData = MediaQuery.of(context);

    return PositiveScaffold(
      appBar: PositiveAppBar(
        includeLogoWherePossible: false,
        applyLeadingandTrailingPadding: true,
        decorationColor: colors.colorGray1,
        safeAreaQueryData: mediaQueryData,
        leading: PositiveButton.appBarIcon(
          colors: colors,
          primaryColor: colors.black,
          icon: UniconsLine.angle_left_b,
          onTapped: () => router.removeLast(),
        ),
        trailing: <Widget>[
          PositiveButton.appBarIcon(
            colors: colors,
            icon: UniconsLine.bell,
            onTapped: () async {},
            isDisabled: true,
          ),
          PositiveButton.appBarIcon(
            colors: colors,
            icon: UniconsLine.user,
            isDisabled: true,
            onTapped: () {},
          ),
        ],
      ),
      bottomNavigationBar: PositiveNavigationBar(
        mediaQuery: mediaQueryData,
      ),
      headingWidgets: <Widget>[
        PositiveBasicSliverList(
          includeAppBar: false,
          children: <Widget>[
            Text(
              'Account Details',
              style: typography.styleSuperSize.copyWith(color: colors.black),
            ),
            const SizedBox(height: kPaddingMedium),
            PositiveTransparentSheet(
              children: <Widget>[
                PositiveFakeTextFieldButton(
                  onTap: () {},
                  backgroundColor: Colors.transparent,
                  hintText: 'Name',
                  labelText: name,
                ),
                const SizedBox(height: kPaddingMedium),
                PositiveRichText(
                  actionColor: colors.linkBlue,
                  textColor: colors.colorGray7,
                  onActionTapped: (_) {},
                  body: 'Need to change these details? Please refer to our {}',
                  actions: const <String>[
                    'Guidance to find out more.',
                  ],
                )
              ],
            ),
            const SizedBox(height: kPaddingMedium),
            PositiveFakeTextFieldButton(
              hintText: 'Email Address',
              labelText: emailAddress,
              onTap: viewModel.onUpdateEmailAddressButtonPressed,
              suffixIcon: PositiveTextFieldIcon.action(
                backgroundColor: colors.purple,
              ),
            ),
            const SizedBox(height: kPaddingMedium),
            PositiveFakeTextFieldButton(
              hintText: 'Phone Number',
              labelText: phoneNumber,
              onTap: viewModel.onUpdatePhoneNumberButtonPressed,
              suffixIcon: PositiveTextFieldIcon.action(
                backgroundColor: colors.purple,
              ),
            ),
            const SizedBox(height: kPaddingMedium),
            PositiveButton(
              colors: colors,
              onTapped: viewModel.onUpdatePasswordButtonPressed,
              primaryColor: colors.white,
              label: 'Change Password',
              icon: UniconsLine.lock_alt,
              style: PositiveButtonStyle.primary,
            ),
            const SizedBox(height: kPaddingMedium),
            if (userController.isAppleProviderLinked) ...<Widget>[
              PositiveButton(
                colors: colors,
                onTapped: viewModel.onDisconnectAppleProviderPressed,
                primaryColor: colors.white,
                label: 'Disable Apple Sign In',
                icon: UniconsLine.apple,
                style: PositiveButtonStyle.primary,
              ),
              const SizedBox(height: kPaddingMedium),
            ],
            if (userController.isGoogleProviderLinked) ...<Widget>[
              PositiveButton(
                colors: colors,
                onTapped: viewModel.onDisconnectGoogleProviderPressed,
                primaryColor: colors.white,
                label: 'Disable Google Sign In',
                icon: UniconsLine.google,
                style: PositiveButtonStyle.primary,
              ),
              const SizedBox(height: kPaddingMedium),
            ],
            if (userController.isFacebookProviderLinked) ...<Widget>[
              PositiveButton(
                colors: colors,
                onTapped: viewModel.onDisconnectFacebookProviderPressed,
                primaryColor: colors.white,
                label: 'Disable Facebook Sign In',
                icon: UniconsLine.facebook_f,
                style: PositiveButtonStyle.primary,
              ),
              const SizedBox(height: kPaddingMedium),
            ],
            PositiveButton(
              colors: colors,
              onTapped: viewModel.onDeleteAccountButtonPressed,
              primaryColor: colors.black,
              label: 'Delete Account',
              style: PositiveButtonStyle.text,
            ),
          ],
        ),
      ],
    );
  }
}
