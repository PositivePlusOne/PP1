// Dart imports:
import 'dart:async';
import 'dart:math';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:event_bus/event_bus.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:sliver_tools/sliver_tools.dart';

// Project imports:
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/extensions/widget_extensions.dart';
import 'package:app/main.dart';
import 'package:app/providers/content/events/deep_link_handling_event.dart';
import 'package:app/providers/content/universal_links_controller.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/services/third_party.dart';
import 'package:app/widgets/animations/positive_tile_entry_animation.dart';
import 'package:app/widgets/atoms/indicators/positive_loading_indicator.dart';
import 'package:app/widgets/molecules/containers/positive_glass_sheet.dart';
import 'package:app/widgets/molecules/indicators/positive_refresh_indicator.dart';
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

class PositiveScaffold extends StatefulHookConsumerWidget {
  const PositiveScaffold({
    this.headingWidgets = const <Widget>[],
    this.trailingWidgets = const <Widget>[],
    this.footerWidgets = const <Widget>[],
    this.overlayWidgets = const <Widget>[],
    this.decorationWidget,
    this.controller,
    this.appBar,
    this.appBarColor,
    this.bottomNavigationBar,
    this.decorations = const <PositiveScaffoldDecoration>[],
    this.decorationColor,
    this.forceDecorationMaxSize = false,
    this.backgroundColor,
    this.resizeToAvoidBottomInset = true,
    this.extendBody = true,
    this.onWillPopScope,
    this.onRefresh,
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
  final List<Widget> overlayWidgets;

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
  final Future<void> Function()? onRefresh;

  final bool isBusy;

  final ScrollPhysics physics;

  final bool forceDecorationMaxSize;

  static Future<void> dismissKeyboardIfPresent(BuildContext context) async {
    final FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
      await Future<void>.delayed(kAnimationDurationRegular);
    }
  }

  static MediaQueryData buildMediaQuery(MediaQueryData mediaQueryData) {
    return mediaQueryData.copyWith(
      boldText: false,
      textScaler: const TextScaler.linear(1.0),
    );
  }

  @override
  ConsumerState<PositiveScaffold> createState() => _PositiveScaffoldState();
}

class _PositiveScaffoldState extends ConsumerState<PositiveScaffold> {
  StreamSubscription<DeepLinkHandlingEvent>? _deepLinkHandlingEventSubscription;

  bool _isBusy = false;
  bool get isBusy => _isBusy;
  set isBusy(bool value) {
    if (value != _isBusy) {
      _isBusy = value;
      setStateIfMounted();
    }
  }

  @override
  void initState() {
    super.initState();
    setupListeners();
  }

  @override
  void dispose() {
    disposeListeners();
    super.dispose();
  }

  Future<void> setupListeners() async {
    final EventBus eventBus = providerContainer.read(eventBusProvider);
    await _deepLinkHandlingEventSubscription?.cancel();
    _deepLinkHandlingEventSubscription = eventBus.on<DeepLinkHandlingEvent>().listen(onDeepLinkHandlingEvent);
  }

  Future<void> disposeListeners() async {
    await _deepLinkHandlingEventSubscription?.cancel();
  }

  void onDeepLinkHandlingEvent(DeepLinkHandlingEvent event) {
    final Logger log = providerContainer.read(loggerProvider);
    log.d("Deep link handling event received: ${event.result}");

    if (event.result == HandleLinkResult.handling) {
      isBusy = true;
    } else {
      isBusy = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final Size screenSize = mediaQueryData.size;

    double decorationBoxSize = min(400.0, screenSize.width);
    if (widget.forceDecorationMaxSize) {
      decorationBoxSize = screenSize.width;
    }

    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));

    // Check if the bottom navigation bar is present
    final bool hasBottomNavigationBar = widget.bottomNavigationBar != null && mediaQueryData.viewInsets.bottom == 0;

    //* Add padding for the bottom of the screens to cover the bottom navigation bar
    final double bottomPadding = !hasBottomNavigationBar ? mediaQueryData.padding.bottom + kPaddingMedium : widget.bottomNavigationBar?.preferredSize.height ?? 0;

    final Color actualBackgroundColor = widget.backgroundColor ?? colors.colorGray1;

    final bool isBusy = this.isBusy || widget.isBusy;

