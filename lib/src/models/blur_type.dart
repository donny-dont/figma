import 'package:json_annotation/json_annotation.dart';

enum BlurType {
  @JsonValue('NORMAL')
  normal,
  @JsonValue('PROGRESSIVE')
  progressive,
}
