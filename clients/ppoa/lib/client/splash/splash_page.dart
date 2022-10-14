// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:ppoa/business/services/service_mixin.dart';
import 'package:ppoa/business/state/design_system/mutators/update_primary_colour_mutator.dart';
import '../../business/helpers/converters.dart';
import 'splash_keys.dart';

class SplashPage extends HookConsumerWidget with ServiceMixin {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String primaryColorHex = ref.watch(stateProvider.select((value) => value.designSystem.brand.primaryColor));
    final Color primaryColor = toColourFromHex(primaryColorHex);

    return Scaffold(
      key: kPageSplashScaffoldKey,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text('Splash page'),
      ),
      body: Center(
        child: MaterialButton(
          child: Text('Update colour'),
          onPressed: () => mutator.performAction<UpdatePrimaryColourMutator>(["#0000ff"]),
        ),
      ),
    );
  }
}
