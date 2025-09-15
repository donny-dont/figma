import 'package:json_annotation/json_annotation.dart';

enum EditorType {
  @JsonValue('figma')
  figma,
  @JsonValue('figjam')
  figjam,
}
