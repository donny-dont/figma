/// Contains functions to modify the schema values before converting.
///
/// Used to work around any corner cases or weirdness within the schema
/// definition.
library;

/// Maps the name.
String name(String name) => name;

/// Modifies the schema value.
Map<String, Object?> schema(String name, Map<String, Object?> schema) => schema;
