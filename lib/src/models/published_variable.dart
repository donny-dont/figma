import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import 'variable_resolved_data_type.dart';

part 'published_variable.g.dart';

@JsonSerializable()
@CopyWith()
@immutable
class PublishedVariable extends Equatable {
  const PublishedVariable({
    required this.id,
    required this.subscribedId,
    required this.name,
    required this.key,
    required this.variableCollectionId,
    required this.resolvedDataType,
    required this.updatedAt,
  });

  factory PublishedVariable.fromJson(Map<String, Object?> json) =>
      _$PublishedVariableFromJson(json);

  final String id;

  @JsonKey(name: 'subscribed_id')
  final String subscribedId;

  final String name;

  final String key;

  final String variableCollectionId;

  final VariableResolvedDataType resolvedDataType;

  final DateTime updatedAt;

  @override
  List<Object?> get props => <Object?>[
    id,
    subscribedId,
    name,
    key,
    variableCollectionId,
    resolvedDataType,
    updatedAt,
  ];

  Map<String, Object?> toJson() => _$PublishedVariableToJson(this);
}
