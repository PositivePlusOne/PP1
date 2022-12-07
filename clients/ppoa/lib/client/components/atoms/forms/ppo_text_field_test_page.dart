// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ppoa/business/extensions/brand_extensions.dart';

// Project imports:
import 'package:ppoa/business/services/service_mixin.dart';
import 'package:ppoa/client/components/atoms/forms/ppo_text_field.dart';
import 'package:ppoa/client/components/templates/scaffolds/ppo_scaffold.dart';
import 'package:ppoa/client/constants/ppo_design_constants.dart';
import '../../../../business/state/design_system/models/design_system_brand.dart';

class PPOTextFieldTestPage extends StatefulHookConsumerWidget {
  const PPOTextFieldTestPage({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PPOTextFieldTestPage();
}

class _PPOTextFieldTestPage extends ConsumerState<PPOTextFieldTestPage> with ServiceMixin {
  @override
  Widget build(BuildContext context) {
    final DesignSystemBrand brand = ref.watch(stateProvider.select((value) => value.designSystem.brand));
    final MediaQueryData mediaQueryData = MediaQuery.of(context);

    return PPOScaffold(
      appBar: AppBar(
        backgroundColor: brand.colors.purple,
        title: const Text('Text Fields'),
      ),
      children: <Widget>[
        SliverPadding(
          padding: EdgeInsets.only(
            left: kPaddingMedium,
            right: kPaddingMedium,
            top: kPaddingMedium,
            bottom: kPaddingMedium + mediaQueryData.padding.bottom,
          ),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              <Widget>[
                ..._getTextFields(brand),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

List<Widget> _getTextFields(DesignSystemBrand brand) {
  return <Widget>[
    const ListTile(
      title: Text('Text Fields'),
      subtitle: Text('Different types of text fields with leading and trailing components.'),
    ),
    10.0.asVerticalWidget,
    PPOTextField(branding: brand, label: 'Basic text field'),
    10.0.asVerticalWidget,
    PPOTextField(
      branding: brand,
      label: 'Initial value text field',
      initialValue: 'Default value',
    ),
  ];
}
