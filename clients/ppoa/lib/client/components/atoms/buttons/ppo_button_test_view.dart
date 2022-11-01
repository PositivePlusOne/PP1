// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ppoa/business/extensions/brand_extensions.dart';

// Project imports:
import 'package:ppoa/business/services/service_mixin.dart';
import 'package:ppoa/client/components/atoms/buttons/enumerations/ppo_button_layout.dart';
import 'package:ppoa/client/components/atoms/buttons/enumerations/ppo_button_style.dart';
import 'package:ppoa/client/components/atoms/buttons/ppo_button.dart';

import '../../../../business/state/design_system/models/design_system_brand.dart';

class PPOButtonTestView extends HookConsumerWidget with ServiceMixin {
  const PPOButtonTestView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignSystemBrand brand = ref.watch(stateProvider.select((value) => value.designSystem.brand));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: brand.secondaryColor.toColorFromHex(),
        title: const Text('Buttons'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        children: <Widget>[
          ...getPrimaryButtons(brand),
        ],
      ),
    );
  }
}

List<Widget> getPrimaryButtons(DesignSystemBrand brand) {
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
