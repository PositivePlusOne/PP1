// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/gen/app_router.dart';
import 'package:app/providers/analytics/analytic_events.dart';
import 'package:app/providers/analytics/analytics_controller.dart';
import 'package:app/widgets/organisms/shared/positive_generic_page.dart';

@RoutePage()
class HomeLoginPromptPage extends ConsumerWidget {
  const HomeLoginPromptPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations localisations = AppLocalizations.of(context)!;

    return PositiveGenericPage(
      title: localisations.page_home_blocker_title,
      body: localisations.page_home_blocker_body,
      buttonText: localisations.shared_actions_sign_up,
      isBusy: false,
      style: PositiveGenericPageStyle.imaged,
      canBack: true,
      onContinueSelected: () => onContinueSelected(context, ref),
    );
  }

  Future<void> onContinueSelected(BuildContext context, WidgetRef ref) async {
    final AppRouter appRouter = ref.read(appRouterProvider);
    final AnalyticsController analyticsController = ref.read(analyticsControllerProvider.notifier);

    await analyticsController.trackEvent(AnalyticEvents.conversionRegisterFromInterestRegistration);
    await appRouter.push(LoginRoute(senderRoute: HomeRoute));
  }
}
