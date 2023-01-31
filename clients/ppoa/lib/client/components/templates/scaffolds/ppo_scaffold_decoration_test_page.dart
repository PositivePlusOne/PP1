// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:ppoa/client/components/atoms/decorations/ppo_scaffold_decoration.dart';
import 'package:ppoa/client/components/templates/scaffolds/ppo_scaffold.dart';
import 'package:ppoa/resources/resources.dart';
import '../../../../business/services/service_mixin.dart';
import '../../../../business/state/design_system/models/design_system_brand.dart';

class PPOScaffoldDecorationTestPage extends StatefulHookConsumerWidget {
  const PPOScaffoldDecorationTestPage({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PPOScaffoldDecorationTestPageState();
}

class _PPOScaffoldDecorationTestPageState extends ConsumerState<PPOScaffoldDecorationTestPage> with ServiceMixin {
  @override
  Widget build(BuildContext context) {
    final DesignSystemBrand brand = ref.watch(stateProvider.select((value) => value.designSystem.brand));

    return PPOScaffold(
      appBar: AppBar(
        backgroundColor: brand.colors.purple,
        title: const Text('PPO Scaffold'),
      ),
      decorations: <PPOScaffoldDecoration>[
        PPOScaffoldDecoration(
          asset: SvgImages.decorationGlobe,
          alignment: Alignment.bottomRight,
          color: brand.colors.yellow,
          scale: 2.0,
          offset: const Offset(-0.25, -0.25),
        ),
        PPOScaffoldDecoration(
          asset: SvgImages.decorationStampStar,
          alignment: Alignment.bottomLeft,
          color: brand.colors.purple,
          scale: 2.0,
          offset: const Offset(0.25, -0.25),
        ),
        PPOScaffoldDecoration(
          asset: SvgImages.decorationFace,
          alignment: Alignment.topCenter,
          color: brand.colors.teal,
          rotationDegrees: 45.0,
        ),
      ],
      children: const <Widget>[],
    );
  }
}
