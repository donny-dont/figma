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
  /// List of versions.
  final List<Version> versions;

  final ResponsePagination pagination;

  const VersionsResponse({required this.versions, required this.pagination});

  @override
  List<Object?> get props => [versions];

  factory VersionsResponse.fromJson(Map<String, dynamic> json) =>
      _$VersionsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$VersionsResponseToJson(this);
}
