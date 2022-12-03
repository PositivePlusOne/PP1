import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ppoa/business/services/service_mixin.dart';
import 'package:ppoa/business/state/design_system/models/design_system_brand.dart';
import 'package:ppoa/client/components/atoms/buttons/enumerations/ppo_button_layout.dart';
import 'package:ppoa/client/components/atoms/buttons/enumerations/ppo_button_style.dart';
import 'package:ppoa/client/components/atoms/buttons/ppo_button.dart';
import 'package:ppoa/client/components/templates/scaffolds/ppo_scaffold.dart';
import 'package:ppoa/resources/resources.dart';
import 'package:unicons/unicons.dart';

import '../components/molecules/buttons/ppo_close_button.dart';
import '../components/molecules/navigation/ppo_app_bar.dart';
import '../constants/ppo_design_constants.dart';
import '../constants/ppo_design_keys.dart';

class TermsAndConditionsDialog extends HookConsumerWidget with ServiceMixin {
  const TermsAndConditionsDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignSystemBrand branding = ref.watch(stateProvider.select((value) => value.designSystem.brand));
    final MediaQueryData mediaQueryData = MediaQuery.of(context);

    return PPOScaffold(
      backgroundColor: Colors.black,
      children: <Widget>[
        SliverPadding(
          padding: EdgeInsets.only(
            top: kPaddingMedium + mediaQueryData.padding.top,
            left: kPaddingMedium,
            right: kPaddingMedium,
            bottom: kPaddingMedium + mediaQueryData.padding.bottom,
          ),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              <Widget>[
                PPOAppBar(
                  foregroundColor: branding.colors.white,
                  trailing: const PPOCloseButton(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
