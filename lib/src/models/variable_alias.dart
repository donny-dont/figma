import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'variable_alias.g.dart';

@JsonSerializable()
@CopyWith()
@immutable
class VariableAlias extends Equatable {
  const VariableAlias({required this.id});

  factory VariableAlias.fromJson(Map<String, Object?> json) =>
      _$VariableAliasFromJson(json);

  final String id;

  @override
  List<Object?> get props => <Object?>[id];

  Map<String, Object?> toJson() => _$VariableAliasToJson(this);
}
