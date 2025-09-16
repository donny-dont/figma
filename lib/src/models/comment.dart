import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import 'client_meta.dart';
import 'reaction.dart';
import 'user.dart';

part 'comment.g.dart';

@JsonSerializable()
@CopyWith()
@immutable
class Comment extends Equatable {
  const Comment({
    required this.id,
    this.clientMeta,
    required this.fileKey,
    this.parentId,
    required this.user,
    required this.createdAt,
    this.resolvedAt,
    required this.message,
    this.orderId,
    required this.reactions,
  });

  factory Comment.fromJson(Map<String, Object?> json) =>
      _$CommentFromJson(json);

  final String id;

  @ClientMetaNullableConverter()
  @JsonKey(name: 'client_meta')
  final ClientMeta? clientMeta;

  @JsonKey(name: 'file_key')
  final String fileKey;

  @JsonKey(name: 'parent_id')
  final String? parentId;

  final User user;

  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @JsonKey(name: 'resolved_at')
  final DateTime? resolvedAt;

  final String message;

  @JsonKey(name: 'order_id')
  final String? orderId;

  final List<Reaction> reactions;

  @override
  List<Object?> get props => <Object?>[
    id,
    clientMeta,
    fileKey,
    parentId,
    user,
    createdAt,
    resolvedAt,
    message,
    orderId,
    reactions,
  ];

  Map<String, Object?> toJson() => _$CommentToJson(this);
}
