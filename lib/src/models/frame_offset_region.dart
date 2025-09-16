import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import 'comment_pin_corner.dart';
import 'vector.dart';

part 'frame_offset_region.g.dart';

@JsonSerializable()
@CopyWith()
@immutable
class FrameOffsetRegion extends Equatable {
  const FrameOffsetRegion({
    required this.nodeId,
    required this.nodeOffset,
    required this.regionHeight,
    required this.regionWidth,
    this.commentPinCorner = CommentPinCorner.bottomRight,
  });

  factory FrameOffsetRegion.fromJson(Map<String, Object?> json) =>
      _$FrameOffsetRegionFromJson(json);

  @JsonKey(name: 'node_id')
  final String nodeId;

  @JsonKey(name: 'node_offset')
  final Vector nodeOffset;

  @JsonKey(name: 'region_height')
  final num regionHeight;

  @JsonKey(name: 'region_width')
  final num regionWidth;

  @JsonKey(
    name: 'comment_pin_corner',
    defaultValue: CommentPinCorner.bottomRight,
  )
  final CommentPinCorner commentPinCorner;

  @override
  List<Object?> get props => <Object?>[
    nodeId,
    nodeOffset,
    regionHeight,
    regionWidth,
    commentPinCorner,
  ];

  Map<String, Object?> toJson() => _$FrameOffsetRegionToJson(this);
}
