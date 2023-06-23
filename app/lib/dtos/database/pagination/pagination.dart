import 'package:freezed_annotation/freezed_annotation.dart';

part 'pagination.g.dart';
part 'pagination.freezed.dart';

@freezed
class Pagination with _$Pagination {
  const factory Pagination({
    int? limit,
    String? cursor,
  }) = _Pagination;

  factory Pagination.fromJson(Map<String, dynamic> json) => _$PaginationFromJson(json);
}
