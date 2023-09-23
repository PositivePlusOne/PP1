// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/extensions/string_extensions.dart';
import 'package:app/helpers/brand_helpers.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/widgets/atoms/buttons/positive_back_button.dart';
import 'package:app/widgets/atoms/indicators/positive_page_indicator.dart';
import 'package:app/widgets/molecules/input/positive_rich_text.dart';
import 'package:app/widgets/molecules/layouts/positive_basic_sliver_list.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';

@RoutePage()
class LoginAccountRecoveryPage extends HookConsumerWidget {
  const LoginAccountRecoveryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));

    return PositiveScaffold(
      decorations: buildType1ScaffoldDecorations(colors),
      headingWidgets: <Widget>[
        PositiveBasicSliverList(
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const PositiveBackButton(),
                const SizedBox(width: kPaddingSmall),
                PositivePageIndicator(
                  color: colors.black,
                  pagesNum: 2,
                  currentPage: 0,
                ),
              ],
            ),
            const SizedBox(height: kPaddingMedium),
            Align(
              alignment: Alignment.centerLeft,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'Account Recovery',
                  style: typography.styleHero.copyWith(
                    color: colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(height: kPaddingMedium),
            PositiveRichText(
              body: 'If you don\'t have access to your account, email us at {} and we\'ll do our best to help.',
              onActionTapped: (_) => 'mailto:support@positiveplusone.com'.attemptToLaunchURL(),
              actionColor: colors.linkBlue,
              actions: const <String>['support@positiveplusone.com'],
            ),
            const SizedBox(height: kPaddingMedium),
          ],
        ),
      ],
    );
  }
}
