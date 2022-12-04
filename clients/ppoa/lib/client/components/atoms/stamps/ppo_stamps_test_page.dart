// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:ppoa/business/extensions/brand_extensions.dart';
import 'package:ppoa/business/services/service_mixin.dart';
import 'package:ppoa/business/state/design_system/models/design_system_brand.dart';
import 'package:ppoa/client/components/atoms/stamps/stamp.dart';

class PPOStampTestPage extends StatefulHookConsumerWidget {
  const PPOStampTestPage({
    this.initialPage = 0,
    super.key,
  });

  final int initialPage;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PPOStampTestPageState();
}

class _PPOStampTestPageState extends ConsumerState<PPOStampTestPage> with ServiceMixin {
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
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: brand.colors.purple,
          title: const Text('Buttons'),
          bottom: TabBar(
            indicatorColor: brand.colors.purple.complimentTextColor(brand),
            isScrollable: true,
            onTap: (int index) => _pageController.jumpToPage(index),
            tabs: const <Tab>[
              Tab(icon: SizedBox.shrink(), text: 'Victory'),
              Tab(icon: SizedBox.shrink(), text: 'Fist'),
              Tab(icon: SizedBox.shrink(), text: 'Positive'),
              Tab(icon: SizedBox.shrink(), text: 'Smile'),
            ],
          ),
        ),
        body: PageView(
          controller: _pageController,
          children: <Widget>[
            ListView(controller: ScrollController(), padding: const EdgeInsets.symmetric(horizontal: 10.0), children: _victoryStamps(brand)),
            ListView(controller: ScrollController(), padding: const EdgeInsets.symmetric(horizontal: 10.0), children: _onePlusStamps(brand)),
            ListView(controller: ScrollController(), padding: const EdgeInsets.symmetric(horizontal: 10.0), children: _fistStamps(brand)),
            ListView(controller: ScrollController(), padding: const EdgeInsets.symmetric(horizontal: 10.0), children: _smileStamps(brand)),
          ],
        ),
      ),
    );
  }
}

List<Widget> _victoryStamps(DesignSystemBrand branding) {
  return [
    const SizedBox(
      height: 10.0,
    ),
    Stamp.victory(
      branding: branding,
      animate: false,
    ),
    const SizedBox(
      height: 10.0,
    ),
    Stamp.victory(
      branding: branding,
      animate: true,
    ),
  ];
}

List<Widget> _onePlusStamps(DesignSystemBrand branding) {
  return [
    const SizedBox(
      height: 10.0,
    ),
    Stamp.onePlus(
      branding: branding,
      animate: false,
    ),
    const SizedBox(
      height: 10.0,
    ),
    Stamp.onePlus(
      branding: branding,
      animate: true,
    ),
  ];
}

List<Widget> _fistStamps(DesignSystemBrand branding) {
  return [
    const SizedBox(
      height: 10.0,
    ),
    Stamp.fist(
      branding: branding,
      animate: false,
    ),
    const SizedBox(
      height: 10.0,
    ),
    Stamp.fist(
      branding: branding,
      animate: true,
    ),
  ];
}

List<Widget> _smileStamps(DesignSystemBrand branding) {
  return [
    const SizedBox(
      height: 10.0,
    ),
    Stamp.smile(
      branding: branding,
    ),
  ];
}
