// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:ppoa/client/splash/splash_view_model.dart';
import 'splash_keys.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  final SplashViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: kPageSplashScaffoldKey,
      appBar: AppBar(
        title: const Text('Splash'),
      ),
    );
  }
}
