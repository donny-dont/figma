import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'vector.g.dart';

@JsonSerializable()
@CopyWith()
@immutable
class Vector extends Equatable {
  const Vector({required this.x, required this.y});

  factory Vector.fromJson(Map<String, Object?> json) => _$VectorFromJson(json);

  final num x;

  final num y;

  @override
  List<Object?> get props => <Object?>[x, y];

  Map<String, Object?> toJson() => _$VectorToJson(this);
}
