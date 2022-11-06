// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:ppoa/business/extensions/brand_extensions.dart';
import 'package:ppoa/business/services/service_mixin.dart';
import 'package:ppoa/client/components/atoms/buttons/enumerations/ppo_button_layout.dart';
import 'package:ppoa/client/components/atoms/buttons/enumerations/ppo_button_style.dart';
import 'package:ppoa/client/components/atoms/buttons/enumerations/ppo_checkbox_style.dart';
import 'package:ppoa/client/components/atoms/buttons/ppo_button.dart';
import 'package:ppoa/client/components/atoms/buttons/ppo_checkbox.dart';
import '../../../../business/state/design_system/models/design_system_brand.dart';

class PPOCheckboxTestView extends StatefulHookConsumerWidget {
  const PPOCheckboxTestView({
    this.initialPage = 0,
    super.key,
  });

  final int initialPage;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PPOCheckboxTestViewState();
}

class _PPOCheckboxTestViewState extends ConsumerState<PPOCheckboxTestView> with ServiceMixin {
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
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: brand.secondaryColor.toColorFromHex(),
          title: const Text('Checkboxs'),
          bottom: TabBar(
            indicatorColor: brand.secondaryColor.toColorFromHex().complimentTextColor(brand),
            isScrollable: true,
            onTap: (int index) => _pageController.jumpToPage(index),
            tabs: const <Tab>[
              Tab(icon: SizedBox.shrink(), text: 'Large'),
              Tab(icon: SizedBox.shrink(), text: 'Small'),
            ],
          ),
        ),
        body: PageView(
          controller: _pageController,
          children: <Widget>[
            ListView(controller: ScrollController(), padding: const EdgeInsets.symmetric(horizontal: 10.0), children: _buildLargeCheckboxes(brand)),
            ListView(controller: ScrollController(), padding: const EdgeInsets.symmetric(horizontal: 10.0), children: _buildSmallCheckboxes(brand)),
          ],
        ),
      ),
    );
  }
}

List<Widget> _buildLargeCheckboxes(DesignSystemBrand brand) {
  return <Widget>[
    const ListTile(title: Text('Large'), subtitle: Text('Large checkbox styles')),
    PPOCheckbox(brand: brand, isChecked: true, isEnabled: true, style: PPOCheckboxStyle.large, onCheckboxSelected: () async {}, tooltip: 'I’ve read and agree to the pledge'),
    10.0.asVerticalWidget,
    PPOCheckbox(brand: brand, isChecked: false, isEnabled: true, style: PPOCheckboxStyle.large, onCheckboxSelected: () async {}, tooltip: 'I’ve read and agree to the pledge'),
  ];
}

List<Widget> _buildSmallCheckboxes(DesignSystemBrand brand) {
  return <Widget>[
    const ListTile(title: Text('Small'), subtitle: Text('Small checkbox styles')),
    PPOCheckbox(brand: brand, isChecked: true, isEnabled: true, style: PPOCheckboxStyle.small, onCheckboxSelected: () async {}, tooltip: 'I’ve read and agree to the pledge'),
    10.0.asVerticalWidget,
    PPOCheckbox(brand: brand, isChecked: false, isEnabled: true, style: PPOCheckboxStyle.small, onCheckboxSelected: () async {}, tooltip: 'I’ve read and agree to the pledge'),
  ];
}
