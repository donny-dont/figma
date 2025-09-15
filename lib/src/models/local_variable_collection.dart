import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import 'mode.dart';

part 'local_variable_collection.g.dart';

@JsonSerializable()
@CopyWith()
@immutable
class LocalVariableCollection extends Equatable {
  const LocalVariableCollection({
    required this.id,
    required this.name,
    required this.key,
    required this.modes,
    required this.defaultModeId,
    required this.remote,
    required this.hiddenFromPublishing,
    required this.variableIds,
  });

  factory LocalVariableCollection.fromJson(Map<String, Object?> json) =>
      _$LocalVariableCollectionFromJson(json);

  final String id;

  final String name;

  final String key;

  final List<Mode> modes;

  final String defaultModeId;

  final bool remote;

  final bool hiddenFromPublishing;

  final List<String> variableIds;

  @override
  List<Object?> get props => <Object?>[
    id,
    name,
    key,
    modes,
    defaultModeId,
    remote,
    hiddenFromPublishing,
    variableIds,
  ];

  Map<String, Object?> toJson() => _$LocalVariableCollectionToJson(this);
}
