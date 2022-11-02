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
import '../../../../business/state/design_system/models/design_system_brand.dart';

class PPOButtonTestView extends StatefulHookConsumerWidget {
  const PPOButtonTestView({
    this.initialPage = 0,
    super.key,
  });

  final int initialPage;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PPOButtonTestViewState();
}

class _PPOButtonTestViewState extends ConsumerState<PPOButtonTestView> with ServiceMixin {
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
      length: 9,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: brand.secondaryColor.toColorFromHex(),
          title: const Text('Buttons'),
          bottom: TabBar(
            indicatorColor: brand.secondaryColor.toColorFromHex().complimentTextColor(brand),
            isScrollable: true,
            onTap: (int index) => _pageController.jumpToPage(index),
            tabs: const <Tab>[
              Tab(icon: SizedBox.shrink(), text: 'Primary'),
              Tab(icon: SizedBox.shrink(), text: 'Secondary'),
              Tab(icon: SizedBox.shrink(), text: 'Tertiary'),
              Tab(icon: SizedBox.shrink(), text: 'Ghost'),
              Tab(icon: SizedBox.shrink(), text: 'Minor'),
              Tab(icon: SizedBox.shrink(), text: 'Text'),
              Tab(icon: SizedBox.shrink(), text: 'Label'),
              Tab(icon: SizedBox.shrink(), text: 'Large Icon'),
              Tab(icon: SizedBox.shrink(), text: 'Navigation'),
            ],
          ),
        ),
        body: PageView(
          controller: _pageController,
          children: <Widget>[
            ListView(controller: ScrollController(), padding: const EdgeInsets.symmetric(horizontal: 10.0), children: _getPrimaryButtons(brand)),
            ListView(controller: ScrollController(), padding: const EdgeInsets.symmetric(horizontal: 10.0), children: _getSecondaryButtons(brand)),
            ListView(controller: ScrollController(), padding: const EdgeInsets.symmetric(horizontal: 10.0), children: _getTertiaryButtons(brand)),
            ListView(controller: ScrollController(), padding: const EdgeInsets.symmetric(horizontal: 10.0), children: _getGhostButtons(brand)),
            ListView(controller: ScrollController(), padding: const EdgeInsets.symmetric(horizontal: 10.0), children: _getMinorButtons(brand)),
            ListView(controller: ScrollController(), padding: const EdgeInsets.symmetric(horizontal: 10.0), children: _getTextButtons(brand)),
            ListView(controller: ScrollController(), padding: const EdgeInsets.symmetric(horizontal: 10.0), children: _getLabelButtons(brand)),
            ListView(controller: ScrollController(), padding: const EdgeInsets.symmetric(horizontal: 10.0), children: _getLargeIconButtons(brand)),
            ListView(controller: ScrollController(), padding: const EdgeInsets.symmetric(horizontal: 10.0), children: _getNavigationIconButtons(brand)),
          ],
        ),
      ),
    );
  }
}

