// Dart imports:
import 'dart:math';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sliver_tools/sliver_tools.dart';

// Project imports:
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/extensions/color_extensions.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/widgets/molecules/containers/positive_glass_sheet.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold_decoration.dart';
import '../../../constants/design_constants.dart';

enum PositiveScaffoldComponent {
  headingWidgets,
  trailingWidgets,
  decorationWidget,
  footerWidgets,
  footerPadding;

  bool get inBottomSliver => this != headingWidgets;

  static Set<PositiveScaffoldComponent> get excludeFooterPadding => PositiveScaffoldComponent.values.toSet()..remove(footerPadding);
}

class PositiveScaffold extends ConsumerWidget {
  const PositiveScaffold({
    this.headingWidgets = const <Widget>[],
    this.trailingWidgets = const <Widget>[],
    this.footerWidgets = const <Widget>[],
    this.decorationWidget,
    this.controller,
    this.appBar,
    this.bottomNavigationBar,
    this.decorations = const <PositiveScaffoldDecoration>[],
    this.backgroundColor,
    this.footerBackgroundColor,
    this.resizeToAvoidBottomInset = true,
    this.extendBody = true,
    this.onWillPopScope,
    this.isBusy = false,
    this.refreshBackgroundColor,
    this.refreshForegroundColor,
    this.physics = const BouncingScrollPhysics(),
    this.visibleComponents = const <PositiveScaffoldComponent>{
      PositiveScaffoldComponent.headingWidgets,
      PositiveScaffoldComponent.decorationWidget,
      PositiveScaffoldComponent.trailingWidgets,
      PositiveScaffoldComponent.footerWidgets,
      PositiveScaffoldComponent.footerPadding,
    },
    super.key,
  });

  final List<Widget> headingWidgets;
  final List<Widget> trailingWidgets;
  final List<Widget> footerWidgets;
  final Set<PositiveScaffoldComponent> visibleComponents;

  final Widget? decorationWidget;

  final ScrollController? controller;

  final PreferredSizeWidget? appBar;
  final PreferredSizeWidget? bottomNavigationBar;

  final List<PositiveScaffoldDecoration> decorations;
  final Color? backgroundColor;
  final Color? footerBackgroundColor;

  final bool resizeToAvoidBottomInset;
  final bool extendBody;

  final Future<bool> Function()? onWillPopScope;

  final bool isBusy;

  final Color? refreshBackgroundColor;
  final Color? refreshForegroundColor;

  final ScrollPhysics physics;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final Size screenSize = mediaQueryData.size;
    final double decorationBoxSize = min(screenSize.height / 2, 400);

    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));

    //* Add padding for the bottom of the screens to cover the bottom navigation bar
    final double bottomPadding = mediaQueryData.padding.bottom + kPaddingMedium + (bottomNavigationBar?.preferredSize.height ?? 0);

    final Color actualBackgroundColor = backgroundColor ?? colors.colorGray1;

    return WillPopScope(
      onWillPop: isBusy ? (() async => false) : (onWillPopScope ?? () async => true),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: actualBackgroundColor.systemUiOverlayStyle,
        child: Scaffold(
          backgroundColor: actualBackgroundColor,
          resizeToAvoidBottomInset: resizeToAvoidBottomInset,
          extendBody: extendBody,
          appBar: appBar,
          bottomNavigationBar: bottomNavigationBar,
          body: CustomScrollView(
            controller: controller,
            physics: physics,
            slivers: <Widget>[
              if (visibleComponents.contains(PositiveScaffoldComponent.headingWidgets)) ...<Widget>[
                ...headingWidgets,
              ],
              // if (visibleComponents.any((element) => element.inBottomSliver)) ...<Widget>[
              //   SliverPadding(
              //     padding: const EdgeInsets.only(top: kPaddingMedium),
              //     sliver: SliverStack(
              //       children: <Widget>[
              //         if (decorations.isNotEmpty && visibleComponents.contains(PositiveScaffoldComponent.decorationWidget)) ...<Widget>[
              //           SliverToBoxAdapter(
              //             child: SizedBox(
              //               height: decorationBoxSize,
              //               width: decorationBoxSize,
              //               child: Stack(children: decorations),
              //             ),
              //           ),
              //         ],
              //         if (decorationWidget != null && visibleComponents.contains(PositiveScaffoldComponent.decorationWidget)) ...<Widget>[
              //           SliverToBoxAdapter(
              //             child: SizedBox(
              //               height: decorationBoxSize,
              //               width: decorationBoxSize,
              //               child: decorationWidget!,
              //             ),
              //           ),
              //         ],
              //         SliverFillRemaining(
              //           fillOverscroll: true,
              //           hasScrollBody: false,
              //           child: Container(
              //             color: footerBackgroundColor ?? Colors.transparent,
              //             child: Column(
              //               mainAxisAlignment: MainAxisAlignment.end,
              //               children: <Widget>[
              //                 if (trailingWidgets.isNotEmpty && visibleComponents.contains(PositiveScaffoldComponent.trailingWidgets)) ...<Widget>[
              //                   Padding(
              //                     padding: const EdgeInsets.symmetric(horizontal: kPaddingMedium),
              //                     child: Column(children: trailingWidgets),
              //                   ),
              //                 ],
              //                 if (footerWidgets.isNotEmpty && visibleComponents.contains(PositiveScaffoldComponent.footerWidgets)) ...<Widget>[
              //                   Padding(
              //                     padding: const EdgeInsets.symmetric(horizontal: kPaddingSmall),
              //                     child: PositiveGlassSheet(
              //                       isBusy: isBusy,
              //                       children: footerWidgets,
              //                     ),
              //                   ),
              //                 ],
              //                 if (visibleComponents.contains(PositiveScaffoldComponent.footerPadding)) ...<Widget>[
              //                   SizedBox(height: bottomPadding),
              //                 ],
              //               ],
              //             ),
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ],
            ],
          ),
        ),
      ),
    );
  }
}
