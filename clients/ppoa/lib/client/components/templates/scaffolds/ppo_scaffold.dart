import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sliver_tools/sliver_tools.dart';

import '../../atoms/decorations/ppo_decoration.dart';

class PPOScaffold extends StatelessWidget {
  const PPOScaffold({
    required this.child,
    this.controller,
    this.appBar,
    this.decorations = const <PPODecoration>[],
    super.key,
  });

  final Widget child;
  final ScrollController? controller;

  final PreferredSizeWidget? appBar;
  final List<PPODecoration> decorations;

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final Size screenSize = mediaQueryData.size;
    final double decorationBoxSize = min(screenSize.height / 2, 400);

    return Scaffold(
      appBar: appBar,
      body: CustomScrollView(
        controller: controller,
        slivers: <Widget>[
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
    );
  }
}
