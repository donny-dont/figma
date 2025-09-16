import 'package:json_annotation/json_annotation.dart';

enum CommentPinCorner {
  @JsonValue('top-left')
  topLeft,
  @JsonValue('top-right')
  topRight,
  @JsonValue('bottom-left')
  bottomLeft,
  @JsonValue('bottom-right')
  bottomRight,
}
