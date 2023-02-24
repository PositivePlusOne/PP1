// Dart imports:
import 'dart:math';

// Flutter imports:
import 'package:app/extensions/color_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/widgets/molecules/containers/positive_glass_sheet.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold_decoration.dart';
import '../../../constants/design_constants.dart';
import '../prompts/positive_hint.dart';

class PositiveScaffold extends ConsumerWidget {
  const PositiveScaffold({
    required this.children,
    this.controller,
    this.appBar,
    this.decorations = const <PositiveScaffoldDecoration>[],
    this.backgroundColor,
    this.trailingWidgets = const <Widget>[],
    this.hideTrailingDecoration = false,
    this.hideBottomPadding = false,
    this.resizeToAvoidBottomInset = true,
    this.onWillPopScope,
    this.isBusy = false,
    this.errorMessage = '',
    this.refreshController,
    this.onRefresh,
    this.refreshBackgroundColor,
    this.refreshForegroundColor,
    super.key,
  });

  final List<Widget> children;
  final ScrollController? controller;

  final PreferredSizeWidget? appBar;
  final List<PositiveScaffoldDecoration> decorations;
  final Color? backgroundColor;

  final List<Widget> trailingWidgets;
  final bool hideTrailingDecoration;
  final bool hideBottomPadding;

  final bool resizeToAvoidBottomInset;

  final Future<bool> Function()? onWillPopScope;

  final bool isBusy;
  final String errorMessage;

  final Future<void> Function()? onRefresh;
  final RefreshController? refreshController;
  final Color? refreshBackgroundColor;
  final Color? refreshForegroundColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final Size screenSize = mediaQueryData.size;
    final double decorationBoxSize = min(screenSize.height / 2, 400);

    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));

    return WillPopScope(
      onWillPop: isBusy ? (() async => false) : (onWillPopScope ?? () async => true),
      child: Scaffold(
        appBar: appBar,
        backgroundColor: backgroundColor ?? colors.colorGray1,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        body: SmartRefresher(
          enablePullDown: onRefresh != null,
          onRefresh: onRefresh,
          controller: refreshController ?? RefreshController(),
          header: WaterDropMaterialHeader(
            color: (refreshForegroundColor ?? colors.white).complimentTextColor(colors),
            backgroundColor: refreshBackgroundColor ?? colors.pink,
          ),
          child: CustomScrollView(
            controller: controller,
            slivers: <Widget>[
              ...children,
              SliverStack(
                children: <Widget>[
                  if (decorations.isNotEmpty) ...<Widget>[
                    SliverFillRemaining(
                      fillOverscroll: false,
                      hasScrollBody: false,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          constraints: BoxConstraints(
                            maxHeight: decorationBoxSize,
                            maxWidth: decorationBoxSize,
                          ),
                          child: Stack(children: decorations),
                        ),
                      ),
                    ),
                  ],
                  SliverFillRemaining(
                    fillOverscroll: false,
                    hasScrollBody: false,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        if (errorMessage.isNotEmpty) ...<Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: kPaddingMedium),
                            child: PositiveHint(
                              label: errorMessage,
                              icon: UniconsLine.exclamation_triangle,
                              iconColor: colors.red,
                            ),
                          ),
                          const SizedBox(height: kPaddingSmall),
                        ],
                        if (trailingWidgets.isNotEmpty) ...<Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: kPaddingSmall),
                            child: hideTrailingDecoration
                                ? Column(children: trailingWidgets)
                                : PositiveGlassSheet(
                                    isBusy: isBusy,
                                    children: trailingWidgets,
                                  ),
                          ),
                        ],
                        if (!hideBottomPadding) ...<Widget>[
                          //* Add padding for the bottom of the screens
                          SizedBox(height: mediaQueryData.padding.bottom + kPaddingMedium),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
