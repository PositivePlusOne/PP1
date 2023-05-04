// Dart imports:
import 'dart:math';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sliver_tools/sliver_tools.dart';

// Project imports:
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/widgets/molecules/containers/positive_glass_sheet.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold_decoration.dart';
import '../../../constants/design_constants.dart';

class PositiveScaffold extends ConsumerWidget {
  const PositiveScaffold({
    this.headingWidgets = const <Widget>[],
    this.trailingWidgets = const <Widget>[],
    this.footerWidgets = const <Widget>[],
    this.backgroundWidget,
    this.controller,
    this.appBar,
    this.bottomNavigationBar,
    this.decorations = const <PositiveScaffoldDecoration>[],
    this.backgroundColor,
    this.hideBottomPadding = false,
    this.resizeToAvoidBottomInset = true,
    this.extendBody = true,
    this.onWillPopScope,
    this.isBusy = false,
    this.refreshBackgroundColor,
    this.refreshForegroundColor,
    super.key,
  });

  final List<Widget> headingWidgets;
  final List<Widget> trailingWidgets;
  final List<Widget> footerWidgets;

  final Widget? backgroundWidget;

  final ScrollController? controller;

  final PreferredSizeWidget? appBar;
  final PreferredSizeWidget? bottomNavigationBar;

  final List<PositiveScaffoldDecoration> decorations;
  final Color? backgroundColor;
  final bool hideBottomPadding;

  final bool resizeToAvoidBottomInset;
  final bool extendBody;

  final Future<bool> Function()? onWillPopScope;

  final bool isBusy;

  final Color? refreshBackgroundColor;
  final Color? refreshForegroundColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final Size screenSize = mediaQueryData.size;
    final double decorationBoxSize = min(screenSize.height / 2, 400);

    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));

    //* Add padding for the bottom of the screens to cover the bottom navigation bar
    final double bottomPadding = mediaQueryData.padding.bottom + kPaddingMedium + (bottomNavigationBar?.preferredSize.height ?? 0);

    return WillPopScope(
      onWillPop: isBusy ? (() async => false) : (onWillPopScope ?? () async => true),
      child: Scaffold(
        backgroundColor: backgroundColor ?? colors.colorGray1,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        extendBody: extendBody,
        appBar: appBar,
        bottomNavigationBar: bottomNavigationBar,
        body: CustomScrollView(
          controller: controller,
          slivers: <Widget>[
            ...headingWidgets,
            SliverStack(
              children: <Widget>[
                if (decorations.isNotEmpty) ...<Widget>[
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: decorationBoxSize,
                      width: decorationBoxSize,
                      child: Stack(children: decorations),
                    ),
                  ),
                ],
                if (backgroundWidget != null) ...<Widget>[
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: decorationBoxSize,
                      width: decorationBoxSize,
                      child: backgroundWidget!,
                    ),
                  ),
                ],
                SliverFillRemaining(
                  fillOverscroll: true,
                  hasScrollBody: false,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      if (trailingWidgets.isNotEmpty) ...<Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: kPaddingMedium),
                          child: Column(children: trailingWidgets),
                        ),
                      ],
                      if (footerWidgets.isNotEmpty) ...<Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: kPaddingSmall),
                          child: PositiveGlassSheet(
                            isBusy: isBusy,
                            children: footerWidgets,
                          ),
                        ),
                      ],
                      if (!hideBottomPadding) ...<Widget>[
                        SizedBox(height: bottomPadding),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
