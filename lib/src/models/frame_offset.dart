import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import 'vector.dart';

part 'frame_offset.g.dart';

@JsonSerializable()
@CopyWith()
@immutable
class FrameOffset extends Equatable {
  const FrameOffset({required this.nodeId, required this.nodeOffset});

  factory FrameOffset.fromJson(Map<String, Object?> json) =>
      _$FrameOffsetFromJson(json);

  @JsonKey(name: 'node_id')
  final String nodeId;

  @JsonKey(name: 'node_offset')
  final Vector nodeOffset;

  @override
  List<Object?> get props => <Object?>[nodeId, nodeOffset];

  Map<String, Object?> toJson() => _$FrameOffsetToJson(this);
}
