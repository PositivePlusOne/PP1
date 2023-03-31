import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/user/user_profile.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/providers/user/profile_controller.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_style.dart';
import 'package:app/widgets/atoms/input/positive_text_field_icon.dart';
import 'package:app/widgets/molecules/input/positive_rich_text.dart';
import 'package:app/widgets/molecules/layouts/positive_basic_sliver_list.dart';
import 'package:app/widgets/molecules/navigation/positive_navigation_bar.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import 'package:app/widgets/organisms/account/vms/account_details_view_model.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

import '../../atoms/buttons/positive_button.dart';
import '../../atoms/input/positive_fake_text_field_button.dart';
import '../../molecules/containers/positive_transparent_sheet.dart';
import '../../molecules/navigation/positive_app_bar.dart';

class AccountDetailsPage extends ConsumerWidget {
  const AccountDetailsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));
    final AppRouter router = ref.read(appRouterProvider);

    final AccountDetailsViewModel viewModel = ref.read(accountDetailsViewModelProvider.notifier);
    final ProfileControllerState profileState = ref.watch(profileControllerProvider);

    final UserProfile? userProfile = profileState.userProfile;
    final String name = userProfile?.name ?? '';
    final String emailAddress = userProfile?.email ?? '';
    final String phoneNumber = userProfile?.phoneNumber ?? '';

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
              suffixIcon: PositiveTextFieldIcon.action(colors),
            ),
            const SizedBox(height: kPaddingMedium),
            PositiveFakeTextFieldButton(
              onTap: () {},
              hintText: 'Phone Number',
              labelText: phoneNumber,
              suffixIcon: PositiveTextFieldIcon.action(colors),
            ),
            const SizedBox(height: kPaddingMedium),
            PositiveButton(
              colors: colors,
              onTapped: () {},
              primaryColor: colors.white,
              label: 'Change Password',
              icon: UniconsLine.lock_alt,
              style: PositiveButtonStyle.primary,
            ),
            const SizedBox(height: kPaddingMedium),
            PositiveButton(
              colors: colors,
              onTapped: () {},
              primaryColor: colors.white,
              label: 'Change Apple Sign In',
              icon: UniconsLine.apple,
              style: PositiveButtonStyle.primary,
            ),
            const SizedBox(height: kPaddingMedium),
            PositiveButton(
              colors: colors,
              onTapped: () {},
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
