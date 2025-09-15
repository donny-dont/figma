import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'rgb.g.dart';

@JsonSerializable()
@CopyWith()
@immutable
class Rgb extends Equatable {
  const Rgb({required this.r, required this.g, required this.b});

  factory Rgb.fromJson(Map<String, Object?> json) => _$RgbFromJson(json);

  final num r;

  final num g;

  final num b;

  @override
  List<Object?> get props => <Object?>[r, g, b];

  Map<String, Object?> toJson() => _$RgbToJson(this);
}
