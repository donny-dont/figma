// Generated from v0.33.0 of the Figma REST API specification

import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'get_dev_resources.g.dart';

/// Get dev resources in a file.
@JsonSerializable()
@CopyWith()
@immutable
class GetDevResources extends Equatable {
  const GetDevResources({this.nodeIds});

  factory GetDevResources.fromJson(Map<String, Object?> json) =>
      _$GetDevResourcesFromJson(json);

  /// Comma separated list of nodes that you care about in the document.
  ///
  /// If specified, only dev resources attached to these nodes will be returned.
  /// If not specified, all dev resources in the file will be returned.
  @JsonKey(name: 'node_ids', includeIfNull: false)
  final String? nodeIds;

  @override
  List<Object?> get props => <Object?>[nodeIds];

  Map<String, Object?> toJson() => _$GetDevResourcesToJson(this);
}
