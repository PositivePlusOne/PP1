// Package imports:
import 'package:logger/logger.dart';

// Project imports:
import 'package:app/main.dart';
import 'package:app/services/third_party.dart';

mixin BusyStateDelegateMixin {
  void updateBusyState(bool isBusy);

  Future<void> performActionWhileBusy(Future<void> Function() action) async {
    final Logger logger = providerContainer.read(loggerProvider);

    logger.d('performActionWhileBusy()');
    updateBusyState(true);
    try {
      await action();
    } finally {
      updateBusyState(false);
    }
  }
}
