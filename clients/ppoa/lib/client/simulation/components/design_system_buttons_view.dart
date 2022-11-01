// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:ppoa/business/services/service_mixin.dart';
import 'package:ppoa/business/state/design_system/interfaces/brand_design_system.dart';

class DesignSystemButtonsView extends HookConsumerWidget with ServiceMixin {
  const DesignSystemButtonsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buttons'),
      ),
    );
  }
}
