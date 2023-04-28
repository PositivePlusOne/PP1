// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import '../../../../dtos/database/profile/profile.dart';

class ProfileAppBarHeader extends ConsumerWidget implements PreferredSizeWidget {
  const ProfileAppBarHeader({
    required this.profile,
    this.children = const <PreferredSizeWidget>[],
    super.key,
  });

  final Profile profile;
  final List<PreferredSizeWidget> children;

  static const double kBottomPadding = 10.0;

  @override
  Size get preferredSize {
    double height = kBottomPadding;

    for (final PreferredSizeWidget child in children) {
      height += child.preferredSize.height;
      if (children.indexOf(child) < children.length - 1) {
        height += kPaddingSmall;
      }
    }

    return Size.fromHeight(height);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: preferredSize.height,
      width: double.infinity,
      child: Column(
        children: <Widget>[
          for (final PreferredSizeWidget child in children) ...<Widget>[
            child,
            if (children.indexOf(child) < children.length - 1) ...<Widget>[
              const SizedBox(height: kPaddingSmall),
            ],
          ],
          const SizedBox(height: kBottomPadding),
        ],
      ),
    );
  }
}
