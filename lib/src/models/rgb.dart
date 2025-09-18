import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'rgb.g.dart';

/// An RGB color
@JsonSerializable()
@CopyWith()
@immutable
class Rgb extends Equatable {
  const Rgb({required this.r, required this.g, required this.b});

  factory Rgb.fromJson(Map<String, Object?> json) => _$RgbFromJson(json);

  /// Red channel value, between 0 and 1.
  final num r;

  /// Green channel value, between 0 and 1.
  final num g;

  /// Blue channel value, between 0 and 1.
  final num b;

  @override
  List<Object?> get props => <Object?>[r, g, b];

  Map<String, Object?> toJson() => _$RgbToJson(this);
}
