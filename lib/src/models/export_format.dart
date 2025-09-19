import 'package:json_annotation/json_annotation.dart';

enum ExportFormat {
  @JsonValue('JPG')
  jpg,
  @JsonValue('PNG')
  png,
  @JsonValue('SVG')
  svg,
  @JsonValue('PDF')
  pdf,
}
