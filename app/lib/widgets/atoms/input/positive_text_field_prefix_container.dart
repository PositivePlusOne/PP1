// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import '../../../constants/design_constants.dart';

class PositiveTextFieldPrefixContainer extends ConsumerWidget implements PreferredSizeWidget {
  const PositiveTextFieldPrefixContainer({
    required this.child,
    required this.color,
    this.isPreviewOnly = false,
    super.key,
  });

  final Widget child;
  final Color color;
  final bool isPreviewOnly;

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
  Size get preferredSize => Size(isPreviewOnly ? 69.0 : 63.0, 40.0);
}
