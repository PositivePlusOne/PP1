// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

// Project imports:
import '../services/third_party.dart';

extension FutureExtensions on Future<dynamic> {
  Future<void> failSilently(Ref ref) async {
    final Logger log = ref.read(loggerProvider);

    try {
      await this;
    } catch (ex) {
      log.e('[FutureExtensions] failSilently() failed', ex);
    }
  }
}
