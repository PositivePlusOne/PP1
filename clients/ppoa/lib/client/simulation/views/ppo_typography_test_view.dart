// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:ppoa/business/extensions/brand_extensions.dart';
import 'package:ppoa/business/services/service_mixin.dart';
import '../../../business/state/design_system/models/design_system_brand.dart';

class PPOTypographyTestView extends HookConsumerWidget with ServiceMixin {
  const PPOTypographyTestView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignSystemBrand brand = ref.watch(stateProvider.select((value) => value.designSystem.brand));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: brand.colors.secondaryColor,
        title: const Text('Typography'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(10.0),
          children: <Widget>[
            Text('Body', style: brand.typography.styleBody),
            10.0.asVerticalWidget,
            Text('Bold', style: brand.typography.styleBold),
            10.0.asVerticalWidget,
            Text('Button Bold', style: brand.typography.styleButtonBold),
            10.0.asVerticalWidget,
            Text('Button Regular', style: brand.typography.styleButtonRegular),
            10.0.asVerticalWidget,
            Text('Hero', style: brand.typography.styleHero),
            10.0.asVerticalWidget,
            Text('Subtext', style: brand.typography.styleSubtext),
            10.0.asVerticalWidget,
            Text('Subtext Bold', style: brand.typography.styleSubtextBold),
            10.0.asVerticalWidget,
            Text('Title', style: brand.typography.styleTitle),
          ],
        ),
      ),
    );
  }
}
