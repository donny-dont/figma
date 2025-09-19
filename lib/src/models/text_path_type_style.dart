import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import 'base_type_style.dart';
import 'hyperlink.dart';
import 'paint.dart';
import 'semantic_italic.dart';
import 'semantic_weight.dart';
import 'text_align_horizontal.dart';
import 'text_align_vertical.dart';
import 'text_case.dart';
import 'text_path_type_style_variables.dart';

part 'text_path_type_style.g.dart';

@JsonSerializable(explicitToJson: true)
@CopyWith()
@immutable
class TextPathTypeStyle extends Equatable with BaseTypeStyle {
  const TextPathTypeStyle({
    this.fontFamily,
    this.fontPostScriptName,
    this.fontStyle,
    this.italic = false,
    this.fontWeight,
    this.fontSize,
    this.textCase,
    this.textAlignHorizontal,
    this.textAlignVertical,
    this.letterSpacing,
    this.fills = const [],
    this.hyperlink,
    this.opentypeFlags = const {},
    this.semanticWeight,
    this.semanticItalic,
    this.isOverrideOverTextStyle,
    this.boundVariables = const TextPathTypeStyleVariables(),
  });

  factory TextPathTypeStyle.fromJson(Map<String, Object?> json) =>
      _$TextPathTypeStyleFromJson(json);

  /// Font family of text (standard name).
  @JsonKey(includeIfNull: false)
  final String? fontFamily;

  /// PostScript font name.
  @JsonKey(includeIfNull: false)
  final String? fontPostScriptName;

  /// Describes visual weight or emphasis, such as Bold or Italic.
  @JsonKey(includeIfNull: false)
  final String? fontStyle;

  /// Whether or not text is italicized.
  @JsonKey(defaultValue: false)
  final bool italic;

  /// Numeric font weight.
  @JsonKey(includeIfNull: false)
  final num? fontWeight;

  /// Font size in px.
  @JsonKey(includeIfNull: false)
  final num? fontSize;

  /// Text casing applied to the node, default is the original casing.
  @JsonKey(includeIfNull: false)
  final TextCase? textCase;

  /// Horizontal text alignment as string enum.
  @JsonKey(includeIfNull: false)
  final TextAlignHorizontal? textAlignHorizontal;

  /// Vertical text alignment as string enum.
  @JsonKey(includeIfNull: false)
  final TextAlignVertical? textAlignVertical;

  /// Space between characters in px.
  @JsonKey(includeIfNull: false)
  final num? letterSpacing;

  /// An array of fill paints applied to the characters.
  @JsonKey(defaultValue: [])
  final List<Paint> fills;

  /// Link to a URL or frame.
  @JsonKey(includeIfNull: false)
  final Hyperlink? hyperlink;

  /// A map of OpenType feature flags to 1 or 0, 1 if it is enabled and 0 if it is disabled. Note that some flags aren't reflected here. For example, SMCP (small caps) is still represented by the `textCase` field.
  @JsonKey(defaultValue: {})
  final Map<String, num> opentypeFlags;

  /// Indicates how the font weight was overridden when there is a text style override.
  @JsonKey(includeIfNull: false)
  final SemanticWeight? semanticWeight;

  /// Indicates how the font style was overridden when there is a text style override.
  @JsonKey(includeIfNull: false)
  final SemanticItalic? semanticItalic;

  /// Whether or not this style has overrides over a text style. The possible fields to override are semanticWeight, semanticItalic, and hyperlink. If this is true, then those fields are overrides if present.
  @JsonKey(includeIfNull: false)
  final bool? isOverrideOverTextStyle;

  /// The variables bound to a particular field on this style
  final TextPathTypeStyleVariables boundVariables;

  @override
  List<Object?> get props => <Object?>[
    isOverrideOverTextStyle,
    boundVariables,
    fontFamily,
    fontPostScriptName,
    fontStyle,
    italic,
    fontWeight,
    fontSize,
    textCase,
    textAlignHorizontal,
    textAlignVertical,
    letterSpacing,
    fills,
    hyperlink,
    opentypeFlags,
    semanticWeight,
    semanticItalic,
  ];

  Map<String, Object?> toJson() => _$TextPathTypeStyleToJson(this);
}
