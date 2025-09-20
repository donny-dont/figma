// Generated from v0.33.0 of the Figma REST API specification

import 'package:json_annotation/json_annotation.dart';

/// Type of constraint to apply.
enum ConstraintType {
  /// Scale by `value`.
  @JsonValue('SCALE')
  scale,

  /// Scale proportionally and set width to `value`.
  @JsonValue('WIDTH')
  width,

  /// Scale proportionally and set height to `value`.
  @JsonValue('HEIGHT')
  height,
}
