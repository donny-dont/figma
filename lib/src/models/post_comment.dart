import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import 'client_meta.dart';

part 'post_comment.g.dart';

@JsonSerializable()
@CopyWith()
@immutable
class PostComment extends Equatable {
  const PostComment({required this.message, this.commentId, this.clientMeta});

  factory PostComment.fromJson(Map<String, Object?> json) =>
      _$PostCommentFromJson(json);

  final String message;

  @JsonKey(name: 'comment_id')
  final String? commentId;

  @JsonKey(name: 'client_meta')
  final ClientMeta? clientMeta;

  @override
  List<Object?> get props => <Object?>[message, commentId, clientMeta];

  Map<String, Object?> toJson() => _$PostCommentToJson(this);
}
