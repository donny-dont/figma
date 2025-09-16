import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'project_file.g.dart';

@JsonSerializable()
@CopyWith()
@immutable
class ProjectFile extends Equatable {
  const ProjectFile({
    required this.key,
    required this.name,
    this.thumbnailUrl,
    required this.lastModified,
  });

  factory ProjectFile.fromJson(Map<String, Object?> json) =>
      _$ProjectFileFromJson(json);

  final String key;

  final String name;

  @JsonKey(name: 'thumbnail_url')
  final String? thumbnailUrl;

  @JsonKey(name: 'last_modified')
  final DateTime lastModified;

  @override
  List<Object?> get props => <Object?>[key, name, thumbnailUrl, lastModified];

  Map<String, Object?> toJson() => _$ProjectFileToJson(this);
}
