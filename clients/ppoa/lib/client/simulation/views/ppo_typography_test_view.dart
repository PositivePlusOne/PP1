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

    // TODO(ryan): Add color converter to brand to avoid toColorFromHex

    return Scaffold(
      appBar: AppBar(
        backgroundColor: brand.colors.secondaryColor.toColorFromHex(),
        title: const Text('Typography'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(10.0),
          children: <Widget>[
            Text('Hero', style: brand.typography.styleHero),
          ],
        ),
      ),
    );
  }
}
