// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/providers/user/promoted_posts_controller.dart';

@RoutePage()
class AccountPromotedPostsPage extends HookConsumerWidget {
  const AccountPromotedPostsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Text('promoted posts here please');
  }
}
