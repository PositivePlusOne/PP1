// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_form_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$accountFormControllerHash() =>
    r'f92ad3de7cfd9553037be2058d0b55c65a9127ee';

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

abstract class _$AccountFormController
    extends BuildlessNotifier<AccountFormState> {
  late final Locale locale;

  AccountFormState build(
    Locale locale,
  );
}

/// See also [AccountFormController].
@ProviderFor(AccountFormController)
const accountFormControllerProvider = AccountFormControllerFamily();

/// See also [AccountFormController].
class AccountFormControllerFamily extends Family<AccountFormState> {
  /// See also [AccountFormController].
  const AccountFormControllerFamily();

  /// See also [AccountFormController].
  AccountFormControllerProvider call(
    Locale locale,
  ) {
    return AccountFormControllerProvider(
      locale,
    );
  }

  @override
  AccountFormControllerProvider getProviderOverride(
    covariant AccountFormControllerProvider provider,
  ) {
    return call(
      provider.locale,
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
  String? get name => r'accountFormControllerProvider';
}

/// See also [AccountFormController].
class AccountFormControllerProvider
    extends NotifierProviderImpl<AccountFormController, AccountFormState> {
  /// See also [AccountFormController].
  AccountFormControllerProvider(
    Locale locale,
  ) : this._internal(
          () => AccountFormController()..locale = locale,
          from: accountFormControllerProvider,
          name: r'accountFormControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$accountFormControllerHash,
          dependencies: AccountFormControllerFamily._dependencies,
          allTransitiveDependencies:
              AccountFormControllerFamily._allTransitiveDependencies,
          locale: locale,
        );

  AccountFormControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.locale,
  }) : super.internal();

  final Locale locale;

  @override
  AccountFormState runNotifierBuild(
    covariant AccountFormController notifier,
  ) {
    return notifier.build(
      locale,
    );
  }

  @override
  Override overrideWith(AccountFormController Function() create) {
    return ProviderOverride(
      origin: this,
      override: AccountFormControllerProvider._internal(
        () => create()..locale = locale,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        locale: locale,
      ),
    );
  }

  @override
  NotifierProviderElement<AccountFormController, AccountFormState>
      createElement() {
    return _AccountFormControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AccountFormControllerProvider && other.locale == locale;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, locale.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin AccountFormControllerRef on NotifierProviderRef<AccountFormState> {
  /// The parameter `locale` of this provider.
  Locale get locale;
}

class _AccountFormControllerProviderElement
    extends NotifierProviderElement<AccountFormController, AccountFormState>
    with AccountFormControllerRef {
  _AccountFormControllerProviderElement(super.provider);

  @override
  Locale get locale => (origin as AccountFormControllerProvider).locale;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
