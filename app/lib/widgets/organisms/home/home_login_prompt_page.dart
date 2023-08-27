import 'package:app/gen/app_router.dart';
import 'package:app/widgets/organisms/shared/positive_generic_page.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class HomeLoginPromptPage extends ConsumerWidget {
  const HomeLoginPromptPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppRouter appRouter = ref.read(appRouterProvider);

    return PositiveGenericPage(
      title: 'Thanks for showing an interest in Positive+1',
      body: 'To be able to create content, view profiles and connect with people you\'ll need to sign in or register for an account.',
      buttonText: 'Sign In / Register',
      isBusy: false,
      style: PositiveGenericPageStyle.imaged,
      onContinueSelected: () => appRouter.push(LoginRoute(senderRoute: HomeRoute)),
    );
  }
}
