import 'package:app/constants/design_constants.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PositiveAppBarContent extends ConsumerWidget with PreferredSizeWidget {
  const PositiveAppBarContent({
    required this.backgroundColor,
    this.children = const <PreferredSizeWidget>[],
    super.key,
  });

  final Color backgroundColor;

  final List<PreferredSizeWidget> children;

  @override
  Size get preferredSize => Size(
        double.infinity,
        kBorderRadiusLarge + children.fold<double>(0, (double previousValue, PreferredSizeWidget element) => previousValue + element.preferredSize.height),
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnimatedContainer(
      duration: kAnimationDurationRegular,
      padding: const EdgeInsets.only(
        bottom: kBorderRadiusLarge,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(kBorderRadiusLarge),
          bottomRight: Radius.circular(kBorderRadiusLarge),
        ),
      ),
      child: Column(
        children: children,
      ),
    );
  }
}
