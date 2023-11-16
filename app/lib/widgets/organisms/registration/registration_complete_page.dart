// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/extensions/widget_extensions.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/providers/analytics/analytic_events.dart';
import 'package:app/providers/analytics/analytics_controller.dart';
import 'package:app/providers/user/get_stream_controller.dart';
import 'package:app/widgets/organisms/shared/positive_generic_page.dart';

@RoutePage()
class RegistrationCompletePage extends StatefulHookConsumerWidget {
  const RegistrationCompletePage({super.key});

  @override
  ConsumerState<RegistrationCompletePage> createState() => _RegistrationCompletePageState();
}

class _RegistrationCompletePageState extends ConsumerState<RegistrationCompletePage> {
  bool _isBusy = false;
  bool get isBusy => _isBusy;
  set isBusy(bool value) {
    _isBusy = value;
    setStateIfMounted();
  }

  @override
  Widget build(BuildContext context) {
    return PositiveGenericPage(
      title: 'Thats it!',
      body: 'That wasn\'t too bad, was it? Now you can get access to the full Positive+1 experience. Feel free to dive in!',
      buttonText: 'Let\'s Go!',
      style: PositiveGenericPageStyle.decorated,
      isBusy: isBusy,
      canBack: false,
      onContinueSelected: () => onContinueSelected(context, ref),
    );
  }

  Future<void> onContinueSelected(BuildContext context, WidgetRef ref) async {
    isBusy = true;

    try {
      final AppRouter appRouter = ref.read(appRouterProvider);
      final AnalyticsController analyticsController = ref.read(analyticsControllerProvider.notifier);
      final GetStreamController getStreamController = ref.read(getStreamControllerProvider.notifier);

      await getStreamController.disconnectStreamUser();
      await getStreamController.connectStreamUser();

      await analyticsController.trackEvent(AnalyticEvents.registrationComplete);
      await appRouter.push(const HomeRoute());
    } finally {
      isBusy = false;
    }
  }
}
