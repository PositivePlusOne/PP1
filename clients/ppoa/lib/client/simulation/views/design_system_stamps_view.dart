// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:ppoa/business/services/service_mixin.dart';
import 'package:ppoa/business/state/design_system/interfaces/brand_design_system.dart';
import 'package:ppoa/client/components/atoms/stamp.dart';

class DesignSystemButtonsView extends HookConsumerWidget with ServiceMixin {
  const DesignSystemButtonsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final BrandDesignSystem designSystem = ref.watch(stateProvider.select((value) => value.designSystem.brand));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Buttons'),
      ),
      body: Align(
        alignment: Alignment.center,
        child: Stamp(
          textString: "Test",
          textStyle: const TextStyle(color: Colors.blue, fontSize: 20, letterSpacing: 0),
          radius: 77,
          textDirection: TextDirection.ltr,
          drawCircles: true,
          startingAngle: 0.0,
          repeatText: 2,
          imageSize: 80,
          svgPath: "assets/images/test.png",
        ),
      ),
    );
  }
}
