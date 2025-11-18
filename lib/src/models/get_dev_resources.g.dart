// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_dev_resources.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$GetDevResourcesCWProxy {
  GetDevResources nodeIds(String? nodeIds);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `GetDevResources(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// GetDevResources(...).copyWith(id: 12, name: "My name")
  /// ```
  GetDevResources call({String? nodeIds});
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfGetDevResources.copyWith(...)` or call `instanceOfGetDevResources.copyWith.fieldName(value)` for a single field.
class _$GetDevResourcesCWProxyImpl implements _$GetDevResourcesCWProxy {
  const _$GetDevResourcesCWProxyImpl(this._value);

  final GetDevResources _value;

  @override
  GetDevResources nodeIds(String? nodeIds) => call(nodeIds: nodeIds);

  @override
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `GetDevResources(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// GetDevResources(...).copyWith(id: 12, name: "My name")
  /// ```
  GetDevResources call({Object? nodeIds = const $CopyWithPlaceholder()}) {
    return GetDevResources(
      nodeIds: nodeIds == const $CopyWithPlaceholder()
          ? _value.nodeIds
          // ignore: cast_nullable_to_non_nullable
          : nodeIds as String?,
    );
  }
}

extension $GetDevResourcesCopyWith on GetDevResources {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfGetDevResources.copyWith(...)` or `instanceOfGetDevResources.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$GetDevResourcesCWProxy get copyWith => _$GetDevResourcesCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetDevResources _$GetDevResourcesFromJson(Map<String, dynamic> json) =>
    GetDevResources(nodeIds: json['node_ids'] as String?);

Map<String, dynamic> _$GetDevResourcesToJson(GetDevResources instance) =>
    <String, dynamic>{'node_ids': ?instance.nodeIds};
