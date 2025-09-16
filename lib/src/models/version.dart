import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import 'user.dart';

part 'version.g.dart';

@JsonSerializable()
@CopyWith()
@immutable
class Version extends Equatable {
  const Version({
    required this.id,
    required this.createdAt,
    this.label,
    this.description,
    required this.user,
    this.thumbnailUrl,
  });

  factory Version.fromJson(Map<String, Object?> json) =>
      _$VersionFromJson(json);

  final String id;

  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  final String? label;

  final String? description;

  final User user;

  @JsonKey(name: 'thumbnail_url')
  final String? thumbnailUrl;

  @override
  List<Object?> get props => <Object?>[
    id,
    createdAt,
    label,
    description,
    user,
    thumbnailUrl,
  ];

  Map<String, Object?> toJson() => _$VersionToJson(this);
}
