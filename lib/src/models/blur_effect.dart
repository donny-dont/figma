import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import 'blur_effect_variables.dart';
import 'blur_type.dart';
import 'effect.dart';
import 'effect_type.dart';
import 'normal_blur_effect.dart';
import 'progressive_blur_effect.dart';

part 'blur_effect.g.dart';

@JsonSerializable(explicitToJson: true)
@CopyWith()
@immutable
abstract class BlurEffect extends Effect {
  const BlurEffect({
    required this.type,
    required this.visible,
    required this.radius,
    this.boundVariables = const BlurEffectVariables(),
  });

  factory BlurEffect.fromJson(Map<String, Object?> json) {
    final discriminator = json['blurType'];
    final construct = switch (discriminator) {
      'NORMAL' => NormalBlurEffect.fromJson,
      'PROGRESSIVE' => ProgressiveBlurEffect.fromJson,
      _ => throw ArgumentError.value(
        discriminator,
        'blurType',
        'unknown blurType',
      ),
    };

    return construct(json);
  }

  /// A string literal representing the effect's type. Always check the type before reading other properties.
  final EffectType type;

  /// Whether this blur is active.
  final bool visible;

  /// Radius of the blur effect
  final num radius;

  /// The variables bound to a particular field on this blur effect
  @JsonKey(defaultValue: {})
  final BlurEffectVariables boundVariables;

  /// Discriminator for [BlurEffect] types.
  BlurType get blurType;
  @override
  List<Object?> get props => <Object?>[
    ...super.props,
    type,
    visible,
    radius,
    boundVariables,
  ];

  @override
  Map<String, Object?> toJson() => _$BlurEffectToJson(this);
}
