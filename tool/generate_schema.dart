import 'dart:io';

import 'package:change_case/change_case.dart';
import 'package:code_builder/code_builder.dart' as code;
import 'package:dart_style/dart_style.dart';
import 'package:yaml/yaml.dart';

import 'src/schema.dart';
import 'src/spec.dart';

List<String> _allowList = <String>[
  'LocalVariable',
  'LocalVariableCollection',
  'LocalVariablesResponse',
  'LocalVariablesMeta',
  'VariableScope',
  'VariableCodeSyntax',
  'Mode',
  'RGBA',
  'RGB',
];

List<String> _denyList = <String>['VariableValue', 'Transform', 'Emoji'];

bool allowed(Schema schema) => !_denyList.contains(schema.name);
//_allowList.contains(schema.name);

final formatter = DartFormatter(
  languageVersion: DartFormatter.latestLanguageVersion,
);

Map<String, Object?> mapFromPath(
  List<String> path,
  Map<String, Object?> value,
) {
  var map = value;

  for (final segment in path) {
    map = (map[segment]! as Map).cast<String, Object?>();
  }

  return map;
}

Future<File> writeLibrary(String path, code.Library library) {
  final emitter = code.DartEmitter(
    allocator: code.Allocator(),
    orderDirectives: true,
    useNullSafetySyntax: true,
  );

  final contents = formatter.format('${library.accept(emitter)}');

  return File(path).writeAsString(contents);
}

Future<Map<String, Object?>> loadYamlFile(String path) async {
  final file = File(path);
  final contents = await file.readAsString();

  return (loadYaml(contents) as Map).cast<String, Object?>();
}

Future<void> main() async {
  final document = await loadYamlFile('tool/openapi.yaml');
  final definitions = mapFromPath(<String>['components', 'schemas'], document);

  final schemas = Schemas();

  for (final entry in definitions.entries) {
    schemas.add(entry.key, (entry.value as Map).cast<String, Object?>());
  }

  final localVariablesMeta = mapFromPath(<String>[
    'components',
    'responses',
    'GetLocalVariablesResponse',
    'content',
    'application/json',
    'schema',
  ], document);

  //schemas.add('LocalVariablesResponse', localVariablesMeta);

  final writes = <Future<File>>[];

  for (final schema in schemas.schemas.where(allowed)) {
    final library = schemaLibrary(schema);
    final path = 'lib/src/models/${schema.name.toSnakeCase()}.dart';
    writes.add(writeLibrary(path, library));
  }

  final files = await Future.wait(writes);
  for (final file in files) {
    print('wrote ${file.path}');
  }
}
