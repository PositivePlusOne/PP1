// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:ppoa/business/extensions/brand_extensions.dart';
import 'package:ppoa/business/services/service_mixin.dart';
import 'package:ppoa/client/components/atoms/buttons/enumerations/ppo_checkbox_style.dart';
import 'package:ppoa/client/components/atoms/buttons/ppo_checkbox.dart';
import '../../../../business/state/design_system/models/design_system_brand.dart';

class PPOCheckboxTestPage extends StatefulHookConsumerWidget {
  const PPOCheckboxTestPage({
    this.initialPage = 0,
    super.key,
  });

  final int initialPage;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PPOCheckboxTestPageState();
}

class _PPOCheckboxTestPageState extends ConsumerState<PPOCheckboxTestPage> with ServiceMixin {
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
          backgroundColor: brand.colors.secondaryColor,
          title: const Text('Checkboxes'),
          bottom: TabBar(
            indicatorColor: brand.colors.secondaryColor.complimentTextColor(brand),
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
            ListView(controller: ScrollController(), padding: const EdgeInsets.symmetric(horizontal: 20.0), children: _buildLargeCheckboxes(brand)),
            ListView(controller: ScrollController(), padding: const EdgeInsets.symmetric(horizontal: 20.0), children: _buildSmallCheckboxes(brand)),
          ],
        ),
      ),
    );
  }
}

List<Widget> _buildLargeCheckboxes(DesignSystemBrand brand) {
  return <Widget>[
    const ListTile(title: Text('Large'), subtitle: Text('Large checkbox styles')),
    PPOCheckbox(brand: brand, isChecked: true, isDisabled: false, style: PPOCheckboxStyle.large, onTapped: () async {}, label: 'I’ve read and agree to the pledge'),
    10.0.asVerticalWidget,
    PPOCheckbox(brand: brand, isChecked: false, isDisabled: true, style: PPOCheckboxStyle.large, onTapped: () async {}, label: 'I’ve read and agree to the pledge'),
    10.0.asVerticalWidget,
    const ListTile(title: Text('Large (Tooltip)'), subtitle: Text('Large checkbox styles with tooltips')),
    PPOCheckbox(brand: brand, isChecked: true, isDisabled: false, style: PPOCheckboxStyle.large, onTapped: () async {}, label: 'I’ve read and agree to the pledge', tooltip: 'An example tooltip'),
    10.0.asVerticalWidget,
    PPOCheckbox(brand: brand, isChecked: false, isDisabled: true, style: PPOCheckboxStyle.large, onTapped: () async {}, label: 'I’ve read and agree to the pledge', tooltip: 'An example tooltip'),
  ];
}

List<Widget> _buildSmallCheckboxes(DesignSystemBrand brand) {
  return <Widget>[
    const ListTile(title: Text('Small'), subtitle: Text('Small checkbox styles')),
    PPOCheckbox(brand: brand, isChecked: true, isDisabled: false, style: PPOCheckboxStyle.small, onTapped: () async {}, label: 'I’ve read and agree to the pledge'),
    10.0.asVerticalWidget,
    PPOCheckbox(brand: brand, isChecked: false, isDisabled: true, style: PPOCheckboxStyle.small, onTapped: () async {}, label: 'I’ve read and agree to the pledge'),
    10.0.asVerticalWidget,
    const ListTile(title: Text('Small (Tooltip)'), subtitle: Text('Small checkbox styles with tooltips')),
    PPOCheckbox(brand: brand, isChecked: true, isDisabled: false, style: PPOCheckboxStyle.small, onTapped: () async {}, label: 'I’ve read and agree to the pledge', tooltip: 'An example tooltip'),
    10.0.asVerticalWidget,
    PPOCheckbox(brand: brand, isChecked: false, isDisabled: true, style: PPOCheckboxStyle.small, onTapped: () async {}, label: 'I’ve read and agree to the pledge', tooltip: 'An example tooltip'),
  ];
}
