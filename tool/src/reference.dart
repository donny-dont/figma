import 'package:change_case/change_case.dart';
import 'package:code_builder/code_builder.dart';

TypeReference _type(String symbol, {bool isNullable = false, String? url}) =>
    TypeReference(
      (t) => t
        ..symbol = symbol
        ..isNullable = isNullable
        ..url = url,
    );

final TypeReference string = _type('String');

final TypeReference object = _type('Object');

final TypeReference objectNullable = _type('Object', isNullable: true);

final TypeReference json = map(string, objectNullable);

final TypeReference equatable = _type(
  'Equatable',
  url: 'package:equatable/equatable.dart',
);

final TypeReference props = list(objectNullable);

final TypeReference node = _type('Node', url: 'node.dart');

TypeReference model(String name) =>
    _type(name, url: '${name.toSnakeCase()}.dart');

TypeReference map(Reference key, Reference value) => TypeReference(
  (t) => t
    ..symbol = 'Map'
    ..types.addAll(<Reference>[key, value]),
);

TypeReference list(Reference value) => TypeReference(
  (t) => t
    ..symbol = 'List'
    ..types.add(value),
);
