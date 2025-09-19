import 'package:json_annotation/json_annotation.dart';

/// Vertical text alignment as string enum.
enum TextAlignVertical {
  @JsonValue('TOP')
  top,
  @JsonValue('CENTER')
  center,
  @JsonValue('BOTTOM')
  bottom,
}
