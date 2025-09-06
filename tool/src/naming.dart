import 'package:change_case/change_case.dart';

import 'schema.dart';

extension SchemaNaming on Schema {
  String get dartName =>
      metadata['x-dart-name'] as String? ?? name.toPascalCase();
}

extension PropertyNaming on Property {
  String get dartName =>
      metadata['x-dart-name'] as String? ?? name.toCamelCase();
}

extension EnumNaming on Enum {
  Iterable<MapEntry<Object, String>> get dartValues sync* {
    final meta = metadata['x-dart-enum-values'] as List?;
    //print('$name $meta $values');

    final dartValues =
        (meta != null
                ? meta.cast<String>()
                : values.map((v) => v.toString().toCamelCase()))
            .toList();

    final length = values.length;
    for (var i = 0; i < length; ++i) {
      yield MapEntry<Object, String>(values[i], dartValues[i]);
    }
  }
}
