import 'package:json_annotation/json_annotation.dart';

enum LineType {
  @JsonValue('NONE')
  none,
  @JsonValue('ORDERED')
  ordered,
  @JsonValue('UNORDERED')
  unordered,
}
