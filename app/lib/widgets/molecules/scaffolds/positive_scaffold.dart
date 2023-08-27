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

  static Set<PositiveScaffoldComponent> get onlyHeadingWidgets => {headingWidgets};
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
    this.appBarColor,
    this.bottomNavigationBar,
    this.decorations = const <PositiveScaffoldDecoration>[],
    this.backgroundColor,
    this.decorationColor,
    this.resizeToAvoidBottomInset = true,
    this.extendBody = true,
    this.onWillPopScope,
    this.isBusy = false,
    this.physics = const ClampingScrollPhysics(),
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
  final Color? appBarColor;
  final PreferredSizeWidget? bottomNavigationBar;

  final List<PositiveScaffoldDecoration> decorations;
  final Color? backgroundColor;
  final Color? decorationColor;

  final bool resizeToAvoidBottomInset;
  final bool extendBody;

  final Future<bool> Function()? onWillPopScope;

  final bool isBusy;

  final ScrollPhysics physics;

  static Future<void> dismissKeyboardIfPresent(BuildContext context) async {
    final FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
      await Future<void>.delayed(kAnimationDurationRegular);
    }
  }

  static MediaQueryData buildMediaQuery(MediaQueryData mediaQueryData) {
    return mediaQueryData.copyWith(
      textScaleFactor: 1.0,
      boldText: false,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final Size screenSize = mediaQueryData.size;
    final double decorationBoxSize = min(screenSize.height / 2, 400);

    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));

    // Check if the bottom navigation bar is present
    final bool hasBottomNavigationBar = bottomNavigationBar != null && mediaQueryData.viewInsets.bottom == 0;

    //* Add padding for the bottom of the screens to cover the bottom navigation bar
    final double bottomPadding = !hasBottomNavigationBar ? mediaQueryData.padding.bottom + kPaddingMedium : bottomNavigationBar?.preferredSize.height ?? 0;

    final Color actualBackgroundColor = backgroundColor ?? colors.colorGray1;

    return WillPopScope(
      onWillPop: isBusy ? (() async => false) : (onWillPopScope ?? () async => true),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: buildSystemUiOverlayStyle(appBarColor: appBarColor, backgroundColor: actualBackgroundColor),
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: MediaQuery(
            data: buildMediaQuery(mediaQueryData),
            child: Scaffold(
              backgroundColor: actualBackgroundColor,
              resizeToAvoidBottomInset: resizeToAvoidBottomInset,
              extendBody: extendBody,
              appBar: appBar,
              bottomNavigationBar: bottomNavigationBar ?? const SizedBox.shrink(),
              body: CustomScrollView(
                controller: controller,
                physics: physics,
                slivers: <Widget>[
                  if (visibleComponents.contains(PositiveScaffoldComponent.headingWidgets)) ...<Widget>[
                    ...headingWidgets,
                  ],
                  if (visibleComponents.any((element) => element.inBottomSliver)) ...<Widget>[
                    SliverToBoxAdapter(
                      child: Container(height: kPaddingMedium, color: decorationColor ?? Colors.transparent),
                    ),
                    SliverStack(
                      positionedAlignment: Alignment.bottomCenter,
                      children: <Widget>[
                        if (decorations.isNotEmpty && visibleComponents.contains(PositiveScaffoldComponent.decorationWidget)) ...<Widget>[
                          SliverFillRemaining(
                            fillOverscroll: true,
                            hasScrollBody: false,
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: SizedBox(
                                height: decorationBoxSize,
                                width: decorationBoxSize,
                                child: Stack(children: decorations),
                              ),
                            ),
                          ),
                        ],
                        if (decorationWidget != null && visibleComponents.contains(PositiveScaffoldComponent.decorationWidget)) ...<Widget>[
                          SliverFillRemaining(
                            fillOverscroll: true,
                            hasScrollBody: false,
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: SizedBox(
                                height: decorationBoxSize,
                                width: decorationBoxSize,
                                child: decorationWidget!,
                              ),
                            ),
                          ),
                        ],
                        SliverFillRemaining(
                          fillOverscroll: true,
                          hasScrollBody: false,
                          child: Container(
                            color: decorationColor ?? Colors.transparent,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                if (trailingWidgets.isNotEmpty && visibleComponents.contains(PositiveScaffoldComponent.trailingWidgets)) ...<Widget>[
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: kPaddingMedium),
                                    child: Column(children: trailingWidgets),
                                  ),
                                ],
                                if (footerWidgets.isNotEmpty && visibleComponents.contains(PositiveScaffoldComponent.footerWidgets)) ...<Widget>[
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: kPaddingSmall),
                                    child: PositiveGlassSheet(
                                      isBusy: isBusy,
                                      children: footerWidgets,
                                    ),
                                  ),
                                ],
                                if (visibleComponents.contains(PositiveScaffoldComponent.footerPadding)) ...<Widget>[
                                  //* This also helps to guard against overscroll when showing the keyboard on Android!
                                  Flexible(child: Container(height: bottomPadding, color: decorationColor ?? Colors.transparent)),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
