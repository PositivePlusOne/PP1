// Package imports:
import 'package:async_redux/async_redux.dart';

// Project imports:
import 'package:ppoa/business/state/app_state.dart';
import 'package:ppoa/client/splash/splash_connector.dart';
import 'package:ppoa/client/splash/splash_view_model.dart';

class SplashFactory extends VmFactory<AppState, SplashConnector> {
  @override
  Vm? fromStore() {
    return SplashViewModel();
  }
}
