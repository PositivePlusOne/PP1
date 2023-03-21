// Package imports:
import 'package:hive_flutter/adapters.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import '../dtos/database/user/user_profile.dart';

part 'repositories.g.dart';

typedef Repository<T> = Box<T>;

@Riverpod(keepAlive: true)
FutureOr<Box<UserProfile>> userProfileRepository(UserProfileRepositoryRef ref) async {
  await Hive.initFlutter();
  return await Hive.openBox((UserProfile).toString());
}

extension BoxExtensions<T> on Box<T> {
  dynamic getBoxKey(T item) {
    switch (item.runtimeType) {
      case UserProfile:
        return (item as UserProfile).id;
      default:
        return item.hashCode;
    }
  }
}
