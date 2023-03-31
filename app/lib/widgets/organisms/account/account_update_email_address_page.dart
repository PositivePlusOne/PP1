import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/widgets/molecules/layouts/positive_basic_sliver_list.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../dtos/system/design_typography_model.dart';
import '../../../providers/system/design_controller.dart';
import '../../atoms/buttons/positive_back_button.dart';

class AccountUpdateEmailAddressPage extends ConsumerWidget {
  const AccountUpdateEmailAddressPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));

    return PositiveScaffold(
      headingWidgets: <Widget>[
        PositiveBasicSliverList(
          children: <Widget>[
            const PositiveBackButton(),
            const SizedBox(height: kPaddingMedium),
            Text(
              'Change Email Address',
              style: typography.styleSuperSize.copyWith(color: colors.black),
            ),
          ],
        ),
      ],
    );
  }
}
