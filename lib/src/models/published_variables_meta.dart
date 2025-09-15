import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import 'published_variable.dart';
import 'published_variable_collection.dart';

part 'published_variables_meta.g.dart';

@JsonSerializable()
@CopyWith()
@immutable
class PublishedVariablesMeta extends Equatable {
  const PublishedVariablesMeta({
    required this.variables,
    required this.variableCollections,
  });

  factory PublishedVariablesMeta.fromJson(Map<String, Object?> json) =>
      _$PublishedVariablesMetaFromJson(json);

  final Map<String, PublishedVariable> variables;

  final Map<String, PublishedVariableCollection> variableCollections;

  @override
  List<Object?> get props => <Object?>[variables, variableCollections];

  Map<String, Object?> toJson() => _$PublishedVariablesMetaToJson(this);
}
