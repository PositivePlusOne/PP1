// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/providers/system/system_controller.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:app/widgets/atoms/buttons/positive_checkbox.dart';
import 'package:app/widgets/atoms/input/positive_text_field_icon.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import 'package:app/widgets/organisms/development/vms/development_view_model.dart';
import '../../molecules/navigation/positive_app_bar.dart';

class DevelopmentPage extends ConsumerWidget {
  const DevelopmentPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.read(designControllerProvider.select((value) => value.typography));

    final DevelopmentViewModel developmentViewModel = ref.watch(developmentViewModelProvider.notifier);
    final DevelopmentViewModelState developmentViewModelState = ref.watch(developmentViewModelProvider);

    final SystemControllerState systemControllerState = ref.watch(systemControllerProvider);

    final AppRouter appRouter = ref.read(appRouterProvider);

    final MediaQueryData mediaQueryData = MediaQuery.of(context);

    return PositiveScaffold(
      appBar: PositiveAppBar(
        applyLeadingandTrailingPadding: true,
        safeAreaQueryData: mediaQueryData,
        backgroundColor: colors.teal,
        foregroundColor: colors.black,
        trailing: <Widget>[
          PositiveButton.appBarIcon(
            colors: colors,
            icon: UniconsLine.multiply,
            onTapped: () => appRouter.removeLast(),
          ),
        ],
      ),
      headingWidgets: <Widget>[
        SliverList(
          delegate: SliverChildListDelegate(
            <Widget>[
              ListTile(
                onTap: developmentViewModel.restartApp,
                dense: true,
                title: Text(
                  'Restart app',
                  style: typography.styleButtonRegular.copyWith(color: colors.black),
                ),
                subtitle: Text(
                  'Mimics restarting the app by going back to the splash page',
                  style: typography.styleSubtext.copyWith(color: colors.black),
                ),
              ),
              ListTile(
                onTap: developmentViewModel.resetSharedPreferences,
                dense: true,
                title: Text(
                  'Reset shared preferences',
                  style: typography.styleButtonRegular.copyWith(color: colors.black),
                ),
                subtitle: Text(
                  'Reset all shared preferences',
                  style: typography.styleSubtext.copyWith(color: colors.black),
                ),
              ),
              ListTile(
                onTap: developmentViewModel.resetAccount,
                dense: true,
                title: Text(
                  'Reset account',
                  style: typography.styleButtonRegular.copyWith(color: colors.black),
                ),
                subtitle: Text(
                  'Deletes your account from the system. Note that the profile will still exist.',
                  style: typography.styleSubtext.copyWith(color: colors.black),
                ),
              ),
              ListTile(
                onTap: developmentViewModel.deleteProfile,
                dense: true,
                title: Text(
                  'Delete profile',
                  style: typography.styleButtonRegular.copyWith(color: colors.black),
                ),
                subtitle: Text(
                  'Deletes the users profile (not the account) from the database.',
                  style: typography.styleSubtext.copyWith(color: colors.black),
                ),
              ),
              ListTile(
                onTap: developmentViewModel.toggleSemanticsDebugger,
                dense: true,
                title: Text(
                  'Toggle semantics layout',
                  style: typography.styleButtonRegular.copyWith(color: colors.black),
                ),
                subtitle: Text(
                  'Displays the app as is for a user with visual impairments',
                  style: typography.styleSubtext.copyWith(color: colors.black),
                ),
              ),
              ListTile(
                onTap: developmentViewModel.toggleDebugMessages,
                dense: true,
                title: Text(
                  'Toggle debug messages',
                  style: typography.styleButtonRegular.copyWith(color: colors.black),
                ),
                subtitle: Text(
                  'Display error messages raw in app without translation',
                  style: typography.styleSubtext.copyWith(color: colors.black),
                ),
                trailing: systemControllerState.showingDebugMessages ? PositiveTextFieldIcon.success(colors) : PositiveTextFieldIcon.error(colors),
              ),
              ListTile(
                onTap: developmentViewModel.resetCache,
                dense: true,
                title: Text(
                  'Clear cache',
                  style: typography.styleButtonRegular.copyWith(color: colors.black),
                ),
                subtitle: Text(
                  'Clears the cache data of the app',
                  style: typography.styleSubtext.copyWith(color: colors.black),
                ),
              ),
              const SizedBox(height: kPaddingMedium),
              Text(
                developmentViewModelState.status,
                textAlign: TextAlign.center,
                style: typography.styleSubtext.copyWith(color: colors.red),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
