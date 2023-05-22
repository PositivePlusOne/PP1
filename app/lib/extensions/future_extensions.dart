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

// Run a future with a backoff, so that if it is called multiple times in a short period of time, it will only execute once
Future<T?> runWithBackoff<T>(Ref ref, Future<T?> Function() future, {String key = '', bool rethrowError = true}) async {
  final Logger log = ref.read(loggerProvider);

  try {
    return await runWithMutex(future, key: key, rethrowError: rethrowError);
  } catch (ex) {
    log.e('Failed to execute future, $ex');
    if (rethrowError) {
      rethrow;
    }

    return null;
  }
}

// Run a future with a mutex lock, so that only one future can be executed at a time
Future<T?> runWithMutex<T>(Future<T?> Function() future, {String key = '', bool rethrowError = true}) async {
  final Lock lock = _locks.putIfAbsent(key, () => Lock());
  final Logger log = providerContainer.read(loggerProvider);

  try {
    return await lock.synchronized(future);
  } catch (ex) {
    log.e('Failed to execute future, $ex');
    if (rethrowError) {
      rethrow;
    }

    return null;
  }
}
