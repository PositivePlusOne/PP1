// Flutter imports:
import 'package:app/extensions/color_extensions.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import '../../../constants/design_constants.dart';
import '../../../dtos/system/design_colors_model.dart';
import '../../../providers/system/design_controller.dart';
import '../navigation/positive_app_bar.dart';

class PositiveBasicSliverList extends ConsumerWidget {
  const PositiveBasicSliverList({
    this.children = const <Widget>[],
    this.includeAppBar = true,
    this.appBarTrailing = const <Widget>[],
    this.backgroundColor,
    super.key,
  });

  final List<Widget> children;

  final bool includeAppBar;
  final List<Widget> appBarTrailing;

  final Color? backgroundColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final MediaQueryData mediaQueryData = MediaQuery.of(context);

    final EdgeInsets padding = EdgeInsets.only(
      top: kPaddingMedium + mediaQueryData.padding.top,
      left: kPaddingMedium,
      right: kPaddingMedium,
      bottom: kPaddingMedium,
    );

    return SliverPadding(
      padding: padding,
      sliver: SliverList(
        delegate: SliverChildListDelegate(
          <Widget>[
            if (includeAppBar) ...<Widget>[
              PositiveAppBar(
                backgroundColor: backgroundColor ?? colors.colorGray1,
                foregroundColor: (backgroundColor ?? colors.colorGray1).complimentTextColor(colors),
                trailing: appBarTrailing,
              ),
              const SizedBox(height: kPaddingMassive),
            ],
            ...children,
          ],
        ),
      ),
    );
  }
}
