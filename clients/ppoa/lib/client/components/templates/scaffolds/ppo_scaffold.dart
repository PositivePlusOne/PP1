// Dart imports:
import 'dart:math';

// Flutter imports:
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:ppoa/business/services/service_mixin.dart';

// Project imports:
import '../../atoms/decorations/ppo_scaffold_decoration.dart';

class PPOScaffold extends StatelessWidget with ServiceMixin {
  const PPOScaffold({
    required this.children,
    this.controller,
    this.appBar,
    this.decorations = const <PPOScaffoldDecoration>[],
    this.backgroundColor,
    this.popDestination,
    this.bottomNavigationBar,
    super.key,
  });

  final List<Widget> children;
  final ScrollController? controller;

  final PreferredSizeWidget? appBar;
  final List<PPOScaffoldDecoration> decorations;
  final Color? backgroundColor;

  final PageRouteInfo? popDestination;
  final Widget? bottomNavigationBar;

  Future<bool> onWillPopScope() async {
    if (popDestination != null) {
      await router.push(popDestination!);
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final Size screenSize = mediaQueryData.size;
    final double decorationBoxSize = min(screenSize.height / 2, 400);

    return WillPopScope(
      onWillPop: onWillPopScope,
      child: Scaffold(
        appBar: appBar,
        backgroundColor: backgroundColor,
        bottomNavigationBar: bottomNavigationBar,
        extendBody: true,
        body: CustomScrollView(
          controller: controller,
          slivers: <Widget>[
            ...children,
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
          ],
        ),
      ),
    );
  }
}
