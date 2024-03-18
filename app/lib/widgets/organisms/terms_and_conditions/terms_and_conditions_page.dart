// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:markdown_widget/config/configs.dart';
import 'package:markdown_widget/widget/all.dart';

// Project imports:
import 'package:app/constants/templates.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/helpers/brand_helpers.dart';
import 'package:app/providers/system/design_controller.dart';
import '../../../constants/design_constants.dart';
import '../../atoms/buttons/positive_close_button.dart';
import '../../molecules/navigation/positive_app_bar.dart';
import '../../molecules/scaffolds/positive_scaffold.dart';

@RoutePage()
class TermsAndConditionsPage extends ConsumerWidget {
  const TermsAndConditionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final MediaQueryData mediaQueryData = MediaQuery.of(context);

    return PositiveScaffold(
      backgroundColor: Colors.black,
      headingWidgets: <Widget>[
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
                PositiveAppBar(
                  foregroundColor: colors.white,
                  trailing: const <Widget>[
                    PositiveCloseButton(brightness: Brightness.dark),
                  ],
                ),
                MarkdownWidget(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  data: kTermsAndConditionsMarkdown,
                  selectable: false,
                  config: MarkdownConfig(
                    configs: buildMarkdownWidgetConfig(
                      brightness: Brightness.dark,
                      onTapLink: (str) {},
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
