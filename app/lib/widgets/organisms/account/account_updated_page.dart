// Flutter imports:
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/gen/app_router.dart';
import '../shared/positive_generic_page.dart';

@RoutePage()
class AccountUpdatedPage extends ConsumerWidget {
  const AccountUpdatedPage({
    required this.body,
    this.title,
    this.buttonText,
    this.onContinueSelected,
    super.key,
  });

  final String body;
  final String? title;
  final String? buttonText;

  final Future<void> Function()? onContinueSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppRouter appRouter = ref.read(appRouterProvider);

    return PositiveGenericPage(
      title: title ?? 'Thanks!',
      body: body,
      buttonText: buttonText ?? 'Back to account',
      isBusy: false,
      style: PositiveGenericPageStyle.imaged,
      onContinueSelected: onContinueSelected ??
          () async {
            appRouter.popUntilRoot();
            await appRouter.push(const AccountRoute());
          },
    );
  }
}
