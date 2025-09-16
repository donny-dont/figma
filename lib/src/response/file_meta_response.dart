import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import '../models.dart';

part 'file_meta_response.g.dart';

/// A response object containing a file's metadata.
@JsonSerializable()
@CopyWith()
@immutable
class FileMetaResponse extends Equatable {
  const FileMetaResponse({required this.file});

  factory FileMetaResponse.fromJson(Map<String, dynamic> json) =>
      _$FileMetaResponseFromJson(json);

  /// The file's metadata.
  final FileMeta file;

  @override
  List<Object?> get props => [file];

  Map<String, dynamic> toJson() => _$FileMetaResponseToJson(this);
}
