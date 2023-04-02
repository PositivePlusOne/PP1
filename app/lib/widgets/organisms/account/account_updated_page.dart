// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/gen/app_router.dart';
import '../shared/positive_generic_page.dart';

class AccountUpdatedPage extends ConsumerWidget {
  const AccountUpdatedPage({
    required this.body,
    super.key,
  });

  final String body;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppRouter appRouter = ref.read(appRouterProvider);

    return PositiveGenericPage(
      title: 'Thanks!',
      body: body,
      buttonText: 'Back to account',
      isBusy: false,
      style: PositiveGenericPageStyle.imaged,
      onContinueSelected: () async {
        appRouter.popUntilRoot();
        await appRouter.push(const AccountRoute());
      },
    );
  }
}
