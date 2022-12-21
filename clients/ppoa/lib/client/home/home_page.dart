// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:ppoa/business/services/service_mixin.dart';
import 'package:ppoa/business/state/design_system/models/design_system_brand.dart';
import 'package:ppoa/client/components/atoms/buttons/enumerations/ppo_button_layout.dart';
import 'package:ppoa/client/components/atoms/buttons/enumerations/ppo_button_style.dart';
import 'package:ppoa/client/components/atoms/buttons/ppo_button.dart';
import 'package:ppoa/client/constants/ppo_design_constants.dart';
import 'package:ppoa/client/routing/app_router.gr.dart';
import 'home_keys.dart';

class HomePage extends HookConsumerWidget with ServiceMixin {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignSystemBrand branding = ref.watch(stateProvider.select((value) => value.designSystem.brand));

    return Scaffold(
      key: kPageHomeScaffoldKey,
      appBar: AppBar(
        backgroundColor: branding.colors.black,
        leading: const SizedBox.shrink(),
        title: const Text('Home'),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(kPaddingMedium),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            PPOButton(
              brand: branding,
              label: 'Reset onboarding flow',
              onTapped: onResetSelected,
              activeColor: branding.colors.black,
              layout: PPOButtonLayout.textOnly,
              style: PPOButtonStyle.primary,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> onResetSelected() async {
    await preferences.clear();
    await googleSignIn.signOut();
    await firebaseAuth.signOut();
    await router.replaceAll([SplashRoute()]);
  }
}
