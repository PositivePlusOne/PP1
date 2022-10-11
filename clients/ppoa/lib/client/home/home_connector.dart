// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:async_redux/async_redux.dart';

// Project imports:
import 'package:ppoa/business/state/app_state.dart';
import 'package:ppoa/client/home/home_factory.dart';
import 'package:ppoa/client/home/home_page.dart';
import 'package:ppoa/client/home/home_view_model.dart';

class HomeConnector extends StatelessWidget {
  const HomeConnector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, HomeViewModel>(
      vm: () => HomeFactory(),
      builder: (BuildContext context, HomeViewModel vm) => HomePage(viewModel: vm),
    );
  }
}
