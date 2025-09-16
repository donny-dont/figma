import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import '../models.dart';

part 'components_response.g.dart';

/// Response wrapper containing a list of [Component]s from the
/// [Figma API docs](https://www.figma.com/developers/api#components-endpoints).
@JsonSerializable()
@CopyWith()
@immutable
class ComponentsResponse extends Equatable {
  const ComponentsResponse({
    required this.status,
    required this.error,
    required this.meta,
  });

  factory ComponentsResponse.fromJson(Map<String, dynamic> json) =>
      _$ComponentsResponseFromJson(json);

  /// Status code.
  final int status;

  /// If the operation ended in error.
  final bool error;

  /// List of components along with metadata.
  final ComponentsMeta meta;

  @override
  List<Object?> get props => [status, error, meta];

  Map<String, dynamic> toJson() => _$ComponentsResponseToJson(this);
}
