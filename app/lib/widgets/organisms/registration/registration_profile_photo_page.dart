// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:camera/camera.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/hooks/lifecycle_hook.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import '../../../gen/app_router.dart';

class ProfileImagePage extends HookConsumerWidget {
  const ProfileImagePage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final ProfilePhotoViewModel viewModel = ref.read(profilePhotoViewModelProvider.notifier);
    // final ProfilePhotoViewModelState viewModelState = ref.watch(profilePhotoViewModelProvider);
    // useLifecycleHook(viewModel);

    final AppLocalizations appLocalization = AppLocalizations.of(context)!;
    final DesignColorsModel colours = ref.read(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel designTypography = ref.read(designControllerProvider.select((value) => value.typography));

    final AppRouter appRouter = ref.read(appRouterProvider);
    final MediaQueryData mediaQuery = MediaQuery.of(appRouter.navigatorKey.currentState!.context);

    return PositiveScaffold(
      hideBottomPadding: true,
      backgroundColor: colours.black,
      headingWidgets: <Widget>[
        SliverFillRemaining(
          child: Stack(
            children: [],
          ),
        ),
      ],
    );
  }
}
