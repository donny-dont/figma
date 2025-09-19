import 'package:json_annotation/json_annotation.dart';

enum PatternAlignment {
  @JsonValue('START')
  start,
  @JsonValue('CENTER')
  center,
  @JsonValue('END')
  end,
}
