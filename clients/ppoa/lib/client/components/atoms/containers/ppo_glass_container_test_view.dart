// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:ppoa/business/extensions/brand_extensions.dart';
import 'package:ppoa/business/services/service_mixin.dart';
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
        body: PageView(
          controller: _pageController,
          children: <Widget>[
            ListView(controller: ScrollController(), padding: const EdgeInsets.symmetric(horizontal: 10.0), children: []),
            ListView(controller: ScrollController(), padding: const EdgeInsets.symmetric(horizontal: 10.0), children: []),
            ListView(controller: ScrollController(), padding: const EdgeInsets.symmetric(horizontal: 10.0), children: []),
          ],
        ),
      ),
    );
  }
}
