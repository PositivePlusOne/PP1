import 'package:flutter/material.dart';
import 'package:ppoa/business/extensions/brand_extensions.dart';
import 'package:unicons/unicons.dart';

import '../../../business/state/content/recommended_content.dart';
import '../../../business/state/design_system/models/design_system_brand.dart';
import '../../components/atoms/buttons/enumerations/ppo_button_layout.dart';
import '../../components/atoms/buttons/enumerations/ppo_button_style.dart';
import '../../components/atoms/buttons/ppo_button.dart';
import '../../components/molecules/navigation/ppo_app_bar.dart';
import '../../constants/ppo_design_constants.dart';
import '../enumerations/home_page_header_content.dart';
import 'home_account_activation_panel.dart';
import 'home_recommended_feature_panel.dart';

class HomePageAppBar extends StatelessWidget {
  const HomePageAppBar({
    Key? key,
    required this.branding,
    required this.headerContentList,
    required this.recommendedContent,
  }) : super(key: key);

  final DesignSystemBrand branding;
  final List<HomePageHeaderContent> headerContentList;
  final List<RecommendedContent> recommendedContent;

  static const double kRecommendedPanelHeight = 246.0;

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);

    return SliverToBoxAdapter(
      child: AnimatedContainer(
        duration: kAnimationDurationRegular,
        decoration: BoxDecoration(
          color: branding.colors.pink,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(20.0),
            bottomRight: Radius.circular(20.0),
          ),
        ),
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: headerContentList.length,
          separatorBuilder: (_, __) => kPaddingMedium.asVerticalWidget,
          padding: EdgeInsets.only(
            top: kPaddingMedium + mediaQueryData.padding.top,
            bottom: kPaddingMedium,
          ),
          itemBuilder: (_, int index) {
            final HomePageHeaderContent headerContent = headerContentList[index];
            switch (headerContent) {
              case HomePageHeaderContent.appBar:
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: kPaddingMedium),
                  child: PPOAppBar(
                    includePadding: false,
                    backgroundColor: Colors.transparent,
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
                );
              case HomePageHeaderContent.signIn:
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: kPaddingMedium),
                  child: HomeAccountActivationPanel(branding: branding),
                );
              case HomePageHeaderContent.recommendations:
                return SizedBox(
                  height: kRecommendedPanelHeight,
                  width: double.infinity,
                  child: PageView(
                    children: recommendedContent
                        .map(
                          (e) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: kPaddingMedium),
                            child: HomeRecommendedFeaturePanel(branding: branding, recommendedContent: e),
                          ),
                        )
                        .toList(),
                  ),
                );
            }
          },
        ),
      ),
    );
  }
}
