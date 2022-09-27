// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:async_redux/async_redux.dart';

// Project imports:
import 'package:ppoa/business/state/app_state.dart';
import 'package:ppoa/client/splash/splash_factory.dart';
import 'package:ppoa/client/splash/splash_page.dart';
import 'package:ppoa/client/splash/splash_view_model.dart';

class SplashConnector extends StatelessWidget {
  const SplashConnector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, SplashViewModel>(
      vm: () => SplashFactory(),
      builder: (BuildContext context, SplashViewModel vm) => SplashPage(viewModel: vm),
    );
  }
}
