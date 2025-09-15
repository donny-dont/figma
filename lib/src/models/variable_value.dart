import 'package:json_annotation/json_annotation.dart';

import 'rgb.dart';
import 'rgba.dart';
import 'variable_alias.dart';

@VariableValueConverter()
typedef VariableValue = Object;

class VariableValueConverter implements JsonConverter<VariableValue, Object> {
  const VariableValueConverter();

  @override
  VariableValue fromJson(Object json) {
    if (json is Map) {
      var construct = _unknown;

      if (json.containsKey('id')) {
        construct = VariableAlias.fromJson;
      } else if (json.containsKey('r')) {
        construct = json.containsKey('a') ? Rgba.fromJson : Rgb.fromJson;
      } else if (json.containsKey('expressionFunction')) {}

      return construct(json.cast<String, Object?>());
    }

    return json;
  }

  @override
  Object toJson(VariableValue object) => switch (object) {
    Rgb() => object.toJson(),
    Rgba() => object.toJson(),
    _ => object,
  };

  static Object _unknown(Map<String, Object?> json) =>
      throw ArgumentError.value(json, 'json', 'unknown type');
}

class VariableValueMapConverter
    implements JsonConverter<Map<String, VariableValue>, Map<String, Object?>> {
  const VariableValueMapConverter();

  @override
  Map<String, VariableValue> fromJson(Map<String, Object?> json) => json.map(
    (k, v) => MapEntry<String, VariableValue>(
      k,
      const VariableValueConverter().fromJson(v!),
    ),
  );

  @override
  Map<String, Object?> toJson(Map<String, VariableValue> object) => object.map(
    (k, v) =>
        MapEntry<String, Object?>(k, const VariableValueConverter().toJson(v)),
  );
}
