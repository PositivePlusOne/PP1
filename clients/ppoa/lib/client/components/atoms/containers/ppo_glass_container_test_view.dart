// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:ppoa/business/extensions/brand_extensions.dart';
import 'package:ppoa/business/services/service_mixin.dart';
import 'package:ppoa/client/components/atoms/buttons/enumerations/ppo_button_layout.dart';
import 'package:ppoa/client/components/atoms/buttons/enumerations/ppo_button_style.dart';
import 'package:ppoa/client/components/atoms/buttons/ppo_button.dart';
import 'package:ppoa/client/components/atoms/containers/ppo_glass_container.dart';
import 'package:ppoa/resources/resources.dart';
import '../../../../business/state/design_system/models/design_system_brand.dart';

class PPOGlassContainerTestView extends StatefulHookConsumerWidget {
  const PPOGlassContainerTestView({
    this.initialPage = 0,
    super.key,
  });

  final int initialPage;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PPOGlassContainerTestViewState();
}

class _PPOGlassContainerTestViewState extends ConsumerState<PPOGlassContainerTestView> with ServiceMixin {
  late PageController _pageController;

  @override
  void initState() {
    _pageController = PageController(initialPage: widget.initialPage);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final DesignSystemBrand brand = ref.watch(stateProvider.select((value) => value.designSystem.brand));

    return DefaultTabController(
      initialIndex: widget.initialPage,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: brand.secondaryColor.toColorFromHex(),
          title: const Text('Glass Container'),
          bottom: TabBar(
            indicatorColor: brand.secondaryColor.toColorFromHex().complimentTextColor(brand),
            isScrollable: true,
            onTap: (int index) => _pageController.jumpToPage(index),
            tabs: const <Tab>[
              Tab(icon: SizedBox.shrink(), text: 'Standard'),
              Tab(icon: SizedBox.shrink(), text: 'Dismissible'),
              Tab(icon: SizedBox.shrink(), text: 'Overlays'),
            ],
          ),
        ),
        body: Stack(
          children: <Widget>[
            Positioned(
              left: 0.0,
              bottom: 0.0,
              right: 0.0,
              child: Image.asset(MockImages.bike, fit: BoxFit.cover),
            ),
            Positioned.fill(
              child: PageView(
                controller: _pageController,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(mainAxisAlignment: MainAxisAlignment.end, children: _buildStandardOverlays(brand)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(mainAxisAlignment: MainAxisAlignment.end, children: _buildStandardOverlays(brand)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(mainAxisAlignment: MainAxisAlignment.end, children: _buildStandardOverlays(brand)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

List<Widget> _buildButtons(DesignSystemBrand brand) {
  return <Widget>[
    PPOButton(brand: brand, onTapped: () async {}, label: 'First button', style: PPOButtonStyle.secondary, layout: PPOButtonLayout.textOnly),
    20.0.asVerticalWidget,
    PPOButton(brand: brand, onTapped: () async {}, label: 'Second button', style: PPOButtonStyle.secondary, layout: PPOButtonLayout.textOnly),
    20.0.asVerticalWidget,
    PPOButton(brand: brand, onTapped: () async {}, label: 'Third button', style: PPOButtonStyle.secondary, layout: PPOButtonLayout.textOnly),
    40.0.asVerticalWidget,
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Flexible(child: PPOButton(brand: brand, onTapped: () async {}, label: 'Fourth', style: PPOButtonStyle.secondary, layout: PPOButtonLayout.textOnly)),
        5.0.asHorizontalWidget,
        Flexible(child: PPOButton(brand: brand, onTapped: () async {}, label: 'Fifth', style: PPOButtonStyle.secondary, layout: PPOButtonLayout.textOnly)),
      ],
    ),
  ];
}

List<Widget> _buildStandardOverlays(DesignSystemBrand brand) {
  return <Widget>[
    PPOGlassContainer(brand: brand, children: _buildButtons(brand)),
  ];
}
