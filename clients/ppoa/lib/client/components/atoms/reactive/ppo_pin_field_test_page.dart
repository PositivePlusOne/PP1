// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ppoa/business/extensions/brand_extensions.dart';

// Project imports:
import 'package:ppoa/business/services/service_mixin.dart';
import 'package:ppoa/business/state/design_system/models/design_system_brand.dart';
import 'package:ppoa/client/components/atoms/reactive/ppo_pin_field.dart';
import 'package:ppoa/client/components/templates/scaffolds/ppo_scaffold.dart';

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

    return PPOScaffold(
      appBar: AppBar(
        backgroundColor: brand.colors.purple,
        title: const Text('Page Indicators'),
      ),
      children: <Widget>[
        SliverFillRemaining(
          fillOverscroll: false,
          hasScrollBody: false,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              PPOPinField(
                branding: brand,
                onChanged: (_) {},
              ),
              20.0.asVerticalWidget,
              PPOPinField(
                branding: brand,
                isError: true,
                onChanged: (_) {},
              ),
              20.0.asVerticalWidget,
              PPOPinField(
                branding: brand,
                itemCount: 10,
                onChanged: (_) {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}
