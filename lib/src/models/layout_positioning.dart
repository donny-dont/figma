import 'package:json_annotation/json_annotation.dart';

/// Determines whether a layer's size and position should be determined by auto-layout settings or manually adjustable.
enum LayoutPositioning {
  @JsonValue('AUTO')
  auto,
  @JsonValue('ABSOLUTE')
  absolute,
}
