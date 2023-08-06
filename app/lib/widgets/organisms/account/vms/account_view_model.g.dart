// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$accountViewModelHash() => r'e2e2b1e418c874c2a7bd5b34cd8a828350da1b48';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$AccountViewModel
    extends BuildlessAutoDisposeNotifier<AccountViewModelState> {
  late final FeedbackType feedbackType;

  AccountViewModelState build(
    FeedbackType feedbackType,
  );
}

/// See also [AccountViewModel].
@ProviderFor(AccountViewModel)
const accountViewModelProvider = AccountViewModelFamily();

/// See also [AccountViewModel].
class AccountViewModelFamily extends Family<AccountViewModelState> {
  /// See also [AccountViewModel].
  const AccountViewModelFamily();

  /// See also [AccountViewModel].
  AccountViewModelProvider call(
    FeedbackType feedbackType,
  ) {
    return AccountViewModelProvider(
      feedbackType,
    );
  }

  @override
  AccountViewModelProvider getProviderOverride(
    covariant AccountViewModelProvider provider,
  ) {
    return call(
      provider.feedbackType,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'accountViewModelProvider';
}

/// See also [AccountViewModel].
class AccountViewModelProvider extends AutoDisposeNotifierProviderImpl<
    AccountViewModel, AccountViewModelState> {
  /// See also [AccountViewModel].
  AccountViewModelProvider(
    this.feedbackType,
  ) : super.internal(
          () => AccountViewModel()..feedbackType = feedbackType,
          from: accountViewModelProvider,
          name: r'accountViewModelProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$accountViewModelHash,
          dependencies: AccountViewModelFamily._dependencies,
          allTransitiveDependencies:
              AccountViewModelFamily._allTransitiveDependencies,
        );

  final FeedbackType feedbackType;

  @override
  bool operator ==(Object other) {
    return other is AccountViewModelProvider &&
        other.feedbackType == feedbackType;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, feedbackType.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  AccountViewModelState runNotifierBuild(
    covariant AccountViewModel notifier,
  ) {
    return notifier.build(
      feedbackType,
    );
  }
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member
