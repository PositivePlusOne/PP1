// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sliver_tools/sliver_tools.dart';

// Project imports:
import 'package:app/extensions/color_extensions.dart';
import '../../../constants/design_constants.dart';
import '../../../dtos/system/design_colors_model.dart';
import '../../../providers/system/design_controller.dart';
import '../navigation/positive_app_bar.dart';

class PositiveBasicSliverList extends ConsumerWidget {
  const PositiveBasicSliverList({
    this.children = const <Widget>[],
    this.includeAppBar = true,
    this.appBarLeading,
    this.appBarTrailing = const <Widget>[],
    this.horizontalPadding = kPaddingMedium,
    this.foregroundColor,
    this.backgroundColor,
    this.appBarTrailingHeight = kPaddingMassive,
    this.appBarTrailType = PositiveAppBarTrailType.none,
    this.appBarBottom,
    this.appBarSpacing = kPaddingExtraLarge,
    super.key,
  });

  final List<Widget> children;

  final bool includeAppBar;
  final Widget? appBarLeading;
  final List<Widget> appBarTrailing;
  final double horizontalPadding;

  final Color? foregroundColor;
  final Color? backgroundColor;

  final double appBarTrailingHeight;
  final PositiveAppBarTrailType appBarTrailType;
  final PreferredSizeWidget? appBarBottom;
  final double appBarSpacing;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final MediaQueryData mediaQueryData = MediaQuery.of(context);

    final EdgeInsets padding = EdgeInsets.only(
      top: includeAppBar ? 0.0 : kPaddingMassive,
      left: horizontalPadding,
      right: horizontalPadding,
    );

    return MultiSliver(
      children: [
        if (includeAppBar) ...<Widget>[
          PositiveAppBar(
            backgroundColor: backgroundColor ?? colors.colorGray1,
            foregroundColor: foregroundColor ?? (backgroundColor ?? colors.colorGray1).complimentTextColor,
            includeLogoWherePossible: appBarLeading == null,
            safeAreaQueryData: mediaQueryData,
            applyLeadingandTrailingPadding: true,
            decorationColor: backgroundColor ?? colors.colorGray1,
            leading: appBarLeading,
            trailing: appBarTrailing,
            trailType: appBarTrailType,
            bottom: appBarBottom,
          ),
          SizedBox(height: appBarSpacing),
        ],
        SliverPadding(
          padding: padding,
          sliver: SliverList(
            delegate: SliverChildListDelegate(children),
          ),
        ),
      ],
    );
  }
}
