import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import 'base_type_style.dart';
import 'hyperlink.dart';
import 'line_height_unit.dart';
import 'paint.dart';
import 'semantic_italic.dart';
import 'semantic_weight.dart';
import 'text_align_horizontal.dart';
import 'text_align_vertical.dart';
import 'text_auto_resize.dart';
import 'text_case.dart';
import 'text_decoration.dart';
import 'text_truncation.dart';
import 'type_style_variables.dart';

part 'type_style.g.dart';

@JsonSerializable(explicitToJson: true)
@CopyWith()
@immutable
class TypeStyle extends Equatable with BaseTypeStyle {
  const TypeStyle({
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
    this.paragraphSpacing = 0,
    this.paragraphIndent = 0,
    this.listSpacing = 0,
    this.textDecoration = TextDecoration.none,
    this.textAutoResize = TextAutoResize.none,
    this.textTruncation = TextTruncation.disabled,
    this.maxLines,
    this.lineHeightPx,
    this.lineHeightPercent = 100,
    this.lineHeightPercentFontSize,
    this.lineHeightUnit,
    this.isOverrideOverTextStyle,
    this.boundVariables = const TypeStyleVariables(),
  });

  factory TypeStyle.fromJson(Map<String, Object?> json) =>
      _$TypeStyleFromJson(json);

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

  /// Space between paragraphs in px, 0 if not present.
  @JsonKey(defaultValue: 0)
  final num paragraphSpacing;

  /// Paragraph indentation in px, 0 if not present.
  @JsonKey(defaultValue: 0)
  final num paragraphIndent;

  /// Space between list items in px, 0 if not present.
  @JsonKey(defaultValue: 0)
  final num listSpacing;

  /// Text decoration applied to the node, default is none.
  @JsonKey(defaultValue: TextDecoration.none)
  final TextDecoration textDecoration;

  /// Dimensions along which text will auto resize, default is that the text does not auto-resize. TRUNCATE means that the text will be shortened and trailing text will be replaced with "…" if the text contents is larger than the bounds. `TRUNCATE` as a return value is deprecated and will be removed in a future version. Read from `textTruncation` instead.
  @JsonKey(defaultValue: TextAutoResize.none)
  final TextAutoResize textAutoResize;

  /// Whether this text node will truncate with an ellipsis when the text contents is larger than the text node.
  @JsonKey(defaultValue: TextTruncation.disabled)
  final TextTruncation textTruncation;

  /// When `textTruncation: "ENDING"` is set, `maxLines` determines how many lines a text node can grow to before it truncates.
  @JsonKey(includeIfNull: false)
  final num? maxLines;

  /// Line height in px.
  @JsonKey(includeIfNull: false)
  final num? lineHeightPx;

  /// Line height as a percentage of normal line height. This is deprecated; in a future version of the API only lineHeightPx and lineHeightPercentFontSize will be returned.
  @JsonKey(defaultValue: 100)
  final num lineHeightPercent;

  /// Line height as a percentage of the font size. Only returned when `lineHeightPercent` (deprecated) is not 100.
  @JsonKey(includeIfNull: false)
  final num? lineHeightPercentFontSize;

  /// The unit of the line height value specified by the user.
  @JsonKey(includeIfNull: false)
  final LineHeightUnit? lineHeightUnit;

  /// Whether or not this style has overrides over a text style. The possible fields to override are semanticWeight, semanticItalic, hyperlink, and textDecoration. If this is true, then those fields are overrides if present.
  @JsonKey(includeIfNull: false)
  final bool? isOverrideOverTextStyle;

  /// The variables bound to a particular field on this style
  final TypeStyleVariables boundVariables;

  @override
  List<Object?> get props => <Object?>[
    paragraphSpacing,
    paragraphIndent,
    listSpacing,
    textDecoration,
    textAutoResize,
    textTruncation,
    maxLines,
    lineHeightPx,
    lineHeightPercent,
    lineHeightPercentFontSize,
    lineHeightUnit,
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

  Map<String, Object?> toJson() => _$TypeStyleToJson(this);
}
