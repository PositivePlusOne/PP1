// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/extensions/widget_extensions.dart';
import 'activate_account_banner.dart';

class HubAppBarContent extends ConsumerWidget implements PreferredSizeWidget {
  const HubAppBarContent({
    required this.shouldDisplayActivateAccountBanner,
    super.key,
  });

  final bool shouldDisplayActivateAccountBanner;

  @override
  Size get preferredSize {
    int expectedDividerCount = -1;
    double expectedSize = 0.0;

    if (shouldDisplayActivateAccountBanner) {
      expectedSize += ActivateAccountBanner.kHeight;
      expectedDividerCount++;
    }

    if (expectedDividerCount > 0) {
      expectedSize += (expectedDividerCount * kPaddingSmall);
    }

    return Size.fromHeight(expectedSize);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: kPaddingMedium),
      child: Column(
        children: <Widget>[
          if (shouldDisplayActivateAccountBanner) const ActivateAccountBanner(),
        ].spaceWithVertical(kPaddingSmall),
      ),
    );
  }
}
