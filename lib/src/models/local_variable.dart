import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import 'variable_code_syntax.dart';
import 'variable_resolved_data_type.dart';
import 'variable_scope.dart';
import 'variable_value.dart';

part 'local_variable.g.dart';

@JsonSerializable()
@CopyWith()
@immutable
class LocalVariable extends Equatable {
  const LocalVariable({
    required this.id,
    required this.name,
    required this.key,
    required this.variableCollectionId,
    required this.resolvedType,
    required this.valuesByMode,
    required this.remote,
    required this.description,
    required this.hiddenFromPublishing,
    required this.scopes,
    required this.codeSyntax,
    this.deletedButReferenced = false,
  });

  factory LocalVariable.fromJson(Map<String, Object?> json) =>
      _$LocalVariableFromJson(json);

  final String id;

  final String name;

  final String key;

  final String variableCollectionId;

  final VariableResolvedDataType resolvedType;

  @VariableValueMapConverter()
  final Map<String, VariableValue> valuesByMode;

  final bool remote;

  final String description;

  final bool hiddenFromPublishing;

  final List<VariableScope> scopes;

  final VariableCodeSyntax codeSyntax;

  @JsonKey(defaultValue: false)
  final bool deletedButReferenced;

  @override
  List<Object?> get props => <Object?>[
    id,
    name,
    key,
    variableCollectionId,
    resolvedType,
    valuesByMode,
    remote,
    description,
    hiddenFromPublishing,
    scopes,
    codeSyntax,
    deletedButReferenced,
  ];

  Map<String, Object?> toJson() => _$LocalVariableToJson(this);
}
