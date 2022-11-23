// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ppoa/business/hooks/lifecycle_hook.dart';

// Project imports:
import 'package:ppoa/business/services/service_mixin.dart';
import 'splash_keys.dart';
import 'splash_lifecycle.dart';

class SplashPage extends HookConsumerWidget with ServiceMixin, LifecycleMixin {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useLifecycleHook(SplashLifecycle());

    final Color primaryColor = ref.watch(stateProvider.select((value) => value.designSystem.brand.colors.primaryColor));
    return Scaffold(
      key: kPageSplashScaffoldKey,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text('Splash page'),
      ),
    );
  }
}
