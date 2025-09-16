import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import '../models.dart';

part 'published_variables_response.g.dart';

/// A response object containing a list of styles.
@JsonSerializable()
@CopyWith()
@immutable
class PublishedVariablesResponse extends Equatable {
  const PublishedVariablesResponse({
    required this.status,
    required this.error,
    required this.meta,
  });

  factory PublishedVariablesResponse.fromJson(Map<String, dynamic> json) =>
      _$PublishedVariablesResponseFromJson(json);

  /// Status code.
  final int status;

  /// If the operation ended in error.
  final bool error;

  /// Contains the collection of [PublishedVariable] and
  /// [PublishedVariableCollection].
  final PublishedVariablesMeta meta;

  @override
  List<Object?> get props => [status, error, meta];

  Map<String, dynamic> toJson() => _$PublishedVariablesResponseToJson(this);
}
