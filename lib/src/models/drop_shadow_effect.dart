import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import 'effect_type.dart';
import 'shadow_effect.dart';
import 'shadow_effect_variables.dart';

part 'drop_shadow_effect.g.dart';

@JsonSerializable(explicitToJson: true)
@CopyWith()
@immutable
class DropShadowEffect extends ShadowEffect {
  const DropShadowEffect({
    required super.color,
    required super.blendMode,
    required super.offset,
    required super.radius,
    super.spread = 0,
    required super.visible,
    super.boundVariables = const ShadowEffectVariables(),
    required this.showShadowBehindNode,
  });

  factory DropShadowEffect.fromJson(Map<String, Object?> json) =>
      _$DropShadowEffectFromJson(json);

  /// Whether to show the shadow behind translucent or transparent pixels
  final bool showShadowBehindNode;

  /// A string literal representing the effect's type. Always check the type before reading other properties.
  @override
  EffectType get type => EffectType.dropShadow;

  @override
  List<Object?> get props => <Object?>[...super.props, showShadowBehindNode];

  @override
  Map<String, Object?> toJson() => _$DropShadowEffectToJson(this);
}