    return WillPopScope(
      onWillPop: isBusy ? (() async => false) : (widget.onWillPopScope ?? () async => true),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: buildSystemUiOverlayStyle(appBarColor: widget.appBarColor, backgroundColor: actualBackgroundColor),
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: MediaQuery(
            data: PositiveScaffold.buildMediaQuery(mediaQueryData),
            child: PositiveRefreshIndicator(
              onRefresh: () async => widget.onRefresh?.call(),
              controller: IndicatorController(refreshEnabled: widget.onRefresh != null),
              child: Stack(
                children: <Widget>[
                  Positioned.fill(
                    child: Scaffold(
                      backgroundColor: actualBackgroundColor,
                      resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
                      extendBody: widget.extendBody,
                      appBar: widget.appBar,
                      bottomNavigationBar: widget.bottomNavigationBar ?? const SizedBox.shrink(),
                      body: Stack(
                        children: <Widget>[
                          Positioned.fill(
                            child: PositiveScaffoldContent(
                              controller: widget.controller,
                              physics: widget.physics,
                              visibleComponents: widget.visibleComponents,
                              headingWidgets: widget.headingWidgets,
                              decorationColor: widget.decorationColor,
                              decorations: widget.decorations,
                              decorationBoxSize: decorationBoxSize,
                              decorationWidget: widget.decorationWidget,
                              trailingWidgets: widget.trailingWidgets,
                              footerWidgets: widget.footerWidgets,
                              isBusy: isBusy,
                              bottomPadding: bottomPadding,
                            ),
                          ),
                          if (widget.overlayWidgets.isNotEmpty) ...<Widget>[
                            ...widget.overlayWidgets,
                          ],
                        ],
                      ),
                    ),
                  ),
                  if (isBusy) ...<Widget>[
                    Positioned.fill(
                      child: Container(
                        color: Colors.black.withOpacity(kOpacityBarrier),
                        child: Center(
                          child: PositiveLoadingIndicator(color: colors.white),
                        ),
                      ),
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

class PositiveScaffoldContent extends StatelessWidget {
  const PositiveScaffoldContent({
    super.key,
    required this.controller,
    required this.physics,
    required this.visibleComponents,
    required this.headingWidgets,
    required this.decorationColor,
    required this.decorations,
    required this.decorationBoxSize,
    required this.decorationWidget,
    required this.trailingWidgets,
    required this.footerWidgets,
    required this.isBusy,
    required this.bottomPadding,
  });

  final ScrollController? controller;
  final ScrollPhysics physics;
  final Set<PositiveScaffoldComponent> visibleComponents;
  final List<Widget> headingWidgets;
  final Color? decorationColor;
  final List<PositiveScaffoldDecoration> decorations;
  final double decorationBoxSize;
  final Widget? decorationWidget;
  final List<Widget> trailingWidgets;
  final List<Widget> footerWidgets;
  final bool isBusy;
  final double bottomPadding;

  @override
  Widget build(BuildContext context) {
    //? Dissalow decorations from rendering outside of  the page
    return ClipRect(
      child: CustomScrollView(
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
                      child: PositiveTileEntryAnimation(
                        direction: AxisDirection.down,
                        child: SizedBox(
                          height: decorationBoxSize,
                          width: decorationBoxSize,
                          child: Stack(children: decorations),
                        ),
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
                      child: PositiveTileEntryAnimation(
                        direction: AxisDirection.down,
                        child: ClipRRect(
                          child: SizedBox(
                            height: decorationBoxSize,
                            width: decorationBoxSize,
                            child: decorationWidget!,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
                SliverFillRemaining(
                  fillOverscroll: true,
                  hasScrollBody: false,
                  child: ScaffoldTrailingContent(
                    decorationColor: decorationColor,
                    trailingWidgets: trailingWidgets,
                    visibleComponents: visibleComponents,
                    footerWidgets: footerWidgets,
                    isBusy: isBusy,
                    bottomPadding: bottomPadding,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class ScaffoldTrailingContent extends StatelessWidget {
  const ScaffoldTrailingContent({
    super.key,
    required this.decorationColor,
    required this.trailingWidgets,
    required this.visibleComponents,
    required this.footerWidgets,
    required this.isBusy,
    required this.bottomPadding,
  });

  final Color? decorationColor;
  final List<Widget> trailingWidgets;
  final Set<PositiveScaffoldComponent> visibleComponents;
  final List<Widget> footerWidgets;
  final bool isBusy;
  final double bottomPadding;

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
