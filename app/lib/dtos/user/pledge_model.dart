// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

part 'pledge_model.freezed.dart';
part 'pledge_model.g.dart';

enum PledgeOwner {
  user,
  company,
}

/// A model that represents a pledge.
/// The pledge covers what the company and the user have agreed to before using the app.
@freezed
class PledgeModel with _$PledgeModel {
  const factory PledgeModel({
    required PledgeOwner owner,
    required List<String> affirmations,
    required int version,
    required bool hasAccepted,
  }) = _PledgeModel;

  factory PledgeModel.fromJson(Map<String, Object?> json) => _$PledgeModelFromJson(json);
}
