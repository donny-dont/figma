import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import 'editor_type.dart';
import 'link_access.dart';
import 'role.dart';
import 'user.dart';

part 'file_meta.g.dart';

@JsonSerializable()
@CopyWith()
@immutable
class FileMeta extends Equatable {
  const FileMeta({
    required this.name,
    this.folderName,
    required this.lastTouchedAt,
    required this.creator,
    this.lastTouchedBy,
    this.thumbnailUrl,
    required this.editorType,
    this.role,
    this.linkAccess,
    this.url,
    this.version,
  });

  factory FileMeta.fromJson(Map<String, Object?> json) =>
      _$FileMetaFromJson(json);

  final String name;

  @JsonKey(name: 'folder_name')
  final String? folderName;

  @JsonKey(name: 'last_touched_at')
  final DateTime lastTouchedAt;

  final User creator;

  @JsonKey(name: 'last_touched_by')
  final User? lastTouchedBy;

  @JsonKey(name: 'thumbnail_url')
  final String? thumbnailUrl;

  final EditorType editorType;

  final Role? role;

  @JsonKey(name: 'link_access')
  final LinkAccess? linkAccess;

  final String? url;

  final String? version;

  @override
  List<Object?> get props => <Object?>[
    name,
    folderName,
    lastTouchedAt,
    creator,
    lastTouchedBy,
    thumbnailUrl,
    editorType,
    role,
    linkAccess,
    url,
    version,
  ];

  Map<String, Object?> toJson() => _$FileMetaToJson(this);
}
