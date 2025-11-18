// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dev_resources_response.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$DevResourcesResponseCWProxy {
  DevResourcesResponse devResources(List<DevResource> devResources);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `DevResourcesResponse(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// DevResourcesResponse(...).copyWith(id: 12, name: "My name")
  /// ```
  DevResourcesResponse call({List<DevResource> devResources});
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfDevResourcesResponse.copyWith(...)` or call `instanceOfDevResourcesResponse.copyWith.fieldName(value)` for a single field.
class _$DevResourcesResponseCWProxyImpl
    implements _$DevResourcesResponseCWProxy {
  const _$DevResourcesResponseCWProxyImpl(this._value);

  final DevResourcesResponse _value;

  @override
  DevResourcesResponse devResources(List<DevResource> devResources) =>
      call(devResources: devResources);

  @override
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `DevResourcesResponse(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// DevResourcesResponse(...).copyWith(id: 12, name: "My name")
  /// ```
  DevResourcesResponse call({
    Object? devResources = const $CopyWithPlaceholder(),
  }) {
    return DevResourcesResponse(
      devResources:
          devResources == const $CopyWithPlaceholder() || devResources == null
          ? _value.devResources
          // ignore: cast_nullable_to_non_nullable
          : devResources as List<DevResource>,
    );
  }
}

extension $DevResourcesResponseCopyWith on DevResourcesResponse {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfDevResourcesResponse.copyWith(...)` or `instanceOfDevResourcesResponse.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$DevResourcesResponseCWProxy get copyWith =>
      _$DevResourcesResponseCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DevResourcesResponse _$DevResourcesResponseFromJson(
  Map<String, dynamic> json,
) => DevResourcesResponse(
  devResources: (json['dev_resources'] as List<dynamic>)
      .map((e) => DevResource.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$DevResourcesResponseToJson(
  DevResourcesResponse instance,
) => <String, dynamic>{
  'dev_resources': instance.devResources.map((e) => e.toJson()).toList(),
};
