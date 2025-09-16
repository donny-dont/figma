import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import '../models.dart';

part 'style_response.g.dart';

/// A response object containing a [Style] object.
@JsonSerializable()
@CopyWith()
@immutable
class StyleResponse extends Equatable {
  /// Status code.
  final int? status;

  /// If the operation ended in error.
  final bool? error;

  /// Requested [Style] object.
  @JsonKey(name: 'meta')
  final PublishedStyle style;

  const StyleResponse({
    required this.status,
    required this.error,
    required this.style,
  });

  @override
  List<Object?> get props => [status, error, style];

  factory StyleResponse.fromJson(Map<String, dynamic> json) =>
      _$StyleResponseFromJson(json);

  Map<String, dynamic> toJson() => _$StyleResponseToJson(this);
}
