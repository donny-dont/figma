import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import 'variable_alias.dart';

part 'individual_stroke_weights_variables.g.dart';

@JsonSerializable(explicitToJson: true)
@CopyWith()
@immutable
class IndividualStrokeWeightsVariables extends Equatable {
  const IndividualStrokeWeightsVariables({
    this.top,
    this.bottom,
    this.left,
    this.right,
  });

  factory IndividualStrokeWeightsVariables.fromJson(
    Map<String, Object?> json,
  ) => _$IndividualStrokeWeightsVariablesFromJson(json);

  final VariableAlias? top;

  final VariableAlias? bottom;

  final VariableAlias? left;

  final VariableAlias? right;

  @override
  List<Object?> get props => <Object?>[top, bottom, left, right];

  Map<String, Object?> toJson() =>
      _$IndividualStrokeWeightsVariablesToJson(this);
}
