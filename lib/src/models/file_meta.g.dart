// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_meta.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$FileMetaCWProxy {
  FileMeta name(String? name);

  FileMeta folderName(String? folderName);

  FileMeta lastTouchedAt(DateTime? lastTouchedAt);

  FileMeta creator(User? creator);

  FileMeta lastTouchedBy(User? lastTouchedBy);

  FileMeta thumbnailUrl(String? thumbnailUrl);

  FileMeta editorType(EditorType? editorType);

  FileMeta role(Role? role);

  FileMeta linkAccess(LinkAccess? linkAccess);

  FileMeta url(String? url);

  FileMeta version(String? version);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `FileMeta(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// FileMeta(...).copyWith(id: 12, name: "My name")
  /// ````
  FileMeta call({
    String? name,
    String? folderName,
    DateTime? lastTouchedAt,
    User? creator,
    User? lastTouchedBy,
    String? thumbnailUrl,
    EditorType? editorType,
    Role? role,
    LinkAccess? linkAccess,
    String? url,
    String? version,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfFileMeta.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfFileMeta.copyWith.fieldName(...)`
class _$FileMetaCWProxyImpl implements _$FileMetaCWProxy {
  const _$FileMetaCWProxyImpl(this._value);

  final FileMeta _value;

  @override
  FileMeta name(String? name) => this(name: name);

  @override
  FileMeta folderName(String? folderName) => this(folderName: folderName);

  @override
  FileMeta lastTouchedAt(DateTime? lastTouchedAt) =>
      this(lastTouchedAt: lastTouchedAt);

  @override
  FileMeta creator(User? creator) => this(creator: creator);

  @override
  FileMeta lastTouchedBy(User? lastTouchedBy) =>
      this(lastTouchedBy: lastTouchedBy);

  @override
  FileMeta thumbnailUrl(String? thumbnailUrl) =>
      this(thumbnailUrl: thumbnailUrl);

  @override
  FileMeta editorType(EditorType? editorType) => this(editorType: editorType);

  @override
  FileMeta role(Role? role) => this(role: role);

  @override
  FileMeta linkAccess(LinkAccess? linkAccess) => this(linkAccess: linkAccess);

  @override
  FileMeta url(String? url) => this(url: url);

  @override
  FileMeta version(String? version) => this(version: version);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `FileMeta(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// FileMeta(...).copyWith(id: 12, name: "My name")
  /// ````
  FileMeta call({
    Object? name = const $CopyWithPlaceholder(),
    Object? folderName = const $CopyWithPlaceholder(),
    Object? lastTouchedAt = const $CopyWithPlaceholder(),
    Object? creator = const $CopyWithPlaceholder(),
    Object? lastTouchedBy = const $CopyWithPlaceholder(),
    Object? thumbnailUrl = const $CopyWithPlaceholder(),
    Object? editorType = const $CopyWithPlaceholder(),
    Object? role = const $CopyWithPlaceholder(),
    Object? linkAccess = const $CopyWithPlaceholder(),
    Object? url = const $CopyWithPlaceholder(),
    Object? version = const $CopyWithPlaceholder(),
  }) {
    return FileMeta(
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String?,
      folderName: folderName == const $CopyWithPlaceholder()
          ? _value.folderName
          // ignore: cast_nullable_to_non_nullable
          : folderName as String?,
      lastTouchedAt: lastTouchedAt == const $CopyWithPlaceholder()
          ? _value.lastTouchedAt
          // ignore: cast_nullable_to_non_nullable
          : lastTouchedAt as DateTime?,
      creator: creator == const $CopyWithPlaceholder()
          ? _value.creator
          // ignore: cast_nullable_to_non_nullable
          : creator as User?,
      lastTouchedBy: lastTouchedBy == const $CopyWithPlaceholder()
          ? _value.lastTouchedBy
          // ignore: cast_nullable_to_non_nullable
          : lastTouchedBy as User?,
      thumbnailUrl: thumbnailUrl == const $CopyWithPlaceholder()
          ? _value.thumbnailUrl
          // ignore: cast_nullable_to_non_nullable
          : thumbnailUrl as String?,
      editorType: editorType == const $CopyWithPlaceholder()
          ? _value.editorType
          // ignore: cast_nullable_to_non_nullable
          : editorType as EditorType?,
      role: role == const $CopyWithPlaceholder()
          ? _value.role
          // ignore: cast_nullable_to_non_nullable
          : role as Role?,
      linkAccess: linkAccess == const $CopyWithPlaceholder()
          ? _value.linkAccess
          // ignore: cast_nullable_to_non_nullable
          : linkAccess as LinkAccess?,
      url: url == const $CopyWithPlaceholder()
          ? _value.url
          // ignore: cast_nullable_to_non_nullable
          : url as String?,
      version: version == const $CopyWithPlaceholder()
          ? _value.version
          // ignore: cast_nullable_to_non_nullable
          : version as String?,
    );
  }
}

extension $FileMetaCopyWith on FileMeta {
  /// Returns a callable class that can be used as follows: `instanceOfFileMeta.copyWith(...)` or like so:`instanceOfFileMeta.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$FileMetaCWProxy get copyWith => _$FileMetaCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FileMeta _$FileMetaFromJson(Map<String, dynamic> json) => FileMeta(
      name: json['name'] as String?,
      folderName: json['folder_name'] as String?,
      lastTouchedAt: json['last_touched_at'] == null
          ? null
          : DateTime.parse(json['last_touched_at'] as String),
      creator: json['creator'] == null
          ? null
          : User.fromJson(json['creator'] as Map<String, dynamic>),
      lastTouchedBy: json['last_touched_by'] == null
          ? null
          : User.fromJson(json['last_touched_by'] as Map<String, dynamic>),
      thumbnailUrl: json['thumbnail_url'] as String?,
      editorType: $enumDecodeNullable(_$EditorTypeEnumMap, json['editorType']),
      role: $enumDecodeNullable(_$RoleEnumMap, json['role']),
      linkAccess: $enumDecodeNullable(_$LinkAccessEnumMap, json['link_access']),
      url: json['url'] as String?,
      version: json['version'] as String?,
    );

Map<String, dynamic> _$FileMetaToJson(FileMeta instance) => <String, dynamic>{
      'name': instance.name,
      'folder_name': instance.folderName,
      'last_touched_at': instance.lastTouchedAt?.toIso8601String(),
      'creator': instance.creator,
      'last_touched_by': instance.lastTouchedBy,
      'thumbnail_url': instance.thumbnailUrl,
      'editorType': _$EditorTypeEnumMap[instance.editorType],
      'role': _$RoleEnumMap[instance.role],
      'link_access': _$LinkAccessEnumMap[instance.linkAccess],
      'url': instance.url,
      'version': instance.version,
    };

const _$EditorTypeEnumMap = {
  EditorType.figma: 'figma',
  EditorType.figjam: 'figjam',
  EditorType.slides: 'slides',
};

const _$RoleEnumMap = {
  Role.owner: 'owner',
  Role.editor: 'editor',
  Role.viewer: 'viewer',
};

const _$LinkAccessEnumMap = {
  LinkAccess.view: 'view',
  LinkAccess.edit: 'edit',
  LinkAccess.orgView: 'org_view',
  LinkAccess.orgEdit: 'org_edit',
  LinkAccess.inherit: 'inherit',
};
