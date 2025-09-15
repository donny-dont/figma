import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'user.g.dart';

@JsonSerializable()
@CopyWith()
@immutable
class User extends Equatable {
  const User({required this.id, required this.handle, required this.imgUrl});

  factory User.fromJson(Map<String, Object?> json) => _$UserFromJson(json);

  final String id;

  final String handle;

  @JsonKey(name: 'img_url')
  final String imgUrl;

  @override
  List<Object?> get props => <Object?>[id, handle, imgUrl];

  Map<String, Object?> toJson() => _$UserToJson(this);
}
