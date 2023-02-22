import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../constants/design_constants.dart';

class PositiveTextFieldPrefixContainer extends ConsumerWidget with PreferredSizeWidget {
  const PositiveTextFieldPrefixContainer({
    required this.child,
    required this.color,
    super.key,
  });

  final Widget child;
  final Color color;

  static const double kSeparatorWidth = 1.0;
  static const double kVerticalMargin = 5.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: preferredSize.width,
      height: preferredSize.height,
      child: Row(
        children: <Widget>[
          const SizedBox(width: kPaddingSmall),
          child,
          Container(
            height: double.infinity,
            width: kSeparatorWidth,
            margin: const EdgeInsets.symmetric(vertical: kVerticalMargin),
            color: color,
          ),
          const SizedBox(width: kPaddingSmall),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size(75.0, 40.0);
}