List<Widget> _getNavigationIconButtons(DesignSystemBrand brand) {
  return <Widget>[
    ...<Widget>[
      const ListTile(title: Text('Navigation'), subtitle: Text('Inactive button styles')),
      Align(alignment: Alignment.centerLeft, child: PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Navigation (NNNNOY)', layout: PPOButtonLayout.iconOnly, style: PPOButtonStyle.navigation, onTapped: () async {}, isActive: false, isDisabled: false, isFocused: false)),
      10.0.asVerticalWidget,
    ],
    ...<Widget>[
      const ListTile(title: Text('Navigation'), subtitle: Text('Tapped / hovered button styles')),
      Align(alignment: Alignment.centerLeft, child: PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Navigation (YNNNOY)', layout: PPOButtonLayout.iconOnly, style: PPOButtonStyle.navigation, onTapped: () async {}, isActive: false, isDisabled: false, isFocused: false, forceTappedState: true)),
      10.0.asVerticalWidget,
    ],
    ...<Widget>[
      const ListTile(title: Text('Navigation'), subtitle: Text('Active button styles')),
      Align(alignment: Alignment.centerLeft, child: PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Navigation (NYNNOY)', layout: PPOButtonLayout.iconOnly, style: PPOButtonStyle.navigation, onTapped: () async {}, isActive: true, isDisabled: false, isFocused: false)),
      10.0.asVerticalWidget,
    ],
    ...<Widget>[
      const ListTile(title: Text('Navigation'), subtitle: Text('Focused button styles')),
      Align(alignment: Alignment.centerLeft, child: PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Navigation (NNYNOY)', layout: PPOButtonLayout.iconOnly, style: PPOButtonStyle.navigation, onTapped: () async {}, isActive: true, isDisabled: false, isFocused: true)),
      10.0.asVerticalWidget,
    ],
    ...<Widget>[
      const ListTile(title: Text('Navigation'), subtitle: Text('Disabled button styles')),
      Align(alignment: Alignment.centerLeft, child: PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Navigation (NNNYOY)', layout: PPOButtonLayout.iconOnly, style: PPOButtonStyle.largeIcon, onTapped: () async {}, isActive: true, isDisabled: true, isFocused: false)),
      10.0.asVerticalWidget,
    ],
  ];
}

List<Widget> _getLargeIconButtons(DesignSystemBrand brand) {
  return <Widget>[
    ...<Widget>[
      const ListTile(title: Text('Large Icon'), subtitle: Text('Inactive button styles')),
      Align(alignment: Alignment.centerLeft, child: PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Large Icon (NNNNOY)', layout: PPOButtonLayout.iconOnly, style: PPOButtonStyle.largeIcon, onTapped: () async {}, isActive: false, isDisabled: false, isFocused: false)),
      10.0.asVerticalWidget,
    ],
    ...<Widget>[
      const ListTile(title: Text('Large Icon'), subtitle: Text('Tapped / hovered button styles')),
      Align(alignment: Alignment.centerLeft, child: PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Large Icon (YNNNOY)', layout: PPOButtonLayout.iconOnly, style: PPOButtonStyle.largeIcon, onTapped: () async {}, isActive: false, isDisabled: false, isFocused: false, forceTappedState: true)),
      10.0.asVerticalWidget,
    ],
    ...<Widget>[
      const ListTile(title: Text('Large Icon'), subtitle: Text('Active button styles')),
      Align(alignment: Alignment.centerLeft, child: PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Large Icon (NYNNOY)', layout: PPOButtonLayout.iconOnly, style: PPOButtonStyle.largeIcon, onTapped: () async {}, isActive: true, isDisabled: false, isFocused: false)),
      10.0.asVerticalWidget,
    ],
    ...<Widget>[
      const ListTile(title: Text('Large Icon'), subtitle: Text('Focused button styles')),
      Align(alignment: Alignment.centerLeft, child: PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Large Icon (NNYNOY)', layout: PPOButtonLayout.iconOnly, style: PPOButtonStyle.largeIcon, onTapped: () async {}, isActive: true, isDisabled: false, isFocused: true)),
      10.0.asVerticalWidget,
    ],
    ...<Widget>[
      const ListTile(title: Text('Large Icon'), subtitle: Text('Disabled button styles')),
      Align(alignment: Alignment.centerLeft, child: PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Large Icon (NNNYOY)', layout: PPOButtonLayout.iconOnly, style: PPOButtonStyle.largeIcon, onTapped: () async {}, isActive: true, isDisabled: true, isFocused: false)),
      10.0.asVerticalWidget,
    ],
  ];
}

List<Widget> _getLabelButtons(DesignSystemBrand brand) {
  return <Widget>[
    ...<Widget>[
      const ListTile(title: Text('Label'), subtitle: Text('Button styles')),
      PPOButton(brand: brand, label: 'Follow', tooltip: 'Label (NNNNNY)', layout: PPOButtonLayout.textOnly, style: PPOButtonStyle.label, onTapped: () async {}, isActive: false, isDisabled: false, isFocused: false),
      10.0.asVerticalWidget,
      PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Label (NNNNRY)', layout: PPOButtonLayout.iconRight, style: PPOButtonStyle.label, onTapped: () async {}, isActive: false, isDisabled: false, isFocused: false),
      10.0.asVerticalWidget,
      PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Label (NNNNLY)', layout: PPOButtonLayout.iconLeft, style: PPOButtonStyle.label, onTapped: () async {}, isActive: false, isDisabled: false, isFocused: false),
      10.0.asVerticalWidget,
      Align(alignment: Alignment.centerLeft, child: PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Label (NNNNOY)', layout: PPOButtonLayout.iconOnly, style: PPOButtonStyle.label, onTapped: () async {}, isActive: false, isDisabled: false, isFocused: false)),
      10.0.asVerticalWidget,
    ],
  ];
}

List<Widget> _getTextButtons(DesignSystemBrand brand) {
  return <Widget>[
    ...<Widget>[
      const ListTile(title: Text('Text'), subtitle: Text('Inactive button styles')),
      PPOButton(brand: brand, label: 'Follow', tooltip: 'Text (NNNNNY)', layout: PPOButtonLayout.textOnly, style: PPOButtonStyle.text, onTapped: () async {}, isActive: false, isDisabled: false, isFocused: false),
      10.0.asVerticalWidget,
      PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Text (NNNNRY)', layout: PPOButtonLayout.iconRight, style: PPOButtonStyle.text, onTapped: () async {}, isActive: false, isDisabled: false, isFocused: false),
      10.0.asVerticalWidget,
      PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Text (NNNNLY)', layout: PPOButtonLayout.iconLeft, style: PPOButtonStyle.text, onTapped: () async {}, isActive: false, isDisabled: false, isFocused: false),
      10.0.asVerticalWidget,
      Align(alignment: Alignment.centerLeft, child: PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Text (NNNNOY)', layout: PPOButtonLayout.iconOnly, style: PPOButtonStyle.text, onTapped: () async {}, isActive: false, isDisabled: false, isFocused: false)),
      10.0.asVerticalWidget,
    ],
    ...<Widget>[
      const ListTile(title: Text('Text'), subtitle: Text('Tapped / hovered button styles')),
      PPOButton(brand: brand, label: 'Follow', tooltip: 'Text (YNNNNY)', layout: PPOButtonLayout.textOnly, style: PPOButtonStyle.text, onTapped: () async {}, isActive: false, isDisabled: false, isFocused: false, forceTappedState: true),
      10.0.asVerticalWidget,
      PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Text (YNNNRY)', layout: PPOButtonLayout.iconRight, style: PPOButtonStyle.text, onTapped: () async {}, isActive: false, isDisabled: false, isFocused: false, forceTappedState: true),
      10.0.asVerticalWidget,
      PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Text (YNNNLY)', layout: PPOButtonLayout.iconLeft, style: PPOButtonStyle.text, onTapped: () async {}, isActive: false, isDisabled: false, isFocused: false, forceTappedState: true),
      10.0.asVerticalWidget,
      Align(alignment: Alignment.centerLeft, child: PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Text (YNNNOY)', layout: PPOButtonLayout.iconOnly, style: PPOButtonStyle.text, onTapped: () async {}, isActive: false, isDisabled: false, isFocused: false, forceTappedState: true)),
      10.0.asVerticalWidget,
    ],
    ...<Widget>[
      const ListTile(title: Text('Text'), subtitle: Text('Active button styles')),
      PPOButton(brand: brand, label: 'Follow', tooltip: 'Text (NYNNNY)', layout: PPOButtonLayout.textOnly, style: PPOButtonStyle.text, onTapped: () async {}, isActive: true, isDisabled: false, isFocused: false),
      10.0.asVerticalWidget,
      PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Text (NYNNRY)', layout: PPOButtonLayout.iconRight, style: PPOButtonStyle.text, onTapped: () async {}, isActive: true, isDisabled: false, isFocused: false),
      10.0.asVerticalWidget,
      PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Text (NYNNLY)', layout: PPOButtonLayout.iconLeft, style: PPOButtonStyle.text, onTapped: () async {}, isActive: true, isDisabled: false, isFocused: false),
      10.0.asVerticalWidget,
      Align(alignment: Alignment.centerLeft, child: PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Text (NYNNOY)', layout: PPOButtonLayout.iconOnly, style: PPOButtonStyle.text, onTapped: () async {}, isActive: true, isDisabled: false, isFocused: false)),
      10.0.asVerticalWidget,
    ],
    ...<Widget>[
      const ListTile(title: Text('Text'), subtitle: Text('Focused button styles')),
      PPOButton(brand: brand, label: 'Follow', tooltip: 'Text (NNYNNY)', layout: PPOButtonLayout.textOnly, style: PPOButtonStyle.text, onTapped: () async {}, isActive: true, isDisabled: false, isFocused: true),
      10.0.asVerticalWidget,
      PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Text (NNYNRY)', layout: PPOButtonLayout.iconRight, style: PPOButtonStyle.text, onTapped: () async {}, isActive: true, isDisabled: false, isFocused: true),
      10.0.asVerticalWidget,
      PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Text (NNYNLY)', layout: PPOButtonLayout.iconLeft, style: PPOButtonStyle.text, onTapped: () async {}, isActive: true, isDisabled: false, isFocused: true),
      10.0.asVerticalWidget,
      Align(alignment: Alignment.centerLeft, child: PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Text (NNYNOY)', layout: PPOButtonLayout.iconOnly, style: PPOButtonStyle.text, onTapped: () async {}, isActive: true, isDisabled: false, isFocused: true)),
      10.0.asVerticalWidget,
    ],
    ...<Widget>[
      const ListTile(title: Text('Text'), subtitle: Text('Disabled button styles')),
      PPOButton(brand: brand, label: 'Follow', tooltip: 'Text (NNNYNY)', layout: PPOButtonLayout.textOnly, style: PPOButtonStyle.text, onTapped: () async {}, isActive: true, isDisabled: true, isFocused: false),
      10.0.asVerticalWidget,
      PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Text (NNNYRY)', layout: PPOButtonLayout.iconRight, style: PPOButtonStyle.text, onTapped: () async {}, isActive: true, isDisabled: true, isFocused: false),
      10.0.asVerticalWidget,
      PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Text (NNNYLY)', layout: PPOButtonLayout.iconLeft, style: PPOButtonStyle.text, onTapped: () async {}, isActive: true, isDisabled: true, isFocused: false),
      10.0.asVerticalWidget,
      Align(alignment: Alignment.centerLeft, child: PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Text (NNNYOY)', layout: PPOButtonLayout.iconOnly, style: PPOButtonStyle.text, onTapped: () async {}, isActive: true, isDisabled: true, isFocused: false)),
      10.0.asVerticalWidget,
    ],
  ];
}

List<Widget> _getMinorButtons(DesignSystemBrand brand) {
  return <Widget>[
    ...<Widget>[
      const ListTile(title: Text('Minor'), subtitle: Text('Inactive button styles')),
      PPOButton(brand: brand, label: 'Follow', tooltip: 'Minor (NNNNNY)', layout: PPOButtonLayout.textOnly, style: PPOButtonStyle.minor, onTapped: () async {}, isActive: false, isDisabled: false, isFocused: false),
      10.0.asVerticalWidget,
      PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Minor (NNNNRY)', layout: PPOButtonLayout.iconRight, style: PPOButtonStyle.minor, onTapped: () async {}, isActive: false, isDisabled: false, isFocused: false),
      10.0.asVerticalWidget,
      PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Minor (NNNNLY)', layout: PPOButtonLayout.iconLeft, style: PPOButtonStyle.minor, onTapped: () async {}, isActive: false, isDisabled: false, isFocused: false),
      10.0.asVerticalWidget,
      Align(alignment: Alignment.centerLeft, child: PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Minor (NNNNOY)', layout: PPOButtonLayout.iconOnly, style: PPOButtonStyle.minor, onTapped: () async {}, isActive: false, isDisabled: false, isFocused: false)),
      10.0.asVerticalWidget,
    ],
    ...<Widget>[
      const ListTile(title: Text('Minor'), subtitle: Text('Tapped / hovered button styles')),
      PPOButton(brand: brand, label: 'Follow', tooltip: 'Minor (YNNNNY)', layout: PPOButtonLayout.textOnly, style: PPOButtonStyle.minor, onTapped: () async {}, isActive: false, isDisabled: false, isFocused: false, forceTappedState: true),
      10.0.asVerticalWidget,
      PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Minor (YNNNRY)', layout: PPOButtonLayout.iconRight, style: PPOButtonStyle.minor, onTapped: () async {}, isActive: false, isDisabled: false, isFocused: false, forceTappedState: true),
      10.0.asVerticalWidget,
      PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Minor (YNNNLY)', layout: PPOButtonLayout.iconLeft, style: PPOButtonStyle.minor, onTapped: () async {}, isActive: false, isDisabled: false, isFocused: false, forceTappedState: true),
      10.0.asVerticalWidget,
      Align(alignment: Alignment.centerLeft, child: PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Minor (YNNNOY)', layout: PPOButtonLayout.iconOnly, style: PPOButtonStyle.minor, onTapped: () async {}, isActive: false, isDisabled: false, isFocused: false, forceTappedState: true)),
      10.0.asVerticalWidget,
    ],
    ...<Widget>[
      const ListTile(title: Text('Minor'), subtitle: Text('Active button styles')),
      PPOButton(brand: brand, label: 'Follow', tooltip: 'Minor (NYNNNY)', layout: PPOButtonLayout.textOnly, style: PPOButtonStyle.minor, onTapped: () async {}, isActive: true, isDisabled: false, isFocused: false),
      10.0.asVerticalWidget,
      PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Minor (NYNNRY)', layout: PPOButtonLayout.iconRight, style: PPOButtonStyle.minor, onTapped: () async {}, isActive: true, isDisabled: false, isFocused: false),
      10.0.asVerticalWidget,
      PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Minor (NYNNLY)', layout: PPOButtonLayout.iconLeft, style: PPOButtonStyle.minor, onTapped: () async {}, isActive: true, isDisabled: false, isFocused: false),
      10.0.asVerticalWidget,
      Align(alignment: Alignment.centerLeft, child: PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Minor (NYNNOY)', layout: PPOButtonLayout.iconOnly, style: PPOButtonStyle.minor, onTapped: () async {}, isActive: true, isDisabled: false, isFocused: false)),
      10.0.asVerticalWidget,
    ],
    ...<Widget>[
      const ListTile(title: Text('Minor'), subtitle: Text('Focused button styles')),
      PPOButton(brand: brand, label: 'Follow', tooltip: 'Minor (NNYNNY)', layout: PPOButtonLayout.textOnly, style: PPOButtonStyle.minor, onTapped: () async {}, isActive: true, isDisabled: false, isFocused: true),
      10.0.asVerticalWidget,
      PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Minor (NNYNRY)', layout: PPOButtonLayout.iconRight, style: PPOButtonStyle.minor, onTapped: () async {}, isActive: true, isDisabled: false, isFocused: true),
      10.0.asVerticalWidget,
      PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Minor (NNYNLY)', layout: PPOButtonLayout.iconLeft, style: PPOButtonStyle.minor, onTapped: () async {}, isActive: true, isDisabled: false, isFocused: true),
      10.0.asVerticalWidget,
      Align(alignment: Alignment.centerLeft, child: PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Minor (NNYNOY)', layout: PPOButtonLayout.iconOnly, style: PPOButtonStyle.minor, onTapped: () async {}, isActive: true, isDisabled: false, isFocused: true)),
      10.0.asVerticalWidget,
    ],
    ...<Widget>[
      const ListTile(title: Text('Minor'), subtitle: Text('Disabled button styles')),
      PPOButton(brand: brand, label: 'Follow', tooltip: 'Minor (NNNYNY)', layout: PPOButtonLayout.textOnly, style: PPOButtonStyle.minor, onTapped: () async {}, isActive: true, isDisabled: true, isFocused: false),
      10.0.asVerticalWidget,
      PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Minor (NNNYRY)', layout: PPOButtonLayout.iconRight, style: PPOButtonStyle.minor, onTapped: () async {}, isActive: true, isDisabled: true, isFocused: false),
      10.0.asVerticalWidget,
      PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Minor (NNNYLY)', layout: PPOButtonLayout.iconLeft, style: PPOButtonStyle.minor, onTapped: () async {}, isActive: true, isDisabled: true, isFocused: false),
      10.0.asVerticalWidget,
      Align(alignment: Alignment.centerLeft, child: PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Minor (NNNYOY)', layout: PPOButtonLayout.iconOnly, style: PPOButtonStyle.minor, onTapped: () async {}, isActive: true, isDisabled: true, isFocused: false)),
      10.0.asVerticalWidget,
    ],
  ];
}

List<Widget> _getGhostButtons(DesignSystemBrand brand) {
  return <Widget>[
    ...<Widget>[
      const ListTile(title: Text('Ghost'), subtitle: Text('Inactive button styles')),
      PPOButton(brand: brand, label: 'Follow', tooltip: 'Ghost (NNNNNY)', layout: PPOButtonLayout.textOnly, style: PPOButtonStyle.ghost, onTapped: () async {}, isActive: false, isDisabled: false, isFocused: false),
      10.0.asVerticalWidget,
      PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Ghost (NNNNRY)', layout: PPOButtonLayout.iconRight, style: PPOButtonStyle.ghost, onTapped: () async {}, isActive: false, isDisabled: false, isFocused: false),
      10.0.asVerticalWidget,
      PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Ghost (NNNNLY)', layout: PPOButtonLayout.iconLeft, style: PPOButtonStyle.ghost, onTapped: () async {}, isActive: false, isDisabled: false, isFocused: false),
      10.0.asVerticalWidget,
      Align(alignment: Alignment.centerLeft, child: PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Ghost (NNNNOY)', layout: PPOButtonLayout.iconOnly, style: PPOButtonStyle.ghost, onTapped: () async {}, isActive: false, isDisabled: false, isFocused: false)),
      10.0.asVerticalWidget,
    ],
    ...<Widget>[
      const ListTile(title: Text('Ghost'), subtitle: Text('Tapped / hovered button styles')),
      PPOButton(brand: brand, label: 'Follow', tooltip: 'Ghost (YNNNNY)', layout: PPOButtonLayout.textOnly, style: PPOButtonStyle.ghost, onTapped: () async {}, isActive: false, isDisabled: false, isFocused: false, forceTappedState: true),
      10.0.asVerticalWidget,
      PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Ghost (YNNNRY)', layout: PPOButtonLayout.iconRight, style: PPOButtonStyle.ghost, onTapped: () async {}, isActive: false, isDisabled: false, isFocused: false, forceTappedState: true),
      10.0.asVerticalWidget,
      PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Ghost (YNNNLY)', layout: PPOButtonLayout.iconLeft, style: PPOButtonStyle.ghost, onTapped: () async {}, isActive: false, isDisabled: false, isFocused: false, forceTappedState: true),
      10.0.asVerticalWidget,
      Align(alignment: Alignment.centerLeft, child: PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Ghost (YNNNOY)', layout: PPOButtonLayout.iconOnly, style: PPOButtonStyle.ghost, onTapped: () async {}, isActive: false, isDisabled: false, isFocused: false, forceTappedState: true)),
      10.0.asVerticalWidget,
    ],
    ...<Widget>[
      const ListTile(title: Text('Ghost'), subtitle: Text('Active button styles')),
      PPOButton(brand: brand, label: 'Follow', tooltip: 'Ghost (NYNNNY)', layout: PPOButtonLayout.textOnly, style: PPOButtonStyle.ghost, onTapped: () async {}, isActive: true, isDisabled: false, isFocused: false),
      10.0.asVerticalWidget,
      PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Ghost (NYNNRY)', layout: PPOButtonLayout.iconRight, style: PPOButtonStyle.ghost, onTapped: () async {}, isActive: true, isDisabled: false, isFocused: false),
      10.0.asVerticalWidget,
      PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Ghost (NYNNLY)', layout: PPOButtonLayout.iconLeft, style: PPOButtonStyle.ghost, onTapped: () async {}, isActive: true, isDisabled: false, isFocused: false),
      10.0.asVerticalWidget,
      Align(alignment: Alignment.centerLeft, child: PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Ghost (NYNNOY)', layout: PPOButtonLayout.iconOnly, style: PPOButtonStyle.ghost, onTapped: () async {}, isActive: true, isDisabled: false, isFocused: false)),
      10.0.asVerticalWidget,
    ],
    ...<Widget>[
      const ListTile(title: Text('Ghost'), subtitle: Text('Focused button styles')),
      PPOButton(brand: brand, label: 'Follow', tooltip: 'Ghost (NNYNNY)', layout: PPOButtonLayout.textOnly, style: PPOButtonStyle.ghost, onTapped: () async {}, isActive: true, isDisabled: false, isFocused: true),
      10.0.asVerticalWidget,
      PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Ghost (NNYNRY)', layout: PPOButtonLayout.iconRight, style: PPOButtonStyle.ghost, onTapped: () async {}, isActive: true, isDisabled: false, isFocused: true),
      10.0.asVerticalWidget,
      PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Ghost (NNYNLY)', layout: PPOButtonLayout.iconLeft, style: PPOButtonStyle.ghost, onTapped: () async {}, isActive: true, isDisabled: false, isFocused: true),
      10.0.asVerticalWidget,
      Align(alignment: Alignment.centerLeft, child: PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Ghost (NNYNOY)', layout: PPOButtonLayout.iconOnly, style: PPOButtonStyle.ghost, onTapped: () async {}, isActive: true, isDisabled: false, isFocused: true)),
      10.0.asVerticalWidget,
    ],
    ...<Widget>[
      const ListTile(title: Text('Ghost'), subtitle: Text('Disabled button styles')),
      PPOButton(brand: brand, label: 'Follow', tooltip: 'Ghost (NNNYNY)', layout: PPOButtonLayout.textOnly, style: PPOButtonStyle.ghost, onTapped: () async {}, isActive: true, isDisabled: true, isFocused: false),
      10.0.asVerticalWidget,
      PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Ghost (NNNYRY)', layout: PPOButtonLayout.iconRight, style: PPOButtonStyle.ghost, onTapped: () async {}, isActive: true, isDisabled: true, isFocused: false),
      10.0.asVerticalWidget,
      PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Ghost (NNNYLY)', layout: PPOButtonLayout.iconLeft, style: PPOButtonStyle.ghost, onTapped: () async {}, isActive: true, isDisabled: true, isFocused: false),
      10.0.asVerticalWidget,
      Align(alignment: Alignment.centerLeft, child: PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Ghost (NNNYOY)', layout: PPOButtonLayout.iconOnly, style: PPOButtonStyle.ghost, onTapped: () async {}, isActive: true, isDisabled: true, isFocused: false)),
      10.0.asVerticalWidget,
    ],
  ];
}

List<Widget> _getTertiaryButtons(DesignSystemBrand brand) {
  return <Widget>[
    ...<Widget>[
      const ListTile(title: Text('Tertiary'), subtitle: Text('Inactive button styles')),
      PPOButton(brand: brand, label: 'Follow', tooltip: 'Tertiary (NNNNNY)', layout: PPOButtonLayout.textOnly, style: PPOButtonStyle.tertiary, onTapped: () async {}, isActive: false, isDisabled: false, isFocused: false),
      10.0.asVerticalWidget,
      PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Tertiary (NNNNRY)', layout: PPOButtonLayout.iconRight, style: PPOButtonStyle.tertiary, onTapped: () async {}, isActive: false, isDisabled: false, isFocused: false),
      10.0.asVerticalWidget,
      PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Tertiary (NNNNLY)', layout: PPOButtonLayout.iconLeft, style: PPOButtonStyle.tertiary, onTapped: () async {}, isActive: false, isDisabled: false, isFocused: false),
      10.0.asVerticalWidget,
      Align(alignment: Alignment.centerLeft, child: PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Tertiary (NNNNOY)', layout: PPOButtonLayout.iconOnly, style: PPOButtonStyle.tertiary, onTapped: () async {}, isActive: false, isDisabled: false, isFocused: false)),
      10.0.asVerticalWidget,
    ],
    ...<Widget>[
      const ListTile(title: Text('Tertiary'), subtitle: Text('Tapped / hovered button styles')),
      PPOButton(brand: brand, label: 'Follow', tooltip: 'Tertiary (YNNNNY)', layout: PPOButtonLayout.textOnly, style: PPOButtonStyle.tertiary, onTapped: () async {}, isActive: false, isDisabled: false, isFocused: false, forceTappedState: true),
      10.0.asVerticalWidget,
      PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Tertiary (YNNNRY)', layout: PPOButtonLayout.iconRight, style: PPOButtonStyle.tertiary, onTapped: () async {}, isActive: false, isDisabled: false, isFocused: false, forceTappedState: true),
      10.0.asVerticalWidget,
      PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Tertiary (YNNNLY)', layout: PPOButtonLayout.iconLeft, style: PPOButtonStyle.tertiary, onTapped: () async {}, isActive: false, isDisabled: false, isFocused: false, forceTappedState: true),
      10.0.asVerticalWidget,
      Align(alignment: Alignment.centerLeft, child: PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Tertiary (YNNNOY)', layout: PPOButtonLayout.iconOnly, style: PPOButtonStyle.tertiary, onTapped: () async {}, isActive: false, isDisabled: false, isFocused: false, forceTappedState: true)),
      10.0.asVerticalWidget,
    ],
    ...<Widget>[
      const ListTile(title: Text('Tertiary'), subtitle: Text('Active button styles')),
      PPOButton(brand: brand, label: 'Follow', tooltip: 'Tertiary (NYNNNY)', layout: PPOButtonLayout.textOnly, style: PPOButtonStyle.tertiary, onTapped: () async {}, isActive: true, isDisabled: false, isFocused: false),
      10.0.asVerticalWidget,
      PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Tertiary (NYNNRY)', layout: PPOButtonLayout.iconRight, style: PPOButtonStyle.tertiary, onTapped: () async {}, isActive: true, isDisabled: false, isFocused: false),
      10.0.asVerticalWidget,
      PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Tertiary (NYNNLY)', layout: PPOButtonLayout.iconLeft, style: PPOButtonStyle.tertiary, onTapped: () async {}, isActive: true, isDisabled: false, isFocused: false),
      10.0.asVerticalWidget,
      Align(alignment: Alignment.centerLeft, child: PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Tertiary (NYNNOY)', layout: PPOButtonLayout.iconOnly, style: PPOButtonStyle.tertiary, onTapped: () async {}, isActive: true, isDisabled: false, isFocused: false)),
      10.0.asVerticalWidget,
    ],
    ...<Widget>[
      const ListTile(title: Text('Tertiary'), subtitle: Text('Focused button styles')),
      PPOButton(brand: brand, label: 'Follow', tooltip: 'Tertiary (NNYNNY)', layout: PPOButtonLayout.textOnly, style: PPOButtonStyle.tertiary, onTapped: () async {}, isActive: true, isDisabled: false, isFocused: true),
      10.0.asVerticalWidget,
      PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Tertiary (NNYNRY)', layout: PPOButtonLayout.iconRight, style: PPOButtonStyle.tertiary, onTapped: () async {}, isActive: true, isDisabled: false, isFocused: true),
      10.0.asVerticalWidget,
      PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Tertiary (NNYNLY)', layout: PPOButtonLayout.iconLeft, style: PPOButtonStyle.tertiary, onTapped: () async {}, isActive: true, isDisabled: false, isFocused: true),
      10.0.asVerticalWidget,
      Align(alignment: Alignment.centerLeft, child: PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Tertiary (NNYNOY)', layout: PPOButtonLayout.iconOnly, style: PPOButtonStyle.tertiary, onTapped: () async {}, isActive: true, isDisabled: false, isFocused: true)),
      10.0.asVerticalWidget,
    ],
    ...<Widget>[
      const ListTile(title: Text('Tertiary'), subtitle: Text('Disabled button styles')),
      PPOButton(brand: brand, label: 'Follow', tooltip: 'Tertiary (NNNYNY)', layout: PPOButtonLayout.textOnly, style: PPOButtonStyle.tertiary, onTapped: () async {}, isActive: true, isDisabled: true, isFocused: false),
      10.0.asVerticalWidget,
      PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Tertiary (NNNYRY)', layout: PPOButtonLayout.iconRight, style: PPOButtonStyle.tertiary, onTapped: () async {}, isActive: true, isDisabled: true, isFocused: false),
      10.0.asVerticalWidget,
      PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Tertiary (NNNYLY)', layout: PPOButtonLayout.iconLeft, style: PPOButtonStyle.tertiary, onTapped: () async {}, isActive: true, isDisabled: true, isFocused: false),
      10.0.asVerticalWidget,
      Align(alignment: Alignment.centerLeft, child: PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Tertiary (NNNYOY)', layout: PPOButtonLayout.iconOnly, style: PPOButtonStyle.tertiary, onTapped: () async {}, isActive: true, isDisabled: true, isFocused: false)),
      10.0.asVerticalWidget,
    ],
  ];
}

List<Widget> _getSecondaryButtons(DesignSystemBrand brand) {
  return <Widget>[
    ...<Widget>[
      const ListTile(title: Text('Secondary'), subtitle: Text('Inactive button styles')),
      PPOButton(brand: brand, label: 'Follow', tooltip: 'Secondary (NNNNNY)', layout: PPOButtonLayout.textOnly, style: PPOButtonStyle.secondary, onTapped: () async {}, isActive: false, isDisabled: false, isFocused: false),
      10.0.asVerticalWidget,
      PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Secondary (NNNNRY)', layout: PPOButtonLayout.iconRight, style: PPOButtonStyle.secondary, onTapped: () async {}, isActive: false, isDisabled: false, isFocused: false),
      10.0.asVerticalWidget,
      PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Secondary (NNNNLY)', layout: PPOButtonLayout.iconLeft, style: PPOButtonStyle.secondary, onTapped: () async {}, isActive: false, isDisabled: false, isFocused: false),
      10.0.asVerticalWidget,
      Align(alignment: Alignment.centerLeft, child: PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Secondary (NNNNOY)', layout: PPOButtonLayout.iconOnly, style: PPOButtonStyle.secondary, onTapped: () async {}, isActive: false, isDisabled: false, isFocused: false)),
      10.0.asVerticalWidget,
    ],
    ...<Widget>[
      const ListTile(title: Text('Secondary'), subtitle: Text('Tapped / hovered button styles')),
      PPOButton(brand: brand, label: 'Follow', tooltip: 'Secondary (YNNNNY)', layout: PPOButtonLayout.textOnly, style: PPOButtonStyle.secondary, onTapped: () async {}, isActive: false, isDisabled: false, isFocused: false, forceTappedState: true),
      10.0.asVerticalWidget,
      PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Secondary (YNNNRY)', layout: PPOButtonLayout.iconRight, style: PPOButtonStyle.secondary, onTapped: () async {}, isActive: false, isDisabled: false, isFocused: false, forceTappedState: true),
      10.0.asVerticalWidget,
      PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Secondary (YNNNLY)', layout: PPOButtonLayout.iconLeft, style: PPOButtonStyle.secondary, onTapped: () async {}, isActive: false, isDisabled: false, isFocused: false, forceTappedState: true),
      10.0.asVerticalWidget,
      Align(alignment: Alignment.centerLeft, child: PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Secondary (YNNNOY)', layout: PPOButtonLayout.iconOnly, style: PPOButtonStyle.secondary, onTapped: () async {}, isActive: false, isDisabled: false, isFocused: false, forceTappedState: true)),
      10.0.asVerticalWidget,
    ],
    ...<Widget>[
      const ListTile(title: Text('Secondary'), subtitle: Text('Active button styles')),
      PPOButton(brand: brand, label: 'Follow', tooltip: 'Secondary (NYNNNY)', layout: PPOButtonLayout.textOnly, style: PPOButtonStyle.secondary, onTapped: () async {}, isActive: true, isDisabled: false, isFocused: false),
      10.0.asVerticalWidget,
      PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Secondary (NYNNRY)', layout: PPOButtonLayout.iconRight, style: PPOButtonStyle.secondary, onTapped: () async {}, isActive: true, isDisabled: false, isFocused: false),
      10.0.asVerticalWidget,
      PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Secondary (NYNNLY)', layout: PPOButtonLayout.iconLeft, style: PPOButtonStyle.secondary, onTapped: () async {}, isActive: true, isDisabled: false, isFocused: false),
      10.0.asVerticalWidget,
      Align(alignment: Alignment.centerLeft, child: PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Secondary (NYNNOY)', layout: PPOButtonLayout.iconOnly, style: PPOButtonStyle.secondary, onTapped: () async {}, isActive: true, isDisabled: false, isFocused: false)),
      10.0.asVerticalWidget,
    ],
    ...<Widget>[
      const ListTile(title: Text('Secondary'), subtitle: Text('Focused button styles')),
      PPOButton(brand: brand, label: 'Follow', tooltip: 'Secondary (NNYNNY)', layout: PPOButtonLayout.textOnly, style: PPOButtonStyle.secondary, onTapped: () async {}, isActive: true, isDisabled: false, isFocused: true),
      10.0.asVerticalWidget,
      PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Secondary (NNYNRY)', layout: PPOButtonLayout.iconRight, style: PPOButtonStyle.secondary, onTapped: () async {}, isActive: true, isDisabled: false, isFocused: true),
      10.0.asVerticalWidget,
      PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Secondary (NNYNLY)', layout: PPOButtonLayout.iconLeft, style: PPOButtonStyle.secondary, onTapped: () async {}, isActive: true, isDisabled: false, isFocused: true),
      10.0.asVerticalWidget,
      Align(alignment: Alignment.centerLeft, child: PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Secondary (NNYNOY)', layout: PPOButtonLayout.iconOnly, style: PPOButtonStyle.secondary, onTapped: () async {}, isActive: true, isDisabled: false, isFocused: true)),
      10.0.asVerticalWidget,
    ],
    ...<Widget>[
      const ListTile(title: Text('Secondary'), subtitle: Text('Disabled button styles')),
      PPOButton(brand: brand, label: 'Follow', tooltip: 'Secondary (NNNYNY)', layout: PPOButtonLayout.textOnly, style: PPOButtonStyle.secondary, onTapped: () async {}, isActive: true, isDisabled: true, isFocused: false),
      10.0.asVerticalWidget,
      PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Secondary (NNNYRY)', layout: PPOButtonLayout.iconRight, style: PPOButtonStyle.secondary, onTapped: () async {}, isActive: true, isDisabled: true, isFocused: false),
      10.0.asVerticalWidget,
      PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Secondary (NNNYLY)', layout: PPOButtonLayout.iconLeft, style: PPOButtonStyle.secondary, onTapped: () async {}, isActive: true, isDisabled: true, isFocused: false),
      10.0.asVerticalWidget,
      Align(alignment: Alignment.centerLeft, child: PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Secondary (NNNYOY)', layout: PPOButtonLayout.iconOnly, style: PPOButtonStyle.secondary, onTapped: () async {}, isActive: true, isDisabled: true, isFocused: false)),
      10.0.asVerticalWidget,
    ],
  ];
}

List<Widget> _getPrimaryButtons(DesignSystemBrand brand) {
  return <Widget>[
    ...<Widget>[
      const ListTile(title: Text('Primary'), subtitle: Text('Inactive button styles')),
      PPOButton(brand: brand, label: 'Follow', tooltip: 'Primary (NNNNNY)', layout: PPOButtonLayout.textOnly, style: PPOButtonStyle.primary, onTapped: () async {}, isActive: false, isDisabled: false, isFocused: false),
      10.0.asVerticalWidget,
      PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Primary (NNNNRY)', layout: PPOButtonLayout.iconRight, style: PPOButtonStyle.primary, onTapped: () async {}, isActive: false, isDisabled: false, isFocused: false),
      10.0.asVerticalWidget,
      PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Primary (NNNNLY)', layout: PPOButtonLayout.iconLeft, style: PPOButtonStyle.primary, onTapped: () async {}, isActive: false, isDisabled: false, isFocused: false),
      10.0.asVerticalWidget,
      Align(alignment: Alignment.centerLeft, child: PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Primary (NNNNOY)', layout: PPOButtonLayout.iconOnly, style: PPOButtonStyle.primary, onTapped: () async {}, isActive: false, isDisabled: false, isFocused: false)),
      10.0.asVerticalWidget,
    ],
    ...<Widget>[
      const ListTile(title: Text('Primary'), subtitle: Text('Tapped / hovered button styles')),
      PPOButton(brand: brand, label: 'Follow', tooltip: 'Primary (YNNNNY)', layout: PPOButtonLayout.textOnly, style: PPOButtonStyle.primary, onTapped: () async {}, isActive: false, isDisabled: false, isFocused: false, forceTappedState: true),
      10.0.asVerticalWidget,
      PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Primary (YNNNRY)', layout: PPOButtonLayout.iconRight, style: PPOButtonStyle.primary, onTapped: () async {}, isActive: false, isDisabled: false, isFocused: false, forceTappedState: true),
      10.0.asVerticalWidget,
      PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Primary (YNNNLY)', layout: PPOButtonLayout.iconLeft, style: PPOButtonStyle.primary, onTapped: () async {}, isActive: false, isDisabled: false, isFocused: false, forceTappedState: true),
      10.0.asVerticalWidget,
      Align(alignment: Alignment.centerLeft, child: PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Primary (YNNNOY)', layout: PPOButtonLayout.iconOnly, style: PPOButtonStyle.primary, onTapped: () async {}, isActive: false, isDisabled: false, isFocused: false, forceTappedState: true)),
      10.0.asVerticalWidget,
    ],
    ...<Widget>[
      const ListTile(title: Text('Primary'), subtitle: Text('Active button styles')),
      PPOButton(brand: brand, label: 'Follow', tooltip: 'Primary (NYNNNY)', layout: PPOButtonLayout.textOnly, style: PPOButtonStyle.primary, onTapped: () async {}, isActive: true, isDisabled: false, isFocused: false),
      10.0.asVerticalWidget,
      PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Primary (NYNNRY)', layout: PPOButtonLayout.iconRight, style: PPOButtonStyle.primary, onTapped: () async {}, isActive: true, isDisabled: false, isFocused: false),
      10.0.asVerticalWidget,
      PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Primary (NYNNLY)', layout: PPOButtonLayout.iconLeft, style: PPOButtonStyle.primary, onTapped: () async {}, isActive: true, isDisabled: false, isFocused: false),
      10.0.asVerticalWidget,
      Align(alignment: Alignment.centerLeft, child: PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Primary (NYNNOY)', layout: PPOButtonLayout.iconOnly, style: PPOButtonStyle.primary, onTapped: () async {}, isActive: true, isDisabled: false, isFocused: false)),
      10.0.asVerticalWidget,
    ],
    ...<Widget>[
      const ListTile(title: Text('Primary'), subtitle: Text('Focused button styles')),
      PPOButton(brand: brand, label: 'Follow', tooltip: 'Primary (NNYNNY)', layout: PPOButtonLayout.textOnly, style: PPOButtonStyle.primary, onTapped: () async {}, isActive: true, isDisabled: false, isFocused: true),
      10.0.asVerticalWidget,
      PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Primary (NNYNRY)', layout: PPOButtonLayout.iconRight, style: PPOButtonStyle.primary, onTapped: () async {}, isActive: true, isDisabled: false, isFocused: true),
      10.0.asVerticalWidget,
      PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Primary (NNYNLY)', layout: PPOButtonLayout.iconLeft, style: PPOButtonStyle.primary, onTapped: () async {}, isActive: true, isDisabled: false, isFocused: true),
      10.0.asVerticalWidget,
      Align(alignment: Alignment.centerLeft, child: PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Primary (NNYNOY)', layout: PPOButtonLayout.iconOnly, style: PPOButtonStyle.primary, onTapped: () async {}, isActive: true, isDisabled: false, isFocused: true)),
      10.0.asVerticalWidget,
    ],
    ...<Widget>[
      const ListTile(title: Text('Primary'), subtitle: Text('Disabled button styles')),
      PPOButton(brand: brand, label: 'Follow', tooltip: 'Primary (NNNYNY)', layout: PPOButtonLayout.textOnly, style: PPOButtonStyle.primary, onTapped: () async {}, isActive: true, isDisabled: true, isFocused: false),
      10.0.asVerticalWidget,
      PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Primary (NNNYRY)', layout: PPOButtonLayout.iconRight, style: PPOButtonStyle.primary, onTapped: () async {}, isActive: true, isDisabled: true, isFocused: false),
      10.0.asVerticalWidget,
      PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Primary (NNNYLY)', layout: PPOButtonLayout.iconLeft, style: PPOButtonStyle.primary, onTapped: () async {}, isActive: true, isDisabled: true, isFocused: false),
      10.0.asVerticalWidget,
      Align(alignment: Alignment.centerLeft, child: PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Primary (NNNYOY)', layout: PPOButtonLayout.iconOnly, style: PPOButtonStyle.primary, onTapped: () async {}, isActive: true, isDisabled: true, isFocused: false)),
      10.0.asVerticalWidget,
    ],
  ];
}
