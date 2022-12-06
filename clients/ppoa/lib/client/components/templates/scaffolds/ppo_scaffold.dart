// Dart imports:
import 'dart:math';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:ppoa/business/services/service_mixin.dart';
import 'package:ppoa/business/state/design_system/models/design_system_brand.dart';
import 'package:ppoa/client/components/atoms/buttons/enumerations/ppo_checkbox_style.dart';
import 'package:ppoa/client/components/atoms/buttons/ppo_checkbox.dart';
import 'package:sliver_tools/sliver_tools.dart';
import '../../../constants/ppo_design_constants.dart';
import '../../atoms/containers/ppo_glass_container.dart';
import '../../atoms/decorations/ppo_scaffold_decoration.dart';

//* Decides where to display errors, if they exist within the application.
enum ScaffoldErrorHandlingStyle {
  displayTop,
  displayBottom,
  displayNone,
}

class PPOScaffold extends HookConsumerWidget with ServiceMixin {
  const PPOScaffold({
    required this.children,
    this.controller,
    this.appBar,
    this.decorations = const <PPOScaffoldDecoration>[],
    this.backgroundColor,
    this.popDestination,
    this.trailingWidgets = const <Widget>[],
    this.disableTrailingWidgets = false,
    this.resizeToAvoidBottomInset = true,
    this.errorHandlingStyle = ScaffoldErrorHandlingStyle.displayBottom,
    super.key,
  });

  final List<Widget> children;
  final ScrollController? controller;

  final PreferredSizeWidget? appBar;
  final List<PPOScaffoldDecoration> decorations;
  final Color? backgroundColor;

  final PageRouteInfo? popDestination;

  final List<Widget> trailingWidgets;
  final bool disableTrailingWidgets;

  final bool resizeToAvoidBottomInset;

  final ScaffoldErrorHandlingStyle errorHandlingStyle;

  Future<bool> onWillPopScope() async {
    if (popDestination != null) {
      await router.push(popDestination!);
    }

    return false;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final Size screenSize = mediaQueryData.size;
    final double decorationBoxSize = min(screenSize.height / 2, 400);

    final bool isBusy = ref.watch(stateProvider.select((value) => value.systemState.isBusy));
    final DesignSystemBrand branding = ref.watch(stateProvider.select((value) => value.designSystem.brand));

    final Object? exception = ref.watch(stateProvider.select((value) => value.systemState.currentException));

    //! TODO(ryan): Create service to handle
    final String errorMessage = exception?.toString() ?? '';

    return WillPopScope(
      onWillPop: onWillPopScope,
      child: Scaffold(
        appBar: appBar,
        backgroundColor: backgroundColor,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        body: CustomScrollView(
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
                //TODO(ryan): Check if error is present
                SliverFillRemaining(
                  fillOverscroll: false,
                  hasScrollBody: false,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      if (errorMessage.isNotEmpty) ...<Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: kPaddingSmall),
                          child: PPOCheckbox(
                            brand: branding,
                            onTapped: () async {},
                            style: PPOCheckboxStyle.small,
                            label: 'A mistake was made (error)',
                          ),
                        ),
                        const SizedBox(height: kPaddingSmall),
                      ],
                      if (trailingWidgets.isNotEmpty) ...<Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: kPaddingSmall),
                          child: PPOGlassContainer(
                            brand: branding,
                            isBusy: isBusy || disableTrailingWidgets,
                            children: trailingWidgets,
                          ),
                        ),
                        const SizedBox(height: kPaddingSmall),
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
