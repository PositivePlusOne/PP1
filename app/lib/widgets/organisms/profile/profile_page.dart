// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/hooks/lifecycle_hook.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:app/widgets/molecules/navigation/positive_app_bar.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import 'package:app/widgets/organisms/profile/vms/profile_view_model.dart';
import '../../../dtos/system/design_typography_model.dart';

class ProfilePage extends HookConsumerWidget {
  const ProfilePage({
    required this.userId,
    super.key,
  });

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ProfileViewModelProvider provider = profileViewModelProvider(userId);
    final ProfileViewModelState state = ref.watch(provider);
    final ProfileViewModel viewModel = ref.read(provider.notifier);

    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));

    final AppRouter router = ref.read(appRouterProvider);
    final MediaQueryData mediaQueryData = MediaQuery.of(context);

    useLifecycleHook(viewModel);

    return PositiveScaffold(
      appBar: PositiveAppBar(
        backgroundColor: colors.teal, //! Select from the profile ideally
        trailType: PositiveAppBarTrailType.concave,
        decorationColor: colors.colorGray1,
        applyLeadingandTrailingPadding: true,
        safeAreaQueryData: mediaQueryData,
        leading: PositiveButton.appBarIcon(
          colors: colors,
          primaryColor: colors.black,
          icon: UniconsLine.angle_left_b,
          onTapped: () => router.removeLast(),
        ),
      ),
    );
  }
}
