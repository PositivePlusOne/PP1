// Dart imports:
import 'dart:math';

// Flutter imports:
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:ppoa/business/services/service_mixin.dart';

// Project imports:
import '../../atoms/decorations/ppo_decoration.dart';

class PPOScaffold extends StatelessWidget with ServiceMixin {
  const PPOScaffold({
    required this.children,
    this.controller,
    this.appBar,
    this.decorations = const <PPODecoration>[],
    this.backgroundColor,
    this.popDestination,
    super.key,
  });

  final List<Widget> children;
  final ScrollController? controller;

  final PreferredSizeWidget? appBar;
  final List<PPODecoration> decorations;
  final Color? backgroundColor;

  final PageRouteInfo? popDestination;

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
        body: CustomScrollView(
          controller: controller,
          slivers: <Widget>[
            ...children,
            if (decorations.isNotEmpty) ...<Widget>[
              SliverFillRemaining(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    alignment: Alignment.bottomCenter,
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
