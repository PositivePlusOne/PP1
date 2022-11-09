import 'package:flutter/material.dart';

class PPOScaffold extends StatelessWidget {
  const PPOScaffold({
    required this.child,
    this.controller,
    super.key,
  });

  final Widget child;
  final ScrollController? controller;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: controller,
      slivers: <Widget>[],
    );
  }
}
