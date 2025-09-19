import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import 'blur_effect.dart';
import 'effect_type.dart';
import 'noise_effect.dart';
import 'shadow_effect.dart';
import 'texture_effect.dart';

part 'effect.g.dart';

@JsonSerializable()
@CopyWith()
@immutable
abstract class Effect extends Equatable {
  const Effect();

  factory Effect.fromJson(Map<String, Object?> json) {
    final discriminator = json['type'];
    final construct = switch (discriminator) {
      'DROP_SHADOW' || 'INNER_SHADOW' => ShadowEffect.fromJson,
      'LAYER_BLUR' || 'BACKGROUND_BLUR' => BlurEffect.fromJson,
      'TEXTURE' => TextureEffect.fromJson,
      'NOISE' => NoiseEffect.fromJson,
      _ => throw ArgumentError.value(discriminator, 'type', 'unknown type'),
    };

    return construct(json);
  }

  /// Discriminator for [Effect] types.
  EffectType get type;
  @override
  List<Object?> get props => <Object?>[];

  Map<String, Object?> toJson() => _$EffectToJson(this);
}
