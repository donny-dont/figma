// Generated from v0.33.0 of the Figma REST API specification

import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import 'dev_resource.dart';

part 'dev_resources_response.g.dart';

@JsonSerializable(explicitToJson: true)
@CopyWith()
@immutable
class DevResourcesResponse extends Equatable {
  const DevResourcesResponse({required this.devResources});

  factory DevResourcesResponse.fromJson(Map<String, Object?> json) =>
      _$DevResourcesResponseFromJson(json);

  /// An array of dev resources.
  @JsonKey(name: 'dev_resources')
  final List<DevResource> devResources;

  @override
  List<Object?> get props => <Object?>[devResources];

  Map<String, Object?> toJson() => _$DevResourcesResponseToJson(this);
}
