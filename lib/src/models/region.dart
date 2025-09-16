import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import 'comment_pin_corner.dart';

part 'region.g.dart';

@JsonSerializable()
@CopyWith()
@immutable
class Region extends Equatable {
  const Region({
    required this.x,
    required this.y,
    required this.regionHeight,
    required this.regionWidth,
    this.commentPinCorner = CommentPinCorner.bottomRight,
  });

  factory Region.fromJson(Map<String, Object?> json) => _$RegionFromJson(json);

  final num x;

  final num y;

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
    x,
    y,
    regionHeight,
    regionWidth,
    commentPinCorner,
  ];

  Map<String, Object?> toJson() => _$RegionToJson(this);
}
