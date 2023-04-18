// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:synchronized/synchronized.dart';

// Project imports:
import 'package:app/main.dart';
import '../services/third_party.dart';

final Map<String, Lock> _locks = {};

// TODO(ryan): Rename to helpers

Future<T?> failSilently<T>(Ref ref, Future<T?> Function() future) async {
  final Logger log = ref.read(loggerProvider);

  try {
    return await future();
  } catch (ex) {
    log.e('Failed to execute future, $ex');
    return null;
  }
}

Future<T?> runWithMutex<T>(Future<T?> Function() future, {String key = ''}) async {
  final Lock lock = _locks.putIfAbsent(key, () => Lock());
  final Logger log = providerContainer.read(loggerProvider);

  try {
    return await lock.synchronized(future);
  } catch (ex) {
    log.e('Failed to execute future, $ex');
    return null;
  }
}
