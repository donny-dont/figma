import 'package:json_annotation/json_annotation.dart';

enum LinkAccess {
  @JsonValue('view')
  view,
  @JsonValue('edit')
  edit,
  @JsonValue('org_view')
  orgView,
  @JsonValue('org_edit')
  orgEdit,
  @JsonValue('inherit')
  inherit,
}
