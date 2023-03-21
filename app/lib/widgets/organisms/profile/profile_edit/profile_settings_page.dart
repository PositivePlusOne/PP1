// Flutter imports:
import 'package:app/widgets/organisms/profile/profile_edit/profile_settings_content.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:unicons/unicons.dart';

import '../../../../constants/design_constants.dart';
import '../../../atoms/buttons/positive_button.dart';
import '../../../atoms/buttons/positive_close_button.dart';
import '../../../molecules/navigation/positive_app_bar.dart';
import '../../../molecules/scaffolds/positive_scaffold.dart';
import '../../account/components/account_profile_banner.dart';

class ProfileSettingsPage extends ConsumerWidget {
  const ProfileSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final MediaQueryData mediaQueryData = MediaQuery.of(context);

    return PositiveScaffold(
      backgroundColor: colors.colorGray1,
      // appBar: PositiveAppBar(
      //   applyLeadingandTrailingPadding: true,
      //   safeAreaQueryData: mediaQueryData,
      //   backgroundColor: colors.teal,
      //   foregroundColor: colors.black,
      //   trailType: PositiveAppBarTrailType.convex,
      // trailing: <Widget>[
      //   PositiveButton.appBarIcon(
      //     colors: colors,
      //     icon: UniconsLine.bell,
      //     onTapped: () async {},
      //     isDisabled: true,
      //   ),
      //   PositiveButton.appBarIcon(
      //     colors: colors,
      //     icon: UniconsLine.user,
      //     onTapped: () async {},
      //     isDisabled: true,
      //   ),
      // ],
      // ),
      headingWidgets: <Widget>[
        SliverPadding(
          padding: EdgeInsets.only(
            top: kPaddingMedium + mediaQueryData.padding.top,
            left: kPaddingMedium,
            right: kPaddingMedium,
            bottom: kPaddingMedium + mediaQueryData.padding.bottom,
          ),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    PositiveButton.appBarIcon(
                      colors: colors,
                      icon: UniconsLine.arrow_left,
                      onTapped: () async {},
                    ),
                    const Spacer(),
                    PositiveButton.appBarIcon(
                      colors: colors,
                      icon: UniconsLine.user,
                      onTapped: () async {},
                    ),
                    const SizedBox(width: kPaddingSmall),
                    PositiveButton.appBarIcon(
                      colors: colors,
                      icon: UniconsLine.bell,
                      onTapped: () async {},
                    ),
                  ],
                ),
                // PositiveCloseButton(),
                // ProfileSettingsContent(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
