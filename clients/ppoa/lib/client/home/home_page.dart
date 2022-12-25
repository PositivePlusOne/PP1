// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:ppoa/business/services/service_mixin.dart';
import 'package:ppoa/business/state/content/recommended_content.dart';
import 'package:ppoa/business/state/design_system/models/design_system_brand.dart';
import 'package:ppoa/client/components/templates/scaffolds/ppo_scaffold.dart';
import 'package:ppoa/client/home/enumerations/home_page_header_content.dart';
import 'package:ppoa/client/routing/app_router.gr.dart';
import 'components/home_page_app_bar.dart';

class HomePage extends HookConsumerWidget with ServiceMixin {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignSystemBrand branding = ref.watch(stateProvider.select((value) => value.designSystem.brand));
    final List<RecommendedContent> recommendedContent = ref.watch(stateProvider.select((value) => value.contentState.recommendedContent));

    final List<HomePageHeaderContent> headerContentList = <HomePageHeaderContent>[
      HomePageHeaderContent.appBar,
      HomePageHeaderContent.signIn,
      if (recommendedContent.isNotEmpty) ...<HomePageHeaderContent>[
        HomePageHeaderContent.recommendations,
      ],
    ];

    return PPOScaffold(
      children: <Widget>[
        HomePageAppBar(
          branding: branding,
          headerContentList: headerContentList,
          recommendedContent: recommendedContent,
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
