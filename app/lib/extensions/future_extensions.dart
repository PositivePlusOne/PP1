// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

// Project imports:
import '../services/third_party.dart';

extension FutureExtensions on Future<dynamic> {
  Future<T?> failSilently<T>(Ref ref) async {
    final Logger log = ref.read(loggerProvider);

    return await catchError((ex) {
      log.e('[FutureExtensions] failSilently() failed', ex);
      return Future<T>.value(null);
    });
  }
}
