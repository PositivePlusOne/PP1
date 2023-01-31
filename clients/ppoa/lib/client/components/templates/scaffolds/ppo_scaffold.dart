// Dart imports:
import 'dart:math';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:ppoa/business/extensions/system_extensions.dart';
import 'package:ppoa/business/services/service_mixin.dart';
import 'package:ppoa/business/state/design_system/models/design_system_brand.dart';
import 'package:ppoa/business/state/system/system_state.dart';
import '../../../constants/ppo_design_constants.dart';
import '../../atoms/containers/ppo_glass_container.dart';
import '../../atoms/decorations/ppo_scaffold_decoration.dart';
import '../../atoms/pills/ppo_hint.dart';

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
    this.trailingWidgets = const <Widget>[],
    this.disableTrailingWidgets = false,
    this.resizeToAvoidBottomInset = true,
    this.errorHandlingStyle = ScaffoldErrorHandlingStyle.displayBottom,
    this.onWillPopScope,
    super.key,
  });

  final List<Widget> children;
  final ScrollController? controller;

  final PreferredSizeWidget? appBar;
  final List<PPOScaffoldDecoration> decorations;
  final Color? backgroundColor;

  final List<Widget> trailingWidgets;
  final bool disableTrailingWidgets;

  final bool resizeToAvoidBottomInset;

  final ScaffoldErrorHandlingStyle errorHandlingStyle;

  final Future<bool> Function()? onWillPopScope;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final Size screenSize = mediaQueryData.size;
    final double decorationBoxSize = min(screenSize.height / 2, 400);

    final AppLocalizations localizations = AppLocalizations.of(context)!;

    final DesignSystemBrand branding = ref.watch(stateProvider.select((value) => value.designSystem.brand));

    final SystemState systemState = ref.watch(stateProvider.select((value) => value.systemState));
    final String errorMessage = systemState.getLocalizedErrorMessage(localizations, router);

    return WillPopScope(
      onWillPop: systemState.isBusy ? (() async => false) : (onWillPopScope ?? () async => true),
      child: Scaffold(
        appBar: appBar,
        backgroundColor: backgroundColor ?? branding.colors.colorGray1,
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
                SliverFillRemaining(
                  fillOverscroll: false,
                  hasScrollBody: false,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      if (errorMessage.isNotEmpty) ...<Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: kPaddingMedium),
                          child: PPOHint(
                            brand: branding,
                            label: errorMessage,
                            icon: UniconsLine.exclamation_triangle,
                            iconColor: branding.colors.red,
                          ),
                        ),
                        const SizedBox(height: kPaddingSmall),
                      ],
                      if (trailingWidgets.isNotEmpty) ...<Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: kPaddingSmall),
                          child: PPOGlassContainer(
                            brand: branding,
                            isBusy: systemState.isBusy || disableTrailingWidgets,
                            children: trailingWidgets,
                          ),
                        ),
                      ],

                      //* Add padding for the bottom of the screens
                      SizedBox(height: mediaQueryData.padding.bottom + kPaddingSmall),
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
