import 'package:json_annotation/json_annotation.dart';

/// The type of hyperlink. Can be either `URL` or `NODE`.
enum HyperlinkType {
  @JsonValue('URL')
  url,
  @JsonValue('NODE')
  node,
}
