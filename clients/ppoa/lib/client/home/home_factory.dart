// Package imports:
import 'package:async_redux/async_redux.dart';

// Project imports:
import 'package:ppoa/business/state/app_state.dart';
import 'package:ppoa/client/home/home_connector.dart';
import 'package:ppoa/client/home/home_view_model.dart';

class HomeFactory extends VmFactory<AppState, HomeConnector> {
  @override
  Vm? fromStore() {
    return HomeViewModel();
  }
}
