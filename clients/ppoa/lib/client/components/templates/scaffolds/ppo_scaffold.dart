// Dart imports:
import 'dart:math';

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../atoms/decorations/ppo_decoration.dart';

class PPOScaffold extends StatelessWidget {
  const PPOScaffold({
    required this.children,
    this.controller,
    this.appBar,
    this.decorations = const <PPODecoration>[],
    this.backgroundColor,
    super.key,
  });

  final List<Widget> children;
  final ScrollController? controller;

  final PreferredSizeWidget? appBar;
  final List<PPODecoration> decorations;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final Size screenSize = mediaQueryData.size;
    final double decorationBoxSize = min(screenSize.height / 2, 400);

    return Scaffold(
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
    );
  }
}
