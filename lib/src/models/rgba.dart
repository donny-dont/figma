import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'rgba.g.dart';

@JsonSerializable()
@CopyWith()
@immutable
class Rgba extends Equatable {
  const Rgba({
    required this.r,
    required this.g,
    required this.b,
    required this.a,
  });

  factory Rgba.fromJson(Map<String, Object?> json) => _$RgbaFromJson(json);

  final num r;

  final num g;

  final num b;

  final num a;

  @override
  List<Object?> get props => <Object?>[r, g, b, a];

  Map<String, Object?> toJson() => _$RgbaToJson(this);
}
