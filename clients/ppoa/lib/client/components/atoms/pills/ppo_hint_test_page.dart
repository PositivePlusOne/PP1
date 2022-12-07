// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:ppoa/business/extensions/brand_extensions.dart';
import 'package:ppoa/business/services/service_mixin.dart';
import 'package:ppoa/client/components/atoms/pills/ppo_hint.dart';
import 'package:ppoa/client/components/templates/scaffolds/ppo_scaffold.dart';
import '../../../../business/state/design_system/models/design_system_brand.dart';

class PPOHintTestPage extends StatefulHookConsumerWidget {
  const PPOHintTestPage({
    this.initialPage = 0,
    super.key,
  });

  final int initialPage;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PPHintnTestPageState();
}

class _PPHintnTestPageState extends ConsumerState<PPOHintTestPage> with ServiceMixin {
  @override
  Widget build(BuildContext context) {
    final DesignSystemBrand brand = ref.watch(stateProvider.select((value) => value.designSystem.brand));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: brand.colors.purple,
        title: const Text('Hints'),
      ),
      body: PPOScaffold(
        trailingWidgets: <Widget>[
          ..._getHints(brand),
        ],
        children: const <Widget>[],
      ),
    );
  }
}

List<Widget> _getHints(DesignSystemBrand brand) {
  return <Widget>[
    const ListTile(
      title: Text('Hint tiles'),
      subtitle: Text('Used for adding information to pages, such as errors.'),
    ),
    PPOHint(brand: brand, label: 'An error occured', icon: Icons.error, iconColor: Colors.red),
    10.0.asVerticalWidget,
    PPOHint(brand: brand, label: 'Something with information', icon: Icons.info, iconColor: Colors.yellow),
    10.0.asVerticalWidget,
  ];
}
