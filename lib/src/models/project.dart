import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'project.g.dart';

@JsonSerializable()
@CopyWith()
@immutable
class Project extends Equatable {
  const Project({required this.id, required this.name});

  factory Project.fromJson(Map<String, Object?> json) =>
      _$ProjectFromJson(json);

  final String id;

  final String name;

  @override
  List<Object?> get props => <Object?>[id, name];

  Map<String, Object?> toJson() => _$ProjectToJson(this);
}
