import 'package:json_annotation/json_annotation.dart';

/// Indicates if the object is a file on Figma Design or FigJam.
enum EditorType {
  @JsonValue('figma')
  figma,
  @JsonValue('figjam')
  figjam,
}
