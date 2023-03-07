// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

// Project imports:
import '../services/third_party.dart';

Future<T?> failSilently<T>(Ref ref, Future<T?> Function() future) async {
  final Logger log = ref.read(loggerProvider);

  try {
    return await future();
  } catch (ex) {
    log.e('Failed to execute future, $ex');
    return null;
  }
}
