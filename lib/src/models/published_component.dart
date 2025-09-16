import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import 'frame_info.dart';
import 'user.dart';

part 'published_component.g.dart';

@JsonSerializable()
@CopyWith()
@immutable
class PublishedComponent extends Equatable {
  const PublishedComponent({
    required this.key,
    required this.fileKey,
    required this.nodeId,
    this.thumbnailUrl,
    required this.name,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
    this.containingFrame,
  });

  factory PublishedComponent.fromJson(Map<String, Object?> json) =>
      _$PublishedComponentFromJson(json);

  final String key;

  @JsonKey(name: 'file_key')
  final String fileKey;

  @JsonKey(name: 'node_id')
  final String nodeId;

  @JsonKey(name: 'thumbnail_url')
  final String? thumbnailUrl;

  final String name;

  final String description;

  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  final User user;

  @JsonKey(name: 'containing_frame')
  final FrameInfo? containingFrame;

  @override
  List<Object?> get props => <Object?>[
    key,
    fileKey,
    nodeId,
    thumbnailUrl,
    name,
    description,
    createdAt,
    updatedAt,
    user,
    containingFrame,
  ];

  Map<String, Object?> toJson() => _$PublishedComponentToJson(this);
}
