// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:ppoa/business/services/service_mixin.dart';
import 'package:ppoa/business/state/design_system/models/design_system_brand.dart';
import 'package:ppoa/client/components/atoms/stamps/stamp.dart';
import 'package:ppoa/resources/resources.dart';

class DesignSystemStampView extends HookConsumerWidget with ServiceMixin {
  const DesignSystemStampView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignSystemBrand designSystem = ref.watch(stateProvider.select((value) => value.designSystem.brand));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Buttons'),
      ),
      body: Align(
        alignment: Alignment.center,
        child: Stamp.onePlus(),
      ),
    );
  }
}
