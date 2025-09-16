import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import '../models.dart';

part 'versions_response.g.dart';

/// A response object containing a list of versions.
@JsonSerializable()
@CopyWith()
@immutable
class VersionsResponse extends Equatable {
  const VersionsResponse({required this.versions, required this.pagination});

  factory VersionsResponse.fromJson(Map<String, dynamic> json) =>
      _$VersionsResponseFromJson(json);

  /// List of versions.
  final List<Version> versions;

  final ResponsePagination pagination;

  @override
  List<Object?> get props => [versions];

  Map<String, dynamic> toJson() => _$VersionsResponseToJson(this);
}
