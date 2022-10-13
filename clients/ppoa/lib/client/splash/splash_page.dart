// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:ppoa/business/services/service_mixin.dart';
import 'splash_keys.dart';

class SplashPage extends HookConsumerWidget with ServiceMixin {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      key: kPageSplashScaffoldKey,
      appBar: AppBar(
        title: const Text('Splash page'),
      ),
    );
  }
}
