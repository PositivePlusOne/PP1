// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:ppoa/business/services/service_mixin.dart';
import 'package:ppoa/business/state/design_system/models/design_system_brand.dart';
import 'package:ppoa/client/components/atoms/reactive/ppo_pin_field.dart';

class PPOPinFieldTestPage extends StatefulHookConsumerWidget {
  const PPOPinFieldTestPage({
    this.initialPage = 0,
    super.key,
  });

  final int initialPage;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PPOPinFieldTestPageState();
}

class _PPOPinFieldTestPageState extends ConsumerState<PPOPinFieldTestPage> with ServiceMixin, SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final DesignSystemBrand brand = ref.watch(stateProvider.select((value) => value.designSystem.brand));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: brand.colors.purple,
        title: const Text('Page Indicators'),
      ),
      body: ListView(
        controller: ScrollController(),
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        children: [
          const SizedBox(
            height: 10.0,
          ),
          Align(
            alignment: Alignment.center,
            child: PPOPinField(
              onSubmittion: (_) {},
            ),
          ),
        ],
      ),
    );
  }
}
