// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/extensions/widget_extensions.dart';
import 'package:app/main.dart';
import '../../../../services/third_party.dart';
import 'activate_account_banner.dart';

class HubAppBarContent extends ConsumerWidget with PreferredSizeWidget {
  const HubAppBarContent({super.key});

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

  bool get shouldDisplayActivateAccountBanner {
    final FirebaseAuth firebaseAuth = providerContainer.read(firebaseAuthProvider);
    return firebaseAuth.currentUser == null;
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
