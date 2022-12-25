// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ppoa/business/extensions/brand_extensions.dart';

// Project imports:
import 'package:ppoa/business/services/service_mixin.dart';
import 'package:ppoa/business/state/design_system/models/design_system_brand.dart';
import 'package:ppoa/client/components/atoms/buttons/enumerations/ppo_button_layout.dart';
import 'package:ppoa/client/components/atoms/buttons/enumerations/ppo_button_style.dart';
import 'package:ppoa/client/components/atoms/buttons/ppo_button.dart';
import 'package:ppoa/client/components/molecules/navigation/ppo_app_bar.dart';
import 'package:ppoa/client/components/templates/scaffolds/ppo_scaffold.dart';
import 'package:ppoa/client/constants/ppo_design_constants.dart';
import 'package:ppoa/client/home/components/home_recommended_feature.dart';
import 'package:ppoa/client/routing/app_router.gr.dart';
import 'package:unicons/unicons.dart';
import 'components/home_account_activation_panel.dart';
import 'home_keys.dart';

class HomePage extends HookConsumerWidget with ServiceMixin {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignSystemBrand branding = ref.watch(stateProvider.select((value) => value.designSystem.brand));

    return PPOScaffold(
      children: <Widget>[
        SliverList(
          delegate: SliverChildListDelegate(
            <Widget>[
              PPOAppBar(
                includePadding: true,
                backgroundColor: branding.colors.pink,
                foregroundColor: branding.colors.pink.complimentTextColor(branding),
                trailing: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    PPOButton(
                      brand: branding,
                      onTapped: () async {},
                      label: 'Search',
                      activeColor: branding.colors.pink,
                      icon: UniconsLine.search,
                      layout: PPOButtonLayout.iconOnly,
                      style: PPOButtonStyle.search,
                    ),
                    kPaddingSmall.asHorizontalWidget,
                    PPOButton(
                      brand: branding,
                      onTapped: () async {},
                      label: 'Notifications',
                      activeColor: branding.colors.pink,
                      icon: UniconsLine.bell,
                      layout: PPOButtonLayout.iconOnly,
                      style: PPOButtonStyle.search,
                    ),
                  ],
                ),
              ),
              AnimatedContainer(
                duration: kAnimationDurationRegular,
                padding: const EdgeInsets.only(left: kPaddingMedium, right: kPaddingMedium, bottom: kPaddingMedium),
                decoration: BoxDecoration(color: branding.colors.pink),
                child: HomeAccountActivationPanel(branding: branding),
              ),
              AnimatedContainer(
                duration: kAnimationDurationRegular,
                height: 200.0,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: branding.colors.pink,
                ),
                child: PageView(
                  children: <Widget>[
                    HomeRecommendedFeature(
                      title: 'U=U equals you and me ;)',
                      imagePath: 'https://loremflickr.com/320/320/person',
                      displayName: '@PositiveLad',
                      postedTime: DateTime.now().subtract(const Duration(minutes: 5)),
                      branding: branding,
                    ),
                    HomeRecommendedFeature(
                      title: 'I\'m not dirty, you\'re just dumb',
                      imagePath: 'https://loremflickr.com/320/320/person',
                      displayName: '@ZappaVlogger',
                      postedTime: DateTime.now().subtract(const Duration(minutes: 120)),
                      branding: branding,
                    ),
                    HomeRecommendedFeature(
                      title: 'Party in the park event...',
                      imagePath: 'https://loremflickr.com/320/320/person',
                      displayName: '@AkaThementor',
                      postedTime: DateTime.now(),
                      eventLocation: 'Bristol',
                      eventTime: DateTime.now().add(const Duration(days: 5)),
                      branding: branding,
                    ),
                  ],
                ),
              ),
              AnimatedContainer(
                duration: kAnimationDurationRegular,
                height: kPaddingMedium,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: branding.colors.pink,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20.0),
                    bottomRight: Radius.circular(20.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> onResetSelected() async {
    await sharedPreferences.clear();
    await googleSignIn.signOut();
    await firebaseAuth.signOut();
    await router.replaceAll([SplashRoute()]);
  }
}
