import 'package:change_case/change_case.dart';
import 'package:code_builder/code_builder.dart' as code;
import 'package:collection/collection.dart';
import 'package:test/test.dart';

import 'parse.dart';

code.TypeReference _type(
  String symbol, {
  bool isNullable = false,
  String? url,
}) => code.TypeReference(
  (t) => t
    ..symbol = symbol
    ..isNullable = isNullable
    ..url = url,
);

final code.TypeReference string = _type('String');

final code.TypeReference object = _type('Object');

final code.TypeReference objectNullable = _type('Object', isNullable: true);

final code.TypeReference json = map(string, objectNullable);

final code.TypeReference equatable = _type(
  'Equatable',
  url: 'package:equatable/equatable.dart',
);

final code.TypeReference props = list(objectNullable);

final code.TypeReference node = _type('Node', url: 'node.dart');

code.TypeReference map(code.Reference key, code.Reference value) =>
    code.TypeReference(
      (t) => t
        ..symbol = 'Map'
        ..types.addAll(<code.Reference>[key, value]),
    );

code.TypeReference list(code.Reference value) => code.TypeReference(
  (t) => t
    ..symbol = 'List'
    ..types.add(value),
);

code.Reference type(Type value) => value.definition.refer;

extension TypeReference on TypeDefinition {
  String? get dartFileWithoutExtension =>
      !this.type.isBuiltin ? name.toSnakeCase() : null;

  String? get dartFile {
    final base = dartFileWithoutExtension;
    if (base == null) {
      return null;
    }

    return '$base.dart';
  }

  String? get dartPartFile {
    final base = dartFileWithoutExtension;
    if (base == null) {
      return null;
    }

    return '$base.g.dart';
  }

  code.Reference get refer => code.refer(name, dartFile);

  code.Reference get referWithArguments {
    final typeArgument = this.type.typeArgument;
    final typeArguments = <code.Reference>[];

    if (typeArgument != null) {
      if (this.type.isMap) {
        typeArguments.add(code.refer('String'));
      }

      typeArguments.add(typeArgument.definition.refer);
    }

    return code.TypeReference(
      (t) => t
        ..symbol = name
        ..url = dartFile
        ..types.addAll(typeArguments),
    );
  }
}

extension PropertyReference on PropertyDefinition {
  code.Reference get refer => code.refer(name);
}

extension EnumReference on EnumDefinition {
  code.Expression dartValue(Object value) {
    final enumeration = values.firstWhereOrNull((e) => e.value == value);
    if (enumeration == null) {
      throw ArgumentError.value(value, 'value', 'not a valid enumeration');
    }

    return refer.property(enumeration.name);
  }
}

/*
extension UnionReference on Union {
  code.Reference? get dartExtends {
    final extend = metadata['x-dart-extends'] as String?;
    if (extend == null) {
      return null;
    }

    return root.get(extend).refer;
  }

  Map<String, String> get dartMapping {
    final meta = metadata['x-dart-mapping'] as Map?;
    if (meta != null) {
      return meta.cast<String, String>();
    }

    return mapping;
  }
}
*/
