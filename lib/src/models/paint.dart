import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import 'blend_mode.dart';
import 'gradient_paint.dart';
import 'image_paint.dart';
import 'paint_type.dart';
import 'pattern_paint.dart';
import 'solid_paint.dart';

part 'paint.g.dart';

@JsonSerializable()
@CopyWith()
@immutable
abstract class Paint extends Equatable {
  const Paint({this.visible = true, this.opacity = 1, required this.blendMode});

  factory Paint.fromJson(Map<String, Object?> json) {
    final type = json['type'];
    final construct = switch (type) {
      'SOLID' => SolidPaint.fromJson,
      'GRADIENT_LINEAR' ||
      'GRADIENT_RADIAL' ||
      'GRADIENT_ANGULAR' ||
      'GRADIENT_DIAMOND' => GradientPaint.fromJson,
      'IMAGE' => ImagePaint.fromJson,
      'PATTERN' => PatternPaint.fromJson,
      _ => throw ArgumentError.value(type, 'type', 'unknown type'),
    };

    return construct(json);
  }

  PaintType get type;

  @JsonKey(defaultValue: true)
  final bool visible;

  @JsonKey(defaultValue: 1)
  final num opacity;

  final BlendMode blendMode;

  @override
  List<Object?> get props => <Object?>[type, visible, opacity, blendMode];

  Map<String, Object?> toJson();
}
