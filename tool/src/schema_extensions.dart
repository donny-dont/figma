import 'json_map.dart';

/// Helpers to gather extensions present in the schema.
///
/// OpenAPI allows vendor extensions to specify additional functionality and
/// improve the code generated. By convention an extension starts with `x-`.
extension SchemaExtensions on JsonMap {
  /// Retrieve all extensions on the schema.
  JsonMap get extensions => Map<String, Object?>.fromEntries(
    entries.where((e) => e.key.startsWith('x-')),
  );
}

/// Specifies when the schema should be named differently.
extension OverrideName on JsonMap {
  static const String _key = 'x-dart-name';

  /// Whether the schema has a name.
  bool get hasNameOverride => containsKey(_key);

  /// The name for the schema; if present.
  String? get nameOverride => this[_key] as String?;
  set name(String? value) {
    putOrRemove(_key, value);
  }
}

/// Specifies when the schema should have a different type.
///
/// This extension is meant for values in `properties` and not for the name of
/// a data type. For those use [OverrideName].
extension OverrideType on JsonMap {
  static const String _key = 'x-dart-type';

  /// Whether the schema has a type.
  bool get hasTypeOverride => containsKey(_key);

  /// The type for the schema; if present.
  String? get typeOverride => this[_key] as String?;
  set typeOverride(String? value) {
    putOrRemove(_key, value);
  }
}

/// Specifies the naming of enum values for the schema.
///
/// This extension is used to override the default naming of enumeration values.
/// It is necessary when an enumeration uses an integer type.
extension OverrideEnumerationNames on JsonMap {
  static const String _key = 'x-dart-enum-names';

  /// Whether the schema has enum values.
  bool get hasEnumerationNames => containsKey(_key);

  /// The enumeration values; or the empty list if not present.
  List<String> get enumerationNames => getList(_key);
  set enumerationNames(List<String> value) {
    putOrRemoveList(_key, value);
  }
}

/// Specifies when a schema property is being used as a discriminator.
///
/// When a `one-of` definition is used for a schema it can have an associated
/// `discriminator` that provides a type mapping. This extension allows a
/// property to be marked with the type of the discriminator.
extension PropertyDiscriminatorType on JsonMap {
  static const String _key = 'x-dart-discriminator';

  /// Whether the property is a discriminator.
  bool get isDiscriminatorType => containsKey(_key);

  /// The type of the discriminator; if present.
  String? get discriminatorType => this[_key] as String?;
  set discriminatorType(String? value) {
    putOrRemove(_key, value);
  }
}

extension OverrideMapping on JsonMap {
  static const String _key = 'x-dart-mapping';

  bool get hasMappingOverride => containsKey(_key);

  Map<String, String> get mappingOverride => getMap<String, String>(_key);
  set mappingOverride(Map<String, String> value) {
    putOrRemoveMap(_key, value);
  }
}
