// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ppoa/client/components/atoms/decorations/ppo_decoration.dart';

// Project imports:
import 'package:ppoa/client/components/templates/scaffolds/ppo_scaffold.dart';
import 'package:ppoa/resources/resources.dart';
import '../../../../business/services/service_mixin.dart';
import '../../../../business/state/design_system/models/design_system_brand.dart';

class PPOScaffoldTestView extends StatefulHookConsumerWidget {
  const PPOScaffoldTestView({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PPOScaffoldTestViewState();
}

class _PPOScaffoldTestViewState extends ConsumerState<PPOScaffoldTestView> with ServiceMixin {
  @override
  Widget build(BuildContext context) {
    final DesignSystemBrand brand = ref.watch(stateProvider.select((value) => value.designSystem.brand));

    return PPOScaffold(
      appBar: AppBar(
        backgroundColor: brand.colors.secondaryColor,
        title: const Text('PPO Scaffold'),
      ),
      decorations: <PPODecoration>[
        PPODecoration(
          asset: SvgImages.decorationGlobe,
          alignment: Alignment.bottomRight,
          color: brand.colors.focusColor,
          scale: 2.0,
        ),
        PPODecoration(
          asset: SvgImages.decorationStampStar,
          alignment: Alignment.bottomLeft,
          color: brand.colors.secondaryColor,
          scale: 2.0,
        ),
        PPODecoration(
          asset: SvgImages.decorationFace,
          alignment: Alignment.topCenter,
          color: brand.colors.primaryColor,
          rotationDegrees: 45.0,
        ),
      ],
      child: Container(),
    );
  }
}
