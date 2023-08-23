// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/extensions/profile_extensions.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/widgets/behaviours/positive_notification_pagination_behaviour.dart';
import 'package:app/widgets/molecules/layouts/positive_basic_sliver_list.dart';
import 'package:app/widgets/molecules/navigation/positive_navigation_bar.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';

@RoutePage()
class NotificationsPage extends ConsumerWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Profile? currentProfile = ref.watch(profileControllerProvider.select((value) => value.currentProfile));
    final String profileId = currentProfile?.flMeta?.id ?? '';

    final List<Widget> actions = [];
    if (currentProfile != null) {
      actions.addAll(currentProfile.buildCommonProfilePageActions(disableNotifications: true));
    }

    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    return PositiveScaffold(
      bottomNavigationBar: PositiveNavigationBar(mediaQuery: mediaQueryData),
      headingWidgets: <Widget>[
        PositiveBasicSliverList(
          appBarTrailing: actions,
          appBarSpacing: kPaddingSmall,
          children: <Widget>[
            if (profileId.isNotEmpty) ...<Widget>[
              PositiveNotificationsPaginationBehaviour(uid: profileId),
            ],
          ],
        ),
      ],
    );
  }
}
