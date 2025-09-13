import 'dart:io';

import 'package:code_builder/code_builder.dart' as code;
import 'package:dart_style/dart_style.dart';
import 'package:logging/logging.dart';
import 'package:yaml/yaml.dart';

import 'src/clone.dart';
import 'src/parse.dart';
import 'src/preprocess.dart';
import 'src/reference.dart';
import 'src/spec.dart';

const List<String> _allowList = <String>[
  'LocalVariable',
  'LocalVariableCollection',
  'LocalVariablesResponse',
  'LocalVariablesMeta',
  'VariableResolvedDataType',
  'VariableScope',
  'VariableCodeSyntax',
  'VariableData',
  'VariableDataType',
  'VariableDataValue',
  'Mode',
  'Rgba',
  'Rgb',
];

bool allowed(TypeDefinition definition) => _allowList.contains(definition.name);

final _formatter = DartFormatter(
  languageVersion: DartFormatter.latestLanguageVersion,
);

Future<File> writeLibrary(String path, code.Library library) {
  final emitter = code.DartEmitter(
    allocator: code.Allocator(),
    orderDirectives: true,
    useNullSafetySyntax: true,
  );

  final contents = _formatter.format('${library.accept(emitter)}');

  return File(path).writeAsString(contents);
}

Future<Map<String, Object?>> loadYamlFile(String path) async {
  final file = File(path);
  final contents = await file.readAsString();

  return cloneJsonMap(loadYaml(contents) as Map);
}

Future<void> main() async {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });

  final document = await loadYamlFile('tool/openapi.yaml');

  // Modify definition
  addDiscriminators(document);
  addTypeOverrides(document);

  final definitions = parseSchemaDefinitions(document);

  for (final definition in definitions) {
    if (allowed(definition)) {
      final library = schemaLibrary(definition);
      final path = 'lib/src/models/${definition.dartFile}';

      print('writing $path');
      await writeLibrary(path, library);
    } else {
      print('ignoring [${definition.name}] ${allowed(definition)}');
    }
  }

  print(_allowList);
}
