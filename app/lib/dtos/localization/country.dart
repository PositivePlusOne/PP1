// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

part 'country.freezed.dart';

@freezed
class Country with _$Country {
  const factory Country({
    required String isoCode,
    required String iso3Code,
    required String phoneCode,
    required String name,
  }) = _Country;
}
