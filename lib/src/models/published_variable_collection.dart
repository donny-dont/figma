import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'published_variable_collection.g.dart';

@JsonSerializable()
@CopyWith()
@immutable
class PublishedVariableCollection extends Equatable {
  const PublishedVariableCollection({
    required this.id,
    required this.subscribedId,
    required this.name,
    required this.key,
    required this.updatedAt,
  });

  factory PublishedVariableCollection.fromJson(Map<String, Object?> json) =>
      _$PublishedVariableCollectionFromJson(json);

  final String id;

  @JsonKey(name: 'subscribed_id')
  final String subscribedId;

  final String name;

  final String key;

  final DateTime updatedAt;

  @override
  List<Object?> get props => <Object?>[id, subscribedId, name, key, updatedAt];

  Map<String, Object?> toJson() => _$PublishedVariableCollectionToJson(this);
}
