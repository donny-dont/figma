import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import 'noise_effect.dart';
import 'noise_type.dart';

part 'monotone_noise_effect.g.dart';

@JsonSerializable(explicitToJson: true)
@CopyWith()
@immutable
class MonotoneNoiseEffect extends NoiseEffect {
  const MonotoneNoiseEffect({
    required super.color,
    required super.visible,
    required super.blendMode,
    required super.noiseSize,
    required super.density,
  });

  factory MonotoneNoiseEffect.fromJson(Map<String, Object?> json) =>
      _$MonotoneNoiseEffectFromJson(json);

  /// The string literal 'MONOTONE' representing the noise type.
  @override
  NoiseType get noiseType => NoiseType.monotone;

  @override
  List<Object?> get props => <Object?>[...super.props, noiseType];

  @override
  Map<String, Object?> toJson() => _$MonotoneNoiseEffectToJson(this);
}
