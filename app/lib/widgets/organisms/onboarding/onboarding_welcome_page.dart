import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../dtos/system/design_colors_model.dart';
import '../../../providers/system/design_controller.dart';
import '../../molecules/scaffolds/positive_scaffold.dart';

class OnboardingWelcomePage extends ConsumerWidget {
  const OnboardingWelcomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    return PositiveScaffold(
      backgroundColor: colors.teal,
      children: <Widget>[],
    );
  }
}
