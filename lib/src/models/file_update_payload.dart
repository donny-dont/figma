import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import 'webhook_event.dart';

part 'file_update_payload.g.dart';

@JsonSerializable(explicitToJson: true)
@CopyWith()
@immutable
class FileUpdatePayload extends Equatable {
  const FileUpdatePayload({
    required this.eventType,
    required this.fileKey,
    required this.fileName,
  });

  factory FileUpdatePayload.fromJson(Map<String, Object?> json) =>
      _$FileUpdatePayloadFromJson(json);

  @JsonKey(name: 'event_type')
  final WebhookEvent eventType;

  /// The key of the file that was updated
  @JsonKey(name: 'file_key')
  final String fileKey;

  /// The name of the file that was updated
  @JsonKey(name: 'file_name')
  final String fileName;

  @override
  List<Object?> get props => <Object?>[eventType, fileKey, fileName];

  Map<String, Object?> toJson() => _$FileUpdatePayloadToJson(this);
}
