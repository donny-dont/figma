import 'package:json_annotation/json_annotation.dart';

/// Component property type.
enum ComponentPropertyType {
  @JsonValue('BOOLEAN')
  boolean,
  @JsonValue('INSTANCE_SWAP')
  instanceSwap,
  @JsonValue('TEXT')
  text,
  @JsonValue('VARIANT')
  variant,
}
