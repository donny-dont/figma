import 'json_map.dart';

/// Deep clone of a [JsonMap].
JsonMap cloneJsonMap(Map map) => Map<String, Object?>.fromEntries(
  map.entries.map(
    (e) => MapEntry<String, Object?>(e.key.toString(), _deepClone(e.value)),
  ),
);

Object? _deepClone(Object? value) => switch (value) {
  Map() => cloneJsonMap(value),
  List() => value.map(_deepClone).toList(),
  _ => value,
};
