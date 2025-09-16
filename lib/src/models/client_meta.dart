import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import 'frame_offset.dart';
import 'frame_offset_region.dart';
import 'region.dart';
import 'vector.dart';

/// Positioning information of the comment.
///
/// Includes information on the location of the comment pin, which is either the
/// absolute coordinates on the canvas or a relative offset within a frame. If
/// the comment is a region, it will also contain the region height, width, and
/// position of the anchor in regards to the region.
///
/// Union of the following types.
/// - [Vector]
/// - [FrameOffset]
/// - [Region]
/// - [FrameOffsetRegion]
typedef ClientMeta = Object;

@internal
class ClientMetaConverter implements JsonConverter<ClientMeta, Object> {
  const ClientMetaConverter();

  @override
  ClientMeta fromJson(Object json) {
    if (json is Map) {
      var construct = _unknown;

      if (json.containsKey('x')) {
        construct = json.containsKey('region_width')
            ? Region.fromJson
            : Vector.fromJson;
      } else if (json.containsKey('node_id')) {
        construct = json.containsKey('region_width')
            ? FrameOffsetRegion.fromJson
            : FrameOffset.fromJson;
      }

      return construct(json.cast<String, Object?>());
    }

    return _throw(json);
  }

  @override
  Object toJson(ClientMeta object) => switch (object) {
    Vector() => object.toJson(),
    FrameOffset() => object.toJson(),
    Region() => object.toJson(),
    FrameOffsetRegion() => object.toJson(),
    _ => _throw(object),
  };

  static Object _unknown(Map<String, Object?> json) => _throw(json);

  static Object _throw(Object json) =>
      throw ArgumentError.value(json, 'json', 'unknown type');
}

@internal
class ClientMetaNullableConverter
    implements JsonConverter<ClientMeta?, Object?> {
  const ClientMetaNullableConverter();

  @override
  ClientMeta? fromJson(Object? json) =>
      json != null ? const ClientMetaConverter().fromJson(json) : null;

  @override
  Object? toJson(ClientMeta? object) =>
      object != null ? const ClientMetaConverter().toJson(object) : null;
}
