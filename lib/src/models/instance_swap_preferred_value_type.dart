import 'package:json_annotation/json_annotation.dart';

/// Type of node for this preferred value.
enum InstanceSwapPreferredValueType {
  @JsonValue('COMPONENT')
  component,
  @JsonValue('COMPONENT_SET')
  componentSet,
}
