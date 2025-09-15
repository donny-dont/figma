import 'package:json_annotation/json_annotation.dart';

enum VariableResolvedDataType {
  @JsonValue('BOOLEAN')
  boolean,
  @JsonValue('FLOAT')
  float,
  @JsonValue('STRING')
  string,
  @JsonValue('COLOR')
  color,
}
