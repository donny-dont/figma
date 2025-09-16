import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import 'style_type.dart';
import 'user.dart';

part 'published_style.g.dart';

@JsonSerializable()
@CopyWith()
@immutable
class PublishedStyle extends Equatable {
  const PublishedStyle({
    required this.key,
    required this.fileKey,
    required this.nodeId,
    required this.styleType,
    this.thumbnailUrl,
    required this.name,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
    required this.sortPosition,
  });

  factory PublishedStyle.fromJson(Map<String, Object?> json) =>
      _$PublishedStyleFromJson(json);

  final String key;

  @JsonKey(name: 'file_key')
  final String fileKey;

  @JsonKey(name: 'node_id')
  final String nodeId;

  @JsonKey(name: 'style_type')
  final StyleType styleType;

  @JsonKey(name: 'thumbnail_url')
  final String? thumbnailUrl;

  final String name;

  final String description;

  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  final User user;

  @JsonKey(name: 'sort_position')
  final String sortPosition;

  @override
  List<Object?> get props => <Object?>[
    key,
    fileKey,
    nodeId,
    styleType,
    thumbnailUrl,
    name,
    description,
    createdAt,
    updatedAt,
    user,
    sortPosition,
  ];

  Map<String, Object?> toJson() => _$PublishedStyleToJson(this);
}
