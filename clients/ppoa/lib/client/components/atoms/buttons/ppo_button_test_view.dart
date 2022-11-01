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
          const ListTile(title: Text('Primary'), subtitle: Text('Inactive button styles')),
          PPOButton(brand: brand, label: 'Follow', tooltip: 'Primary (NNNNNY)', layout: PPOButtonLayout.textOnly, style: PPOButtonStyle.primary, onTapped: () async {}, isActive: false, isDisabled: false, isFocused: false),
          10.0.asVerticalWidget,
          PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Primary (NNNNRY)', layout: PPOButtonLayout.iconRight, style: PPOButtonStyle.primary, onTapped: () async {}, isActive: false, isDisabled: false, isFocused: false),
          10.0.asVerticalWidget,
          PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Primary (NNNNLY)', layout: PPOButtonLayout.iconLeft, style: PPOButtonStyle.primary, onTapped: () async {}, isActive: false, isDisabled: false, isFocused: false),
          10.0.asVerticalWidget,
          Align(alignment: Alignment.centerLeft, child: PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Primary (NNNNOY)', layout: PPOButtonLayout.iconOnly, style: PPOButtonStyle.primary, onTapped: () async {}, isActive: false, isDisabled: false, isFocused: false)),
          10.0.asVerticalWidget,
          const ListTile(title: Text('Primary'), subtitle: Text('Tapped button styles')),
          PPOButton(brand: brand, label: 'Follow', tooltip: 'Primary (NNNNNY)', layout: PPOButtonLayout.textOnly, style: PPOButtonStyle.primary, onTapped: () async {}, isActive: false, isDisabled: false, isFocused: false, forceTappedState: true),
          10.0.asVerticalWidget,
          PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Primary (NNNNRY)', layout: PPOButtonLayout.iconRight, style: PPOButtonStyle.primary, onTapped: () async {}, isActive: false, isDisabled: false, isFocused: false, forceTappedState: true),
          10.0.asVerticalWidget,
          PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Primary (NNNNLY)', layout: PPOButtonLayout.iconLeft, style: PPOButtonStyle.primary, onTapped: () async {}, isActive: false, isDisabled: false, isFocused: false, forceTappedState: true),
          10.0.asVerticalWidget,
          PPOButton(brand: brand, label: 'Follow', icon: Icons.check, tooltip: 'Primary (NNNNOY)', layout: PPOButtonLayout.iconOnly, style: PPOButtonStyle.primary, onTapped: () async {}, isActive: false, isDisabled: false, isFocused: false, forceTappedState: true),
          10.0.asVerticalWidget,
        ],
      ),
    );
  }
}
