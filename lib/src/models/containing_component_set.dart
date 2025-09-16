import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'containing_component_set.g.dart';

@JsonSerializable()
@CopyWith()
@immutable
class ContainingComponentSet extends Equatable {
  const ContainingComponentSet({this.nodeId, this.name});

  factory ContainingComponentSet.fromJson(Map<String, Object?> json) =>
      _$ContainingComponentSetFromJson(json);

  final String? nodeId;

  final String? name;

  @override
  List<Object?> get props => <Object?>[nodeId, name];

  Map<String, Object?> toJson() => _$ContainingComponentSetToJson(this);
}
