// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

part 'fl_relationship.freezed.dart';
part 'fl_relationship.g.dart';

@freezed
class FlRelationship with _$FlRelationship {
  const factory FlRelationship({
    @Default(false) bool blocked,
    @Default(false) bool muted,
    @Default(false) bool connected,
    @Default(false) bool following,
    @Default(false) bool hidden,
  }) = _FlRelationship;

  factory FlRelationship.empty() => const FlRelationship();

  factory FlRelationship.fromJson(Map<String, dynamic> json) => _$FlRelationshipFromJson(json);
}
