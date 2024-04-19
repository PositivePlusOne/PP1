// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$searchViewModelHash() => r'bd1cde7e44f060341aff33b9bb92d97cc96be33f';

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

abstract class _$SearchViewModel
    extends BuildlessNotifier<SearchViewModelState> {
  late final SearchTab tab;

  SearchViewModelState build(
    SearchTab tab,
  );
}

/// See also [SearchViewModel].
@ProviderFor(SearchViewModel)
const searchViewModelProvider = SearchViewModelFamily();

/// See also [SearchViewModel].
class SearchViewModelFamily extends Family<SearchViewModelState> {
  /// See also [SearchViewModel].
  const SearchViewModelFamily();

  /// See also [SearchViewModel].
  SearchViewModelProvider call(
    SearchTab tab,
  ) {
    return SearchViewModelProvider(
      tab,
    );
  }

  @override
  SearchViewModelProvider getProviderOverride(
    covariant SearchViewModelProvider provider,
  ) {
    return call(
      provider.tab,
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
  String? get name => r'searchViewModelProvider';
}

/// See also [SearchViewModel].
class SearchViewModelProvider
    extends NotifierProviderImpl<SearchViewModel, SearchViewModelState> {
  /// See also [SearchViewModel].
  SearchViewModelProvider(
    SearchTab tab,
  ) : this._internal(
          () => SearchViewModel()..tab = tab,
          from: searchViewModelProvider,
          name: r'searchViewModelProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$searchViewModelHash,
          dependencies: SearchViewModelFamily._dependencies,
          allTransitiveDependencies:
              SearchViewModelFamily._allTransitiveDependencies,
          tab: tab,
        );

  SearchViewModelProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.tab,
  }) : super.internal();

  final SearchTab tab;

  @override
  SearchViewModelState runNotifierBuild(
    covariant SearchViewModel notifier,
  ) {
    return notifier.build(
      tab,
    );
  }

  @override
  Override overrideWith(SearchViewModel Function() create) {
    return ProviderOverride(
      origin: this,
      override: SearchViewModelProvider._internal(
        () => create()..tab = tab,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        tab: tab,
      ),
    );
  }

  @override
  NotifierProviderElement<SearchViewModel, SearchViewModelState>
      createElement() {
    return _SearchViewModelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SearchViewModelProvider && other.tab == tab;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, tab.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SearchViewModelRef on NotifierProviderRef<SearchViewModelState> {
  /// The parameter `tab` of this provider.
  SearchTab get tab;
}

class _SearchViewModelProviderElement
    extends NotifierProviderElement<SearchViewModel, SearchViewModelState>
    with SearchViewModelRef {
  _SearchViewModelProviderElement(super.provider);

  @override
  SearchTab get tab => (origin as SearchViewModelProvider).tab;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
